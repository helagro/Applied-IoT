from Automation import Automation
from compare import shouldExecute
from tradfri import execute as executeTradfri 
import json
from os import path, getcwd

automations = []
biggest_id = 0
file = path.join(getcwd(), '..', 'automations.json')

# -------------------- PERSISTANCE ------------------- #

def load():
    global biggest_id

    try:
        with open(file, 'r') as f:
            automationDicts = json.load(f)
            for automationDict in automationDicts:
                if automationDict["id"] > biggest_id:
                    biggest_id = automationDict["id"]

                automation = Automation.from_dict(automationDict)
                automations.append(automation)
    except FileNotFoundError:
        save()


def save():
    with open(file, 'w') as f:
        f.write(json.dumps([automation.to_dict() for automation in automations]))

# ----------------------- OTHER METHODS ---------------------- #

def get_by_id(id: int) -> Automation:
    for automation in automations:
        if automation.id == id:
            return automation
    return None


def execute(sensor: int, value: any, sensorDeviceID: int):
    for automation in automations:
        print(f"automation {json.dumps(automation.to_dict())} sensor {sensor} value {value} sensorDeviceID {sensorDeviceID} \n")

        right_sensor = sensor == automation.sensor
        right_device = sensorDeviceID == automation.sensorDeviceID or automation.sensorDeviceID == -1
        right_value = shouldExecute(value, automation.operatorID, automation.threshold)

        if right_sensor and right_device and right_value:
            print("Executing automation:", automation)
            executeTradfri(automation.tradfriDeviceID, automation.actionID, automation.actionPayload)


def use_next_id():
    global biggest_id
    biggest_id += 1
    return biggest_id

# ---------------------------- RUN --------------------------- #

load()
