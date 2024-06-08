from flask import Flask, jsonify
from tradfri import getDevices, Action
from automations import automations
from values import Sensor
from compare import Comparator

app = Flask(__name__)

# -------------------------- GET-ENDPOINTS ------------------------- #

@app.route('/api/ikea-devices', methods=['GET'])
def getIkeaDevices():
    return jsonify(getDevices())


@app.route('/api/automations', methods=['GET'])
def getAutomations():
    return jsonify(automations)


@app.route('/api/sensors', methods=['GET'])
def getSensors():
    return jsonify(Sensor)


@app.route('/api/comparators', methods=['GET'])
def getComparators():
    return jsonify(Comparator)


@app.route('/api/actions', methods=['GET'])
def getActions():
    return jsonify(Action)


# --------------------------- START -------------------------- #

def start():
    print("Starting server", flush=True)
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=5000)