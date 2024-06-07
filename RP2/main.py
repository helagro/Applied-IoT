import motion
import time
from machine import Pin
from temperature import getTemperature
import wifi
from mqtt import MQTTClient
from get_env import getDEVICE_ID

# ------------------------- VARIABLES ------------------------ #

MOTION_POLL_INTERVAL = 3
TEMP_POLL_INTERVAL = 30

TEMP_COUNTER_MAX = TEMP_POLL_INTERVAL // MOTION_POLL_INTERVAL
tempCounter = 0

deviceID = getDEVICE_ID()

# ----------------------- PIN SETUP ---------------------- #

LED = Pin("LED", Pin.OUT)
LED.off()

# ----------------------- NETWORK SETUP ---------------------- #

wifi.connect()
client = MQTTClient()
client.connect()
client.publish("log", "RP2 is online")

# ------------------------- MAIN LOOP ------------------------ #

while True:
    if(tempCounter >= TEMP_COUNTER_MAX):
        client.publish(f"temperature/{deviceID}", str(getTemperature()))
        tempCounter = 0

    if motion.doesDetect():
        print("Motion detected!")
        client.publish(f"motion/{deviceID}", "True")
        LED.on()
    else:
        client.publish(f"motion/{deviceID}", "False")
        LED.off()

    time.sleep(MOTION_POLL_INTERVAL)
    tempCounter += 1

   