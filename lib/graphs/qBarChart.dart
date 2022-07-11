import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class QbarChart extends StatelessWidget {
  var x;
  var start;
  var end;
  double xAxis;
  final endInt;
  final checkMinHr;
  DateTimeRange dateTimeRange;
  QbarChart(this.x, this.start, this.end, this.xAxis, this.endInt,
      this.checkMinHr, this.dateTimeRange);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      behaviors: [
        charts.ChartTitle('Cummulative No. of Calls',
            titleStyleSpec: charts.TextStyleSpec(
                fontFamily: 'Lato',
                color: charts.MaterialPalette.black.lighter),
            behaviorPosition: charts.BehaviorPosition.start),
        charts.ChartTitle('Queues',
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
        viewport: charts.NumericExtents(0, 270),
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 20),
      ),
    );
  }

  List<charts.Series<liveData, String>> _createSampleData() {
    // String temp = start.toString() + ' --> ' + end.toString();
    List<liveData> data = [];
    var temp = '';
    if (checkMinHr == 0) {
      // minutes interval
      data = [
        liveData('Support', Random().nextInt(10) + 5),
        liveData('Sales', Random().nextInt(20) + 10),
        liveData('Accounting', Random().nextInt(15) + 7),
        liveData('Hr', Random().nextInt(10) + 5),
      ];
    } else if (checkMinHr == 1) {
      // hour interval
      // print(endInt);
      // print(DateTime.now().toString().substring(11, 13));
      data = [
        liveData('Support', Random().nextInt(50) + 20),
        liveData('Sales', Random().nextInt(60) + 20),
        liveData('Accounting', Random().nextInt(30) + 10),
        liveData('Hr', Random().nextInt(20) + 10),
      ];
      // date interval
    } else if (checkMinHr == 2) {
      data = [
        liveData('Support', Random().nextInt(200) + 60),
        liveData('Sales', Random().nextInt(150) + 60),
        liveData('Accounting', Random().nextInt(100) + 50),
        liveData('Hr', Random().nextInt(70) + 40),
      ];
    }

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
