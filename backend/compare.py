from enum import Enum


class Comparator(Enum):
    EQUAL = 0
    GREATER = 1
    LESS = 2
    GREATER_OR_EQUAL = 3
    LESS_OR_EQUAL = 4
    NOT_EQUAL = 5


def shouldExecute(value: any, comparator: int, threshold: any):
    if comparator == Comparator.EQUAL:
        return value == threshold
    elif comparator == Comparator.GREATER:
        return value > threshold
    elif comparator == Comparator.LESS:
        return value < threshold
    elif comparator == Comparator.GREATER_OR_EQUAL:
        return value >= threshold
    elif comparator == Comparator.LESS_OR_EQUAL:
        return value <= threshold
    elif comparator == Comparator.NOT_EQUAL:
        return value != threshold
    else:
        raise ValueError("E-8: Invalid comparator ID")