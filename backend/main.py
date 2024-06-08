import mqtt
from Tradfri import Tradfri

tradfri = Tradfri()

print("Devices:", tradfri.getDevices())

# mqtt.connect()