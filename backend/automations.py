from Automation import Automation
from values import Sensor
from compare import Comparator, shouldExecute
from tradfri import execute as executeTradfri, Action
from flask import jsonify, json

automations = [
    Automation(1, "Off when cold", Sensor.TEMPERATURE.value, Comparator.LESS_OR_EQUAL.value, 25, 65541, Action.SET_STATE.value, False, 0),
    Automation(2, "On when warm", Sensor.TEMPERATURE.value, Comparator.GREATER_OR_EQUAL.value, 26, 65541, Action.SET_STATE.value, True),
    Automation(0, "Toggle outlet", Sensor.BUTTON.value, Comparator.EQUAL.value, True, 65539, Action.TOGGLE.value, None, 0),
    Automation(3, "off when bright", Sensor.LIGHT.value, Comparator.GREATER_OR_EQUAL.value, 0.5, 65537, Action.SET_STATE.value, False, 0),
    Automation(4,"on when dark", Sensor.LIGHT.value, Comparator.LESS.value, 0.5, 65537, Action.SET_STATE.value, True, 0),
]

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
        f.write(jsonify([automation.dict() for automation in automations]))


def execute(sensor: int, value: any, sensorDeviceID: int):
    for automation in automations:
        if sensor == automation.sensor and \
            (sensorDeviceID == automation.sensorDeviceID or automation.sensorDeviceID == -1) and \
            shouldExecute(value, automation.operatorID, automation.threshold):

            print("Executing automation:", automation)
            executeTradfri(automation.tradfriDeviceID, automation.actionID, automation.actionPayload)
            

load()