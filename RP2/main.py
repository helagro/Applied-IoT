import motion
import time
from machine import Pin

LED = Pin("LED", Pin.OUT)
LED.off()

while True:
    if motion.doesDetect():
       print("Motion Detected")
       LED.on()
       time.sleep(5)
    else:
       print("No motion detected -> LED is OFF")
       LED.off()
       time.sleep(1)