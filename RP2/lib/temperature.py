import dht
import machine

tempSensor = dht.DHT11(machine.Pin(27))


def getTemperature():
    try:
        tempSensor.measure()
        return tempSensor.temperature()
    except Exception as error:
        print("E-1", error)
        return None