class Automation {
  dynamic id;
  String name;
  String sensor;
  String operatorID;
  dynamic threshold;
  int tradfriDeviceID;
  String actionID;
  dynamic actionPayload;
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
}
