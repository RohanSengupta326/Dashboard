import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TimeLineChart extends StatelessWidget {
  var x;
  var start;
  var end;
  double xAxis;
  final endInt;
  final checkMinHr;
  DateTimeRange dateTimeRange;
  TimeLineChart(this.x, this.start, this.end, this.xAxis, this.endInt,
      this.checkMinHr, this.dateTimeRange);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      behaviors: [
        charts.ChartTitle('No. of Busy Agents',
            titleStyleSpec: charts.TextStyleSpec(
                color: charts.MaterialPalette.green.shadeDefault),
            behaviorPosition: charts.BehaviorPosition.start),
        charts.ChartTitle(
            checkMinHr == 0
                ? 'Intervals of 5 Minutes'
                : checkMinHr == 1
                    ? 'Intervals of 1 Hour'
                    : 'Intervals of 1 Day',
            titleStyleSpec: charts.TextStyleSpec(
                color: charts.MaterialPalette.green.shadeDefault),
            behaviorPosition: charts.BehaviorPosition.bottom),
      ],
      _createSampleData(),
      animate: true,
      animationDuration: const Duration(seconds: 3),
      defaultRenderer: charts.BarRendererConfig(
        maxBarWidthPx: 5,
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
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
      for (var i = 0, j = 0, count = 5; i < 12; i++) {
        temp = '$count';
        data.insert(j, liveData(temp, Random().nextInt(20) + 5));
        j++;
        count += 5;
      }
    } else if (checkMinHr == 1) {
      // hour interval
      // print(endInt);
      // print(DateTime.now().toString().substring(11, 13));
      for (var i = xAxis, j = 0; i <= endInt; i++) {
        data.insert(j, liveData('${i.toString()}', Random().nextInt(40) + 10));
        j++;
      }
    } else if (checkMinHr == 2) {
      var duration = dateTimeRange.duration.inDays;

      for (var i = 0, j = 0; i <= duration; i++) {
        data.insert(
            j,
            liveData(
                DateFormat('MMMd')
                    .format(dateTimeRange.start.add(Duration(days: i))),
                Random().nextInt(100) + 50));
        j++;
      }
    }

    // date interval

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
