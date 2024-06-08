# Used for getting environment variables from env.py. It handles any errors that may occur.

try:
    from env import *
except ImportError:
    print("Error: env.py not found. Please create env.py and add the necessary environment variables.")
    exit(1)

disabledSensors = DISABLED_SENSORS.split(",") if DISABLED_SENSORS else []

# -------------------------- GETTERS ------------------------- #


def getSSID():
    return WIFI_SSID


def getWIFI_PASS():
    return WIFI_PASS


def getBROKER_ADDRESS():
    return BROKER_ADDRESS


def getBROKER_PORT():
    try:
        return BROKER_PORT
    except NameError:
        return 1883 # Default port


def getDEVICE_ID():
    return DEVICE_ID


def getDisabledSensors():
    return disabledSensors