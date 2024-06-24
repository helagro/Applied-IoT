import mqtt
from server import start
import threading
from time import sleep

sleep(2) # Imroves stability when starting up

threading.Thread(target=start).start()
threading.Thread(target=lambda: mqtt.connect()).start()