from Automation import Automation
from values import Sensor
from compare import Comparator, shouldExecute
from tradfri import execute as executeTradfri, Action
import json

automations = []

def load():
    try:
        with open('automations.json', 'r') as f:
            automationDicts = json.load(f)
            for automationDict in automationDicts:
                automations.append(Automation(**automationDict))
    except FileNotFoundError:
        save()


def save():
    with open('automations.json', 'w') as f:
        f.write(json.dumps([automation.dict() for automation in automations]))


def execute(sensor: int, value: any, sensorDeviceID: int):
    for automation in automations:
        if sensor == automation.sensor and \
            (sensorDeviceID == automation.sensorDeviceID or automation.sensorDeviceID == -1) and \
            shouldExecute(value, automation.operatorID, automation.threshold):

            print("Executing automation:", automation)
            executeTradfri(automation.tradfriDeviceID, automation.actionID, automation.actionPayload)
            

load()