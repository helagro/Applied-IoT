import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradfri_extension/logic/Tradfri_device.dart';
import 'dart:convert';

import 'Automation.dart';

class AutomationsBackend {
  String _url = 'NOT_INITIALIZED!';

  List<Automation> _automations = [];
  Map<String, dynamic> _sensorMap = {};
  Map<String, dynamic> _comparators = {};
  Map<String, dynamic> _actions = {};
  List<TradfriDevice> _devices = [];

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    _url = prefs.getString('server_url') ?? 'http://192.168.3.46:5000';
  }

  //--------------------------------<  LOAD DATA  >-----------------------------

  Future<void> getData() async {
    try {
      _sensorMap = json.decode(await http.read(Uri.parse('$_url/api/sensors')));

      _comparators =
          json.decode(await http.read(Uri.parse('$_url/api/comparators')));

      _actions = json.decode(await http.read(Uri.parse('$_url/api/actions')));

      _devices = json
          .decode(await http.read(Uri.parse('$_url/api/ikea-devices')))
          .cast<Map<String, dynamic>>()
          .map<TradfriDevice>((json) => TradfriDevice.fromJson(json))
          .toList();

      final String automationsStr =
          await http.read(Uri.parse('$_url/api/automations'));
      final automationsMap =
          json.decode(automationsStr).cast<Map<String, dynamic>>();
      _automations = automationsMap
          .map<Automation>((json) => Automation.fromJson(json))
          .toList();

      print("Automations: " +
          _sensorMap["LIGHT"]! +
          " " +
          _comparators["EQUAL"]!.toString() +
          " " +
          _actions["TOGGLE"]!.toString());
    } on SocketException catch (e) {
      print('E-9: $e');
    }
  }

  //---------------------------------<  GETTERS  >------------------------------

  List<Automation> get automations => _automations;
  Map<String, dynamic> get sensorMap => _sensorMap;
  Map<String, dynamic> get comparators => _comparators;
  Map<String, dynamic> get actions => _actions;
  List<TradfriDevice> get devices => _devices;

  Map<String, dynamic> getDeviceMap() {
    Map<String, dynamic> map = {};

    for (TradfriDevice device in _devices) {
      map[device.name] = device.id;
    }

    return map;
  }

  TradfriDevice getDeviceById(int id) {
    return _devices.firstWhere((element) => element.id == id);
  }

  /* ------------------------- SETTERS ------------------------ */

  Future<void> updateAutomation(
      int id,
      String name,
      String sensor,
      String threshold,
      int operatorID,
      int tradfriDevice,
      int actionID,
      dynamic actionPayload) async {
    final response = await http.put(
      Uri.parse('$_url/api/automations/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'sensor': sensor,
        'threshold': threshold,
        'operatorID': operatorID,
        'tradfriDevice': tradfriDevice,
        'actionID': actionID,
        'actionPayload': actionPayload
      }),
    );

    print(
        "id: $id, name: $name, sensor: $sensor, threshold: $threshold, operatorID: $operatorID, tradfriDevice: $tradfriDevice, actionID: $actionID, actionPayload: $actionPayload");
  }
}
