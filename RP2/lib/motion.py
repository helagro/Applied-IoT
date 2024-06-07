from machine import Pin

PIR_sensor = Pin(22, Pin.IN, Pin.PULL_UP)


def doesDetect():
    return PIR_sensor.value() == 1
