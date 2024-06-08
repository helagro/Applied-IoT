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
    
