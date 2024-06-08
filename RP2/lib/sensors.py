# -------------------------- IMPORTS ------------------------- #

from machine import Pin
import dht
import machine

# ---------------------- SETUP SENSORS --------------------- #

motionPin = Pin(21, Pin.IN, Pin.PULL_UP)
tempSensor = dht.DHT11(machine.Pin(27))
btnPin = Pin(16, Pin.IN)


# -------------------------- GETTERS ------------------------- #

def doesDetectMotion():
    return motionPin.value() == 1


def getTemperature():
    try:
        tempSensor.measure()
        return tempSensor.temperature()
    except Exception as error:
        print("E-1", error)
        return None
    

def isBtnPressed():
    return btnPin.value() == False