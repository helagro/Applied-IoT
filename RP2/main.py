import motion
import time
from machine import Pin
from temperature import getTemperature
import wifi

wifi.connect()

LED = Pin("LED", Pin.OUT)
LED.off()

while True:
    print("Temperature: ", getTemperature(), "Motion?: ", motion.doesDetect())
    time.sleep(20)

   