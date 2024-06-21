import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatelessWidget {
  final Map<String, dynamic>? data;
  final List<FlSpot> spots = [];

  MyLineChart({this.data, super.key}) {
    data?.forEach((key, value) {
      print("it is like " + key + " " + value);
      spots.add(FlSpot(double.parse(key), value));
    });
  }

  LineChartBarData get lineChartBarData1 => LineChartBarData(
        isCurved: false,
        color: Colors.deepPurpleAccent,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      );

  LineChartData get sampleData1 => LineChartData(
        lineBarsData: [lineChartBarData1],
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 500, width: 400, child: LineChart(sampleData1));
  }
}
