import time
import wifi
from mqtt import MQTTClient
from get_env import getDEVICE_ID, getDisabledSensors
import sensors

# ------------------------- VARIABLES ------------------------ #

deviceID = getDEVICE_ID()

# Polling intervals in seconds
MAIN_POLL_INTERVAL = 1
MOTION_POLL_INTERVAL = 10
TEMP_POLL_INTERVAL = 10

# Max values for counters to determine when to poll
motionCounterMax = MOTION_POLL_INTERVAL // MAIN_POLL_INTERVAL
tempCounterMax = TEMP_POLL_INTERVAL // MAIN_POLL_INTERVAL

# Poll counters
motionCounter = motionCounterMax
tempCounter = tempCounterMax

# Previous values
prevMotion = False
prevTemp = 0
prevBtn = False

# ----------------------- NETWORK SETUP ---------------------- #

wifi.connect()
client = MQTTClient()
client.connect()
client.publish("log", "RP2 is online :)")

# -------------------------- METHODS ------------------------- #

def pollMotion():
    global prevMotion
    detectsMotion = sensors.doesDetectMotion()

    if detectsMotion:
        client.publish(f"motion/{deviceID}", "True")
    elif prevMotion == True: # so doesn't spam broker with "False" messages
        client.publish(f"motion/{deviceID}", "False")

    prevMotion = detectsMotion


def pollTemp():
    global prevTemp
    temp = sensors.getTemperature()

    if temp != prevTemp:
        client.publish(f"temperature/{deviceID}", str(temp))

    prevTemp = temp


def pollBtn():
    global prevBtn
    btnPressed = sensors.isBtnPressed()
    if prevBtn == btnPressed: return

    if btnPressed:
        client.publish(f"button/{deviceID}", "True")
    else:
        client.publish(f"button/{deviceID}", "False")

    prevBtn = btnPressed

# ------------------------- MAIN LOOP ------------------------ #

print("Disabled sensors:", getDisabledSensors())

while True:
    if(motionCounter >= motionCounterMax):
        pollMotion()
        motionCounter = 0

    if(tempCounter >= tempCounterMax):
        pollTemp()
        tempCounter = 0

    pollBtn()

    time.sleep(MAIN_POLL_INTERVAL)

    # Increment counters
    motionCounter += 1
    tempCounter += 1

   