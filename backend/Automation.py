from dataclasses import dataclass
from values import Sensor

@dataclass
class Automation:
    name: str
    sensor: str
    operatorID: int
    value: int
    deviceID: int
    actionID: int
    actionPayload: any
    
