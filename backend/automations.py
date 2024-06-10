from Automation import Automation
from compare import shouldExecute
from tradfri import execute as executeTradfri 
import json

automations = []
biggestID = 0

# -------------------- PERSISTANCE ------------------- #

def load():
    global biggestID

    try:
        with open('automations.json', 'r') as f:
            automationDicts = json.load(f)
            for automationDict in automationDicts:
                if automationDict["id"] > biggestID:
                    biggestID = automationDict["id"]

                automations.append(Automation(**automationDict))
    except FileNotFoundError:
        save()


def save():
    with open('automations.json', 'w') as f:
        f.write(json.dumps([automation.dict() for automation in automations]))

# ----------------------- OTHER METHODS ---------------------- #

def execute(sensor: int, value: any, sensorDeviceID: int):
    for automation in automations:
        if sensor == automation.sensor and \
            (sensorDeviceID == automation.sensorDeviceID or automation.sensorDeviceID == -1) and \
            shouldExecute(value, automation.operatorID, automation.threshold):

            print("Executing automation:", automation)
            executeTradfri(automation.tradfriDeviceID, automation.actionID, automation.actionPayload)

def useNextID():
    global biggestID
    biggestID += 1
    return biggestID

# ---------------------------- RUN --------------------------- #

load()