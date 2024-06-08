from flask import Flask, jsonify
from tradfri import getDevices, Action
from automations import automations
from values import Sensor
from compare import Comparator
from dataclasses import asdict

app = Flask(__name__)

# -------------------------- GET-ENDPOINTS ------------------------- #

@app.route('/api/ikea-devices', methods=['GET'])
def getIkeaDevices():
    return jsonify(getDevices())


@app.route('/api/automations', methods=['GET'])
def getAutomations():
    automationDicts = []

    for automation in automations:
        automationDict = asdict(automation)
        automationDict["sensor"] = Sensor(automation["sensor"]).name
        automationDict["operatorID"] = Comparator(automation["operatorID"]).name
        automationDict["actionID"] = Action(automation["actionID"]).name

        automationDicts.append(automationDict)

    return jsonify(automationDicts)


@app.route('/api/sensors', methods=['GET'])
def getSensors():
    return jsonify({sensor.name: sensor.value for sensor in Sensor})


@app.route('/api/comparators', methods=['GET'])
def getComparators():
    return jsonify({comparator.name: comparator.value for comparator in Comparator})


@app.route('/api/actions', methods=['GET'])
def getActions():
    return jsonify({action.name: action.value for action in Action})


# --------------------------- START -------------------------- #

def start():
    print("Starting server", flush=True)
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=5000)