from flask import Flask, jsonify, request, send_from_directory
from Automation import Automation
from tradfri import getDevices, Action
from automations import automations, save, useNextID
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


@app.route('/static/<path:path>')
def sendStatic(path):
    return send_from_directory('static', path)


# ---------------------- UNSAFE-ENDPOINTS ---------------------- #

@app.route('/api/automations/<id>', methods=['PUT'])
def updateAutomation(id):
    if request.is_json:
        data = request.get_json()
    else:
        return jsonify({"error": "Request body must be JSON"}), 400
    
    for i, automation in enumerate(automations):
        if automation.id == int(id):
            automations[i] = automationFromData(data)
            save()
            return jsonify({"message": f"Updated automation with ID {id}"})
    
    return jsonify({"error": f"Automation with ID {id} not found"}), 404



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
            save()
            return jsonify({"message": f"Deleted automation with id {id}"})
        
    return jsonify({"error": f"Automation with ID {id} not found"}), 404

# -------------------------- METHODS ------------------------- #

def automationFromData(data) -> Automation:
    if id not in data:
        data['id'] = useNextID()

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