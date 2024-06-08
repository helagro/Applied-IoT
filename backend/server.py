from flask import Flask, request, jsonify
from tradfri import getDevices

app = Flask(__name__)

@app.route('/api/ikea-devices', methods=['GET'])
def getIkeaDevices():
    return jsonify(getDevices())


def start():
    print("Starting server", flush=True)
    app.run(debug=True, use_reloader=False, host='0.0.0.0', port=5000)