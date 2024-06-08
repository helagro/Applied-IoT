from dataclasses import dataclass

@dataclass
class Automation:
    name: str
    sensor: str
    operatorID: int
    threshold: int
    tradfriDeviceID: int
    actionID: int
    actionPayload: any
    sensorDeviceID: int = -1
    
    def dict(self):
        return {
            "name": self.name,
            "sensor": self.sensor,
            "operatorID": self.operatorID,
            "threshold": self.threshold,
            "tradfriDeviceID": self.tradfriDeviceID,
            "actionID": self.actionID,
            "actionPayload": self.actionPayload,
            "sensorDeviceID": self.sensorDeviceID
        }
