class TradfriDevice {
  final int id;
  final String name;

  TradfriDevice({required this.id, required this.name});

  factory TradfriDevice.fromJson(Map<String, dynamic> json) {
    return TradfriDevice(id: json['id'], name: json['name']);
  }
}
