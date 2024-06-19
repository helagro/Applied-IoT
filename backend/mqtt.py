import paho.mqtt.client as mqtt
from backend.sensor import Sensor
from automations import execute

def on_message(client, userData, msg: any) -> None:
    try:
        device: int = int(msg.topic.split("/")[-1])
        print("Device:", device, end="  ")
    except ValueError:
        print("Invalid device ID:", msg.topic)

    if msg.topic.startswith(Sensor.TEMPERATURE.value):
        print("Temperature:", msg.payload.decode())
        execute(Sensor.TEMPERATURE.value, float(msg.payload.decode()), device)

    elif msg.topic.startswith(Sensor.MOTION.value):
        print("Motion detected:", msg.payload.decode())
        execute(Sensor.MOTION.value, msg.payload.decode() == "True", device)

    elif msg.topic.startswith(Sensor.BUTTON.value):
        print("Button pressed:", msg.payload.decode())
        execute(Sensor.BUTTON.value, msg.payload.decode() == "True", device)

    elif msg.topic.startswith(Sensor.LIGHT.value):
        print("Light intensity:", msg.payload.decode())
        execute(Sensor.LIGHT.value, float(msg.payload.decode()), device)

    else:
        print("Unknown topic:", msg.topic + ":", msg.payload.decode())


def on_connect(client, userdata, flags, reason_code, properties):
    client.subscribe("#")


client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = on_connect
client.on_message = on_message


def connect() -> None:
    client.connect("localhost", 1883, 60)
    client.loop_forever()
