from Automation import Automation
from values import Sensor
from compare import Comparator, shouldExecute
from tradfri import execute as executeTradfri, Action

automations = [
    Automation("Off when cold", Sensor.TEMPERATURE, Comparator.LESS_OR_EQUAL, 24, 65541, Action.SET_STATE, False),
    Automation("On when warm", Sensor.TEMPERATURE, Comparator.GREATER_OR_EQUAL, 25, 65541, Action.SET_STATE, True),
]

def execute(sensor, value):
    for automation in automations:
        if sensor == automation.sensor and shouldExecute(value, automation.operatorID, automation.threshold):
            print("Executing automation:", automation)
            executeTradfri(automation.deviceID, automation.actionID, automation.actionPayload)
            