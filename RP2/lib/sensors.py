# -------------------------- IMPORTS ------------------------- #

from machine import Pin
import dht
import machine
from get_env import getDisabledSensors

# ---------------------- SETUP SENSORS --------------------- #

if "motion" not in getDisabledSensors():
    motionPin = Pin(21, Pin.IN, Pin.PULL_UP)

if "temperature" not in getDisabledSensors():
    tempSensor = dht.DHT11(machine.Pin(27))

if "button" not in getDisabledSensors():
    btnPin = Pin(16, Pin.IN)


# -------------------------- GETTERS ------------------------- #

def doesDetectMotion() -> bool:
    if "motion" in getDisabledSensors():
        return False
    return motionPin.value() == 1


def getTemperature() -> float | None:
    if "temperature" in getDisabledSensors():
        return None
    try:
        tempSensor.measure()
        return tempSensor.temperature()
    except Exception as error:
        print("E-1", error)
        return None
    

def isBtnPressed() -> bool:
    if "button" in getDisabledSensors():
        return False
    return btnPin.value() == False