import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/data_backend.dart';

class DataScreen extends StatelessWidget {
  final DataBackend _backend = DataBackend();

  DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    setupBackend();
    return Scaffold();
  }

  Future<void> setupBackend() async {
    await _backend.setup();
    await _backend.getData();
  }
}
