import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/data_backend.dart';
import 'package:tradfri_extension/logic/data_series.dart';
import 'package:tradfri_extension/widgets/my_line_chart.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DataBackend _backend = DataBackend();
  List<DataSeries> data = [];

  @override
  Widget build(BuildContext context) {
    setupBackend(context);
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, i) {
          print("copyright " + jsonEncode(data[i].items));
          return MyLineChart(
            data: data[i].items,
          );
        },
        itemCount: data.length,
      ),
    );
  }

  Future<void> setupBackend(BuildContext context) async {
    await _backend.setup();
    List<DataSeries> data = await _backend.getData();

    if (context.mounted) {
      setState(() {
        this.data = data;
      });
    }
  }
}
