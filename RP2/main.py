import motion
import time
from machine import Pin
from temperature import getTemperature
from get_env import getSSID

LED = Pin("LED", Pin.OUT)
LED.off()

while True:
    print("Temperature is: ", getTemperature(), "Motion?: ", motion.doesDetect(), "SSID: ", getSSID())
    time.sleep(20)

   