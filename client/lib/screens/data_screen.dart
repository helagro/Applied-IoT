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
  final double switchLayoutWidth = 600;

  final DataBackend _backend = DataBackend();
  List<DataSeries> data = [];

  @override
  void initState() {
    setupBackend();
  }

  @override
  Widget build(BuildContext context) {
    final Widget charts = ListView.builder(
      itemBuilder: (context, i) {
        return MyLineChart(
          title: data[i].name,
          data: data[i].items,
        );
      },
      itemCount: data.length,
    );

    return Scaffold(body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > switchLayoutWidth) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1800),
              child: charts,
            ),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: switchLayoutWidth),
              child: charts,
            ),
          );
        }
      },
    ));
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
