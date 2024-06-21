import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../toasts.dart';

class DataBackend {
  String _url = 'NOT_INITIALIZED!';

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    final String? url = prefs.getString('server_url');

    if (url == null || url.isEmpty) {
      errorToast(
          'E-33: Server URL not set! Please set it in the settings page');
    } else {
      _url = url;
    }
  }

  void getData() async {
    Map<String, Map<double, double>> data =
        jsonDecode(await http.read(Uri.parse('$_url/data')));

    print(jsonEncode(data));
  }
}
