import mqtt
import tradfri
from server import start
import threading

print("Devices:", tradfri.getDevices())

threading.Thread(target=start).start()
threading.Thread(target=lambda: mqtt.connect()).start()