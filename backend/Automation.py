from dataclasses import dataclass

@dataclass
class Automation:
    id: int
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
            "id": self.id,
            "name": self.name,
            "sensor": self.sensor.value,
            "operatorID": self.operatorID.value,
            "threshold": self.threshold,
            "tradfriDeviceID": self.tradfriDeviceID,
            "actionID": self.actionID.value,
            "actionPayload": self.actionPayload,
            "sensorDeviceID": self.sensorDeviceID
        }
