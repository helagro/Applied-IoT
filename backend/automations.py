from Automation import Automation
from values import Sensor
from compare import Comparator, shouldExecute
from tradfri import execute as executeTradfri, Action

automations = [
    Automation(1, "Off when cold", Sensor.TEMPERATURE, Comparator.LESS_OR_EQUAL, 25, 65541, Action.SET_STATE, False, 0),
    Automation(2, "On when warm", Sensor.TEMPERATURE, Comparator.GREATER_OR_EQUAL, 26, 65541, Action.SET_STATE, True),
    Automation(0, "Toggle outlet", Sensor.BUTTON, Comparator.EQUAL, True, 65539, Action.TOGGLE, None, 0),
    Automation(3, "off when bright", Sensor.LIGHT, Comparator.GREATER_OR_EQUAL, 0.5, 65537, Action.SET_STATE, False, 0),
    Automation(4,"on when dark", Sensor.LIGHT, Comparator.LESS, 0.5, 65537, Action.SET_STATE, True, 0),
]

def execute(sensor: int, value: any, sensorDeviceID: int):
    for automation in automations:
        if sensor == automation.sensor and \
            (sensorDeviceID == automation.sensorDeviceID or automation.sensorDeviceID == -1) and \
            shouldExecute(value, automation.operatorID, automation.threshold):

            print("Executing automation:", automation)
            executeTradfri(automation.tradfriDeviceID, automation.actionID, automation.actionPayload)
            