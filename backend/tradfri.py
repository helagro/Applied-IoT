from pytradfri import Gateway
from pytradfri.api.libcoap_api import APIFactory
from pytradfri.error import PytradfriError
from pytradfri.util import load_json, save_json
import uuid
import os
from dotenv import load_dotenv
from enum import Enum
import threading

load_dotenv()
timers = {}


class Action(Enum):
    SET_STATE = 0
    TEMPORARY_ON = 1
    TOGGLE = 2


credentials_path = "generated_tradfri_credentials.json"
gateway_addr: str = os.environ.get("TRADFRI_GATEWAY_ADDR")

api = None
gateway = None

def init() -> None:
    if not gateway_addr:
            raise PytradfriError("E-3: TRADFRI_GATEWAY_ADDR is not set")

    print("Connecting to Tradfri Gateway...")

    success = auth_with_generated_credentials()
    if not success:
        key = askForKey()
        auth_with_key(key)

# ----------------------- AUTHENTICATE ----------------------- #

def auth_with_generated_credentials() -> bool:
    conf = load_json(credentials_path)

    try:
        api_factory = APIFactory(host=gateway_addr, psk_id=conf["identity"], psk=conf["key"])
        setup_api(api_factory)
        return True

    except KeyError: 
        return False    


def askForKey() -> str:
    print(
        "Please provide the Security Code on the back of your gateway:",
        end=" ",
    )
    key = input().strip()

    while len(key) != 16:
        print("Invalid 'Security Code' provided, try again: ", end=" ")
        key = input().strip()
    
    return key


def auth_with_key(key: str) -> None:
    identity = uuid.uuid4().hex
    apiFactory = APIFactory(host=gateway_addr, psk_id=identity)

    try:
        psk = apiFactory.generate_psk(key)
        save_json(credentials_path, {"identity": identity, "key": psk})
        setup_api(apiFactory)
    except AttributeError:
        raise PytradfriError("E-2: Invalid key")


def setup_api(apiFactory: APIFactory) -> None:
    global api, gateway

    api = apiFactory.request
    gateway = Gateway()
    print("Connected to Tradfri Gateway")

# --------------------------- METHODS -------------------------- #

def get_devices() -> list[dict]:
    devices = api(api(gateway.get_devices()))
    applicableDevices = []

    for device in devices:
        if device.has_light_control or device.has_socket_control or device.has_blind_control:
            applicableDevices.append({"id": device.id, "name": device.name})

    return applicableDevices
        

def execute(deviceID: int, action: int, payload: any) -> None:
    device = getDevice(deviceID)
    deviceControl = getDeviceControl(device)

    print("Executing action:", action, "with payload:", payload, "on device:", device)

    if action == Action.SET_STATE.value:
        if payload == True:
            api(deviceControl.set_state(True))
        elif payload == False:
            api(deviceControl.set_state(False))
        else:
            print(f"E-22: Invalid payload {payload}")

    elif action == Action.TEMPORARY_ON.value:
        if(timers.get(deviceID)):
            timers[deviceID].cancel()

        api(deviceControl.set_state(True))
        timer = threading.Timer(payload, lambda: afterTemporaryOn(deviceID, deviceControl))
        timer.start()
        timers[deviceID] = timer

    elif action == Action.TOGGLE.value:
        if device.has_light_control:
            api(deviceControl.set_state(not deviceControl.lights[0].state))
        elif device.has_socket_control:
            api(deviceControl.set_state(not deviceControl.sockets[0].state))
        elif device.has_blind_control:
            api(deviceControl.set_state(not deviceControl.blinds[0].state))
        else:
            raise PytradfriError(f"E-7: Device {device.id} has no valid control")

    else:
        raise PytradfriError(f"E-5: Invalid action {action}")


def getDevice(deviceID: int):
    return api(gateway.get_device(deviceID))


def getDeviceControl(device: any):
    if device.has_light_control:
        return device.light_control
    elif device.has_socket_control:
        return device.socket_control
    elif device.has_blind_control:
        return device.blind_control
    else:
        raise PytradfriError(f"E-6: Device {device.id} has no control")
    

def afterTemporaryOn(deviceID: int, deviceControl: any) -> None:
    api(deviceControl.set_state(False))
    timers.pop(deviceID)

    
init()