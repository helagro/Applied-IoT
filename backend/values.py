from enum import Enum

class Sensor(Enum):
    TEMPERATURE = 'temperature'
    MOTION = 'motion'

    # TODO
    BUTTON = 'button'
    LIGHT = 'light'


class Action(Enum):
    SET_STATE = 0