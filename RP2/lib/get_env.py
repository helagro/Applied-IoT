# Used for getting environment variables from env.py. It handles any errors that may occur.

try:
    from env import *
except ImportError:
    print("Error: env.py not found. Please create env.py and add the necessary environment variables.")
    exit(1)

# -------------------------- GETTERS ------------------------- #

def getSSID():
    return WIFI_SSID

def getWIFI_PASS():
    return WIFI_PASS