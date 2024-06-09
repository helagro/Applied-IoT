import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradfri_extension/logic/Tradfri_device.dart';
import 'package:tradfri_extension/toasts.dart';
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
    final String? url = prefs.getString('server_url');

    if (url == null || url.isEmpty) {
      errorToast(
          'E-13: Server URL not set! Please set it in the settings page');
    } else {
      _url = url;
    }
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

      await loadAutomations();
    } on SocketException catch (e) {
      errorToast('E-9: $e');
    }
  }

  Future<void> loadAutomations() async {
    try {
      final String automationsStr =
          await http.read(Uri.parse('$_url/api/automations'));
      final automationsMap =
          json.decode(automationsStr).cast<Map<String, dynamic>>();
      _automations = automationsMap
          .map<Automation>((json) => Automation.fromJson(json))
          .toList();
    } on SocketException catch (e) {
      errorToast('E-10: $e');
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

  /* ------------------------- MODIFIERS ------------------------ */

  Future<void> updateAutomation(
      dynamic id,
      String name,
      String sensor,
      String threshold,
      int operatorID,
      int tradfriDevice,
      int actionID,
      dynamic actionPayload,
      int sensorDeviceID) async {
    final String uri =
        id == null ? '$_url/api/automations' : '$_url/api/automations/$id';

    try {
      await http.put(
        Uri.parse(uri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'sensor': sensor,
          'threshold': threshold,
          'operatorID': operatorID,
          'tradfriDeviceID': tradfriDevice,
          'actionID': actionID,
          'actionPayload': actionPayload,
          'sensorDeviceID': sensorDeviceID
        }),
      );
    } on SocketException catch (e) {
      errorToast('E-12: $e');
    }
  }

  Future<void> deleteAutomation(dynamic id) async {
    if (id == null) return;

    try {
      await http.delete(Uri.parse('$_url/api/automations/$id'));
    } on SocketException catch (e) {
      errorToast('E-11: $e');
    }
  }
}
