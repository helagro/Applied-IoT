from flask import Flask, jsonify, request
from Automation import Automation
from tradfri import getDevices, Action
from automations import automations, save
from values import Sensor
from compare import Comparator

app = Flask(__name__)

# -------------------------- GET-ENDPOINTS ------------------------- #

@app.route('/api/ikea-devices', methods=['GET'])
def getIkeaDevices():
    return jsonify(getDevices())


@app.route('/api/automations', methods=['GET'])
def getAutomations():
    automationDicts = []

    for automation in automations:
        automationDicts.append(automation.dict())

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

# ---------------------- UNSAFE-ENDPOINTS ---------------------- #

@app.route('/api/automations/<id>', methods=['PUT'])
def updateAutomation(id):
    if request.is_json:
        data = request.get_json()
    else:
        return jsonify({"error": "Request body must be JSON"}), 400
    
    for i, automation in enumerate(automations):
        if automation.id == int(id):
            print("Updated automation:", automations[i], flush=True)
            automations[i] = automationFromData(data)
            break

    save()
    return jsonify({"message": "PUT request received"})


@app.route('/api/automations', methods=['PUT'])
def createAutomation():
    if request.is_json:
        data = request.get_json()
    else:
        return jsonify({"error": "Request body must be JSON"}), 400

    automations.append(automationFromData(data))

    save()
    return jsonify({"message": "PUT request received"})


@app.route('/api/automations/<id>', methods=['DELETE'])
def deleteAutomation(id):
    print(id, flush=True)

    for automation in automations:
        if automation.id == int(id):
            automations.remove(automation)
            print("Deleted automation:", automation, flush=True)

    save()
    return jsonify({"message": "DELETE request received"})

# -------------------------- METHODS ------------------------- #

def automationFromData(data) -> Automation:
    if id not in data:
        data['id'] = 10 # TODO: change

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


# --------------------------- START -------------------------- #

def start():
    print("Starting server", flush=True)
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=5000)