import paho.mqtt.client as mqtt

def onMessage(client, userData, msg):
    device = msg.topic.split("/")[-1]
    print("Device:", device, end="  ")

    if msg.topic == "temperature":
        print("Temperature:", msg.payload.decode())
    elif msg.topic.startswith("motion"):
        print("Motion detected:", msg.payload.decode())
    else:
        print("Unknown topic:", msg.topic + ":", msg.payload.decode())

def onConnect(client, userdata, flags, reason_code, properties):
    client.subscribe("#")

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = onConnect
client.on_message = onMessage

client.connect("localhost", 1883, 60)
client.loop_forever()
