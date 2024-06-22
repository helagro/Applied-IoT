import paho.mqtt.client as mqtt
from sensor import Sensor
from db import write
from automations import execute


def on_message(client, userData, msg: any) -> None:
    try:
        device: int = int(msg.topic.split("/")[-1])
        print("Device:", device, end="  ")
    except ValueError:
        print("Invalid device ID:", msg.topic)

    try:
        value = float(msg.payload.decode())
    except ValueError:
        print("Invalid value:", msg.payload.decode())
        return

    if msg.topic.startswith(Sensor.TEMPERATURE.value):
        print("Temperature:", value)
        execute(Sensor.TEMPERATURE.value, value, device)
        write(device, Sensor.TEMPERATURE.value, value)

    elif msg.topic.startswith(Sensor.MOTION.value):
        print("Motion detected:", value)
        execute(Sensor.MOTION.value, value, device)
        write(device, Sensor.MOTION.value, value)

    elif msg.topic.startswith(Sensor.BUTTON.value):
        print("Button pressed:", value)
        execute(Sensor.BUTTON.value, value, device)
        write(device, Sensor.BUTTON.value, value)

    elif msg.topic.startswith(Sensor.LIGHT.value):
        print("Light intensity:", value)
        execute(Sensor.LIGHT.value, value, device)
        write(device, Sensor.LIGHT.value, value)

    else:
        print("Unknown topic:", msg.topic + ":", msg.payload.decode())



def on_connect(client, userdata, flags, reason_code, properties):
    client.subscribe("#")


client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = on_connect
client.on_message = on_message


def connect() -> None:
    client.connect("broker", 1883, 60)
    client.loop_forever()
