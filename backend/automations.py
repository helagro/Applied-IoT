from Automation import Automation
from values import Sensor, Action
from compare import Comparator, shouldExecute
from tradfri import executeTradfri

automations = {
    Automation("On when motion", Sensor.MOTION, Comparator.EQUAL, 1, 65541, Action.SET_STATE, True),
    Automation("Off when no motion", Sensor.MOTION, Comparator.EQUAL, 0, 65541, Action.SET_STATE, False),
}

def execute(sensor, value):
    for automation in automations:
        if sensor == automation.sensor and shouldExecute(value, automation.operatorID, automation.threshold):
            print("Executing automation:", automation)
            executeTradfri(automation.deviceID, automation.actionID, automation.actionPayload)
            