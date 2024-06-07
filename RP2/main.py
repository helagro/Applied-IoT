import motion
import time
from machine import Pin
from temperature import getTemperature
import wifi
from mqtt import MQTTClient

wifi.connect()

LED = Pin("LED", Pin.OUT)
LED.off()
client = MQTTClient()

client.connect()
client.publish("test/topic", "RP2 is online")

while True:
    print("Temperature: ", getTemperature(), "Motion?: ", motion.doesDetect())
    time.sleep(20)

   