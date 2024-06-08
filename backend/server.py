from flask import Flask, request, jsonify
from tradfri import getDevices

app = Flask(__name__)

@app.route('/api/ikea-devices', methods=['GET'])
def getIkeaDevices():
    return jsonify(getDevices())


def start():
    print("Starting server")
    app.run()