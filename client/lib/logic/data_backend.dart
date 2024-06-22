import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradfri_extension/logic/data_series.dart';

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

  Future<List<DataSeries>> getAllData() {
    return _getData('$_url/api/data');
  }

  Future<List<DataSeries>> getDataByDevice(String deviceID) {
    return _getData('$_url/api/data/$deviceID');
  }

  Future<List<DataSeries>> _getData(String url) async {
    Map<String, dynamic> data;
    List<DataSeries> dataSeriesList = [];

    try {
      data = jsonDecode(await http.read(Uri.parse(url)));
    } on Exception catch (e) {
      errorToast("E-35: Failed to read data, $e");
      return dataSeriesList;
    }

    data.forEach((key, value) {
      dataSeriesList.add(DataSeries(name: key, items: value));
    });

    return dataSeriesList;
  }
}
