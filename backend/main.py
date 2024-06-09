import mqtt
from server import start
import threading

threading.Thread(target=start).start()
threading.Thread(target=lambda: mqtt.connect()).start()