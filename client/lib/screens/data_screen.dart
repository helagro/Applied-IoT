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
  void initState() {
    setupBackend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, i) {
          return MyLineChart(
            data: data[i].items,
          );
        },
        itemCount: data.length,
      ),
    );
  }

  Future<void> setupBackend() async {
    await _backend.setup();
    List<DataSeries> data = await _backend.getData();

    if (mounted) {
      setState(() {
        this.data = data;
      });
    }
  }
}
