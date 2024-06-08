import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'Automation.dart';

class AutomationsBackend {
  String _url = 'NOT_INITIALIZED!';

  List<Automation> _automations = [];
  Map<String, dynamic> _sensorMap = {};
  Map<String, dynamic> _comparators = {};
  Map<String, dynamic> _actions = {};

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    _url = prefs.getString('server_url') ?? 'http://192.168.3.46:5000';
  }

  //--------------------------------<  LOAD DATA  >-----------------------------

  Future<void> getData() async {
    try {
      _sensorMap =
          json.decode(await http.read(Uri.parse(_url + '/api/sensors')));

      _comparators =
          json.decode(await http.read(Uri.parse(_url + '/api/comparators')));

      _actions = json.decode(await http.read(Uri.parse(_url + '/api/actions')));

      final String automationsStr =
          await http.read(Uri.parse(_url + '/api/automations'));
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
    } on SocketException {
      print('No connection to server!');
    }
  }

  //---------------------------------<  GETTERS  >------------------------------

  List<Automation> get automations => _automations;
  Map<String, dynamic> get sensorMap => _sensorMap;
  Map<String, dynamic> get comparators => _comparators;
  Map<String, dynamic> get actions => _actions;
}
