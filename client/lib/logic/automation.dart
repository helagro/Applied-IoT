import 'dart:convert';

class Automation {
  dynamic id;
  String name;
  String sensor;
  int operatorID;
  double threshold;
  int tradfriDeviceID;
  int actionID;
  int actionPayload;
  int sensorDeviceID;

  Automation(
      {required this.id,
      required this.name,
      required this.sensor,
      required this.operatorID,
      required this.threshold,
      required this.tradfriDeviceID,
      required this.actionID,
      required this.actionPayload,
      this.sensorDeviceID = -1});

  factory Automation.fromJson(Map<String, dynamic> json) {
    return Automation(
        id: json['id'],
        name: json['name'],
        sensor: json['sensor'],
        operatorID: json['operatorID'],
        threshold: json['threshold'],
        tradfriDeviceID: json['tradfriDeviceID'],
        actionID: json['actionID'],
        actionPayload: json['actionPayload'],
        sensorDeviceID: json['sensorDeviceID']);
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'id': id,
      'name': name,
      'sensor': sensor,
      'operatorID': operatorID,
      'threshold': threshold,
      'tradfriDeviceID': tradfriDeviceID,
      'actionID': actionID,
      'actionPayload': actionPayload,
      'sensorDeviceID': sensorDeviceID
    });
  }
}
