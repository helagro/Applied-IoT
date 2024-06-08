import paho.mqtt.client as mqtt
from values import Sensor
from automations import execute

def onMessage(client, userData, msg):
    device = msg.topic.split("/")[-1]
    print("Device:", device, end="  ")

    if msg.topic.startswith(Sensor.TEMPERATURE.value):
        print("Temperature:", msg.payload.decode())
        execute(Sensor.TEMPERATURE, float(msg.payload.decode()))

    elif msg.topic.startswith(Sensor.MOTION.value):
        print("Motion detected:", msg.payload.decode())
        execute(Sensor.MOTION, msg.payload.decode() == "True")

    else:
        print("Unknown topic:", msg.topic + ":", msg.payload.decode())


def onConnect(client, userdata, flags, reason_code, properties):
    client.subscribe("#")


client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = onConnect
client.on_message = onMessage


def connect():
    client.connect("localhost", 1883, 60)
    client.loop_forever()
