from flask import Flask, jsonify, request
from Automation import Automation
from tradfri import get_devices, Action
from automations import automations, save, use_next_id, get_by_id
from sensor import Sensor
from compare import Comparator
from db import get_all_data


app = Flask(__name__, static_folder='../public', static_url_path='/static')

# -------------------------- GET-ENDPOINTS ------------------------- #

@app.route('/api/ikea-devices', methods=['GET'])
def get_ikea_devices():
    return jsonify(get_devices())


@app.route('/api/automations', methods=['GET'])
def get_automations():
    return jsonify([automation.to_dict() for automation in automations])


@app.route('/api/sensors', methods=['GET'])
def get_sensors():
    return jsonify({sensor.name: sensor.value for sensor in Sensor})


@app.route('/api/comparators', methods=['GET'])
def get_comparators():
    return jsonify({comparator.name: comparator.value for comparator in Comparator})


@app.route('/api/actions', methods=['GET'])
def get_actions():
    return jsonify({action.name: action.value for action in Action})


@app.route('/api/data/<device>', methods=['GET'])
def get_data_by_device(device):
    print("eric", get_by_id(int(device)))
    return jsonify(get_by_id(int(device)))


@app.route('/api/data', methods=['GET'])
def get_data():
    return jsonify(get_all_data())
    
# ---------------------- UNSAFE-ENDPOINTS ---------------------- #

@app.route('/api/automations/<id>', methods=['PUT'])
def update_automation(id):
    if request.is_json:
        data = request.get_json()
    else:
        return jsonify({"error": "Request body must be JSON"}), 400
    
    for i, automation in enumerate(automations):
        if automation.id == int(id):
            try:
                automation = automation_from_data(data)
            except ValueError as e:
                return jsonify({"error": str(e)}), 400
            
            automations[i] = automation
            save()
            return jsonify({"message": f"Updated automation with ID {id}"})
    
    return jsonify({"error": f"Automation with ID {id} not found"}), 404


@app.route('/api/automations', methods=['PUT'])
def create_automation():
    if request.is_json:
        data = request.get_json()
    else:
        return jsonify({"error": "Request body must be JSON"}), 400

    try:
        automation = automation_from_data(data)
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

    automations.append(automation)
    save()
    return jsonify({"message": "PUT request received"})


@app.route('/api/automations/<id>', methods=['DELETE'])
def delete_automation(id):
    automation = get_by_id(int(id))

    if automation is None:
        return jsonify({"error": f"Automation with ID {id} not found"}), 404
    else:
        automations.remove(automation)
        save()
        return jsonify({"message": f"Deleted automation with ID {id}"})

# -------------------------- METHODS ------------------------- #

def automation_from_data(data) -> Automation:
    if id not in data:
        data['id'] = use_next_id()

    return Automation.from_dict(data)


# --------------------------- START -------------------------- #

def start():
    print("Starting server", flush=True)
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=5000)