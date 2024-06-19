
class Automation:
    id: int
    name: str
    sensor: str
    operatorID: int
    threshold: float
    tradfriDeviceID: int
    actionID: int
    actionPayload: any
    sensorDeviceID: int = -1
    

    def from_dict(data: dict):
        return Automation(
            id=data['id'],
            name=data['name'],
            sensor=data['sensor'],
            operatorID=data['operatorID'],
            threshold=data['threshold'],
            tradfriDeviceID=data['tradfriDeviceID'],
            actionID=data['actionID'],
            actionPayload=data['actionPayload'],
            sensorDeviceID=data['sensorDeviceID']
        )


    def __init__(self, id: int, name: str, sensor: str, operatorID: int, threshold: int, tradfriDeviceID: int, actionID: int, actionPayload: any, sensorDeviceID: int = -1):
        if not isinstance(id, int):
            raise ValueError("ID must be an integer")
        else:
            self.id = id

        if not isinstance(name, str):
            raise ValueError(f"Name must be a string, got {name} of type {type(name)}")
        else:
            self.name = name
        
        if not isinstance(sensor, str):
            raise ValueError(f"Sensor must be a string, got {sensor} of type {type(sensor)}")
        else:
            self.sensor = sensor
        
        if not isinstance(operatorID, int):
            raise ValueError(f"OperatorID must be an integer, got {operatorID} of type {type(operatorID)}")
        else:
            self.operatorID = operatorID
        
        if not isinstance(threshold, (int, float)):
            raise ValueError(f"Threshold must be a float or integer, got {threshold} of type {type(threshold)}")
        else:
            self.threshold = float(threshold)
        
        if not isinstance(tradfriDeviceID, int):
            raise ValueError(f"TradfriDeviceID must be an integer, got {tradfriDeviceID} of type {type(tradfriDeviceID)}")
        else:
            self.tradfriDeviceID = tradfriDeviceID
        
        if not isinstance(actionID, int):
            raise ValueError(f"ActionID must be an integer, got {actionID} of type {type(actionID)}")
        else:
            self.actionID = actionID
        
        self.actionPayload = actionPayload
        
        if not isinstance(sensorDeviceID, int):
            raise ValueError(f"SensorDeviceID must be an integer, got {sensorDeviceID} of type {type(sensorDeviceID)}")
        else:
            self.sensorDeviceID = sensorDeviceID
        

    

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "sensor": self.sensor,
            "operatorID": self.operatorID,
            "threshold": self.threshold,
            "tradfriDeviceID": self.tradfriDeviceID,
            "actionID": self.actionID,
            "actionPayload": self.actionPayload,
            "sensorDeviceID": self.sensorDeviceID
        }
