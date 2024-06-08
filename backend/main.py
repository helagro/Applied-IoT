import mqtt
import tradfri
from server import start
import threading

print("Devices:", tradfri.getDevices())

mqtt.connect()

threading.Thread(target=start).start()
