import motion
import time
from machine import Pin
from temperature import getTemperature
import wifi
from mqtt import MQTTClient

# ------------------------- VARIABLES ------------------------ #

MOTION_POLL_INTERVAL = 3
TEMP_POLL_INTERVAL = 30

TEMP_COUNTER_MAX = TEMP_POLL_INTERVAL // MOTION_POLL_INTERVAL
tempCounter = 0

# ----------------------- PIN SETUP ---------------------- #

LED = Pin("LED", Pin.OUT)
LED.off()

# ----------------------- NETWORK SETUP ---------------------- #

wifi.connect()
client = MQTTClient()
client.connect()
client.publish("test/topic", "RP2 is online")

# ------------------------- MAIN LOOP ------------------------ #

while True:
    if(tempCounter >= TEMP_COUNTER_MAX):
        client.publish("temperature", str(getTemperature()))
        tempCounter = 0

    if motion.doesDetect():
        print("Motion detected!")
        client.publish("motion", "True")
        LED.on()
    else:
        client.publish("motion", "False")
        LED.off()

    time.sleep(MOTION_POLL_INTERVAL)
    tempCounter += 1

   