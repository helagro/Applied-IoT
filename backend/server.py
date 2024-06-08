from flask import Flask, request, jsonify
from tradfri import getDevices

app = Flask(__name__)

@app.route('/api/v1/ikea-devices', methods=['GET'])
def getIkeaDevices():
    return jsonify(getDevices())


def start():
    app.run()