import mqtt
import tradfri

print("Devices:", tradfri.getDevices())

mqtt.connect()