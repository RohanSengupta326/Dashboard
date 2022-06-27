import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleBarChart extends StatelessWidget {
  final x;
  SimpleBarChart(this.x);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      behaviors: [
        charts.ChartTitle('Active Agents',
            titleStyleSpec: charts.TextStyleSpec(
                fontFamily: 'Lato',
                color: charts.MaterialPalette.black.lighter),
            behaviorPosition: charts.BehaviorPosition.start),
        charts.ChartTitle('DateTime(day)',
            titleStyleSpec: charts.TextStyleSpec(
                fontFamily: 'Lato',
                color: charts.MaterialPalette.black.lighter),
            behaviorPosition: charts.BehaviorPosition.bottom),
      ],
      _createSampleData(),
      animate: true,
      animationDuration: const Duration(seconds: 3),
      defaultRenderer: charts.BarRendererConfig(
        maxBarWidthPx: 40,
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        showAxisLine: true,
        viewport: charts.NumericExtents(0, 200),
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 20),
      ),
    );
  }

  List<charts.Series<liveData, String>> _createSampleData() {
    final data = [
      liveData(DateFormat('EEE d MMM').format(DateTime.now()).toString(), x),
    ];

    return [
      charts.Series<liveData, String>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data,
      )
    ];
  }
}

class liveData {
  final String day;
  final int value;

  liveData(this.day, this.value);
}
