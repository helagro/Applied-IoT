import motion
import time
from machine import Pin
from temperature import getTemperature

LED = Pin("LED", Pin.OUT)
LED.off()

while True:
    print("Temperature is: ", getTemperature(), "Motion?: ", motion.doesDetect())
    time.sleep(20)

   