import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String? title;
  final List<FlSpot> spots = [];

  MyLineChart({this.data, this.title, super.key}) {
    data?.forEach((key, value) {
      // print("$key : $value , ${DateTime.now().millisecondsSinceEpoch / 1000}");
      spots.add(FlSpot(double.parse(key), value));
    });
  }

  LineChartData get sampleData1 => LineChartData(
      lineBarsData: [lineChartBarData1],
      titlesData: titlesData2,
      gridData: const FlGridData(show: true, verticalInterval: 3600),
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
            axisNameWidget: const Text(
              "Hour",
              style: TextStyle(color: Color.fromARGB(255, 113, 209, 107)),
            )),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
            sideTitles: leftTitles,
            axisNameWidget: const Text("Value",
                style: TextStyle(color: Color.fromARGB(255, 113, 209, 107)))),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 3600,
        getTitlesWidget: bottomTitleWidgets,
      );

  SideTitles get leftTitles => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        reservedSize: 40,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    final String valueStr = value.toStringAsFixed(1);

    return Text(valueStr, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    Widget widget;

    if (value % 3600 == 0) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch((value * 1000).round());

      widget = Text(
        dateTime.hour.toString().padLeft(2, '0'),
        style: style,
      );
    } else {
      widget = Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
            height: 500,
            child: Column(children: [
              Text(
                title?.toUpperCase() ?? "",
                style: const TextStyle(fontSize: 20, height: 2),
              ),
              Expanded(child: LineChart(sampleData1))
            ])));
  }
}
