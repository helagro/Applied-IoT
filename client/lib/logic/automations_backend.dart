import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'Automation.dart';

class AutomationsBackend {
  String _url = 'NOT_INITIALIZED!';

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    _url = prefs.getString('server_url') ?? 'http://192.168.3.46:5000';
  }

  Future<void> getData() async {
    try {
      final automations = await http.read(Uri.parse(_url + '/api/automations'));
      final parsed = json.decode(automations).cast<Map<String, dynamic>>();
      final automationsList =
          parsed.map<Automation>((json) => Automation.fromJson(json)).toList();

      print("Automations: " + automationsList[0].name);
    } on SocketException {
      print('No connection to server!');
    }
  }
}
