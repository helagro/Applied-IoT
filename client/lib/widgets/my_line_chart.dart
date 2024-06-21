import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatelessWidget {
  final Map<String, dynamic>? data;
  final List<FlSpot> spots = [];

  MyLineChart({this.data, super.key}) {
    data?.forEach((key, value) {
      print("$key : $value , ${DateTime.now().millisecondsSinceEpoch / 1000}");
      spots.add(FlSpot(double.parse(key), value));
    });
  }

  LineChartData get sampleData1 => LineChartData(
      lineBarsData: [lineChartBarData1],
      titlesData: titlesData2,
      gridData: const FlGridData(show: false),
      minX: (DateTime.now().millisecondsSinceEpoch / 1000) - 3600 * 24,
      maxX: DateTime.now().millisecondsSinceEpoch / 1000);

  LineChartBarData get lineChartBarData1 => LineChartBarData(
        isCurved: false,
        color: const Color.fromARGB(255, 113, 209, 107),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: spots,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 3600,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget widget;

    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((value * 1000).round());
    widget = Text(
      "${dateTime.hour}H",
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        child: SizedBox(height: 500, child: LineChart(sampleData1)));
  }
}
