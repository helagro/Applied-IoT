# Used for getting environment variables from env.py. It handles any errors that may occur.

try:
    from env import *
except ImportError:
    print("Error: env.py not found. Please create env.py and add the necessary environment variables.")
    exit(1)

disabledSensors = DISABLED_SENSORS.split(",") if DISABLED_SENSORS else []

# -------------------------- GETTERS ------------------------- #


def getSSID() -> str:
    return WIFI_SSID


def getWIFI_PASS() -> str:
    return WIFI_PASS


def getBROKER_ADDRESS() -> str:
    return BROKER_ADDRESS


def getBROKER_PORT() -> int:
    try:
        return BROKER_PORT
    except NameError:
        return 1883 # Default port


def getDEVICE_ID() -> int:
    return DEVICE_ID


def getDisabledSensors() -> list[str]:
    return disabledSensors