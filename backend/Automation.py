from dataclasses import dataclass

@dataclass
class Automation:
    name: str
    sensor: str
    operatorID: int
    threshold: int
    deviceID: int
    actionID: int
    actionPayload: any
    
