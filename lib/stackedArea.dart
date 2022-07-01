import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';

class StackedArea extends StatelessWidget {
  var x;
  var start;
  var end;
  int xAxis;
  final endInt;
  final checkMinHr;
  DateTimeRange dateTimeRange;
  StackedArea(this.x, this.start, this.end, this.xAxis, this.endInt,
      this.checkMinHr, this.dateTimeRange);
  int dayCount = 0;
  var dateCount = -1;

  @override
  Widget build(BuildContext context) {
    dateCount++;
    var customTickFormatter = (dayCount < dateTimeRange.duration.inDays)
        ? charts.BasicNumericTickFormatterSpec((num? value) {
            // print(value);
            return DateFormat('MMMd')
                .format(dateTimeRange.start.add(Duration(days: dayCount++)));
          })
        : null;

    return charts.LineChart(
        defaultRenderer:
            charts.LineRendererConfig(includeArea: true, stacked: true),
        behaviors: [
          // charts.SlidingViewport(),
          // // A pan and zoom behavior helps demonstrate the sliding viewport
          // // behavior by allowing the data visible in the viewport to be adjusted
          // // dynamically.
          // charts.PanAndZoomBehavior(),
          charts.ChartTitle(
            'No. of Busy Agents',
            titleStyleSpec: charts.TextStyleSpec(
                color: charts.MaterialPalette.black.lighter),
            behaviorPosition: charts.BehaviorPosition.start,
          ),
          // charts.BehaviorPosition.start is label at y axis
          charts.ChartTitle(
            checkMinHr == 0
                ? 'Minutes'
                : checkMinHr == 1
                    ? 'Hours'
                    : 'Days',
            titleStyleSpec: charts.TextStyleSpec(
              color: charts.MaterialPalette.black.lighter,
              fontFamily: 'Lato',
            ),
            behaviorPosition: charts.BehaviorPosition.bottom,
          ),
          // charts.BehaviorPosition.bottom is label at x axis
        ],
        _createSampleData(),
        animate: false,
        animationDuration: const Duration(seconds: 1),
        primaryMeasureAxis: const charts.NumericAxisSpec(
          showAxisLine: true,
          viewport: charts.NumericExtents(0, 270),
          // y axis from  0 to 270 fixed
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 20),
        ),
        domainAxis: checkMinHr == 2
            ? (dateCount < dateTimeRange.duration.inDays)
                ? charts.NumericAxisSpec(
                    // tickProviderSpec:
                    //     charts.BasicNumericTickProviderSpec(desiredTickCount: 1),
                    tickFormatterSpec: customTickFormatter,
                    // viewport: charts.NumericExtents(, 7.0),
                  )
                : null
            : null);
  }

  List<charts.Series<liveData, int>> _createSampleData() {
    initializeDateFormatting();
    int datehere;

    // String temp = start.toString() + ' --> ' + end.toString();
    List<liveData> data = [];
    List<liveData> data2 = [];
    List<liveData> data3 = [];
    var temp = '';
    if (checkMinHr == 0) {
      // minutes interval
      for (var i = 0, j = 0, count = 5; i < 12; i++) {
        // count = 5 , 10, 15 like this 5 minute interval
        data.insert(j, liveData(count, Random().nextInt(20) + 5));
        data2.insert(j, liveData(count, Random().nextInt(20) + 5));
        data3.insert(j, liveData(count, Random().nextInt(20) + 5));
        j++;
        count += 5;
      }
    } else if (checkMinHr == 1) {
      // hour interval
      // print(endInt);
      // print(DateTime.now().toString().substring(11, 13));

      for (var i = xAxis, j = 0; i <= endInt; i++) {
        // print('this : $hourValue:$minuteString');
        data.insert(j, liveData(i, Random().nextInt(40) + 10));
        data2.insert(j, liveData(i, Random().nextInt(40) + 10));
        data3.insert(j, liveData(i, Random().nextInt(40) + 10));
        j++;
      }
    } else if (checkMinHr == 2) {
      // days interval
      var duration = dateTimeRange.duration.inDays;

      for (var i = 0, j = 0; i <= duration; i++) {
        // print(i);
        datehere = DateTime.parse(DateFormat('yyyy-MM-dd')
                .format(dateTimeRange.start.add(Duration(days: i))))
            .millisecondsSinceEpoch;
        print(DateFormat('MMMd')
            .format(DateTime.fromMillisecondsSinceEpoch(datehere)));
        data.insert(
            j,
            liveData(
                /* DateFormat('MMMd')
                      .format(dateTimeRange.start.add(Duration(days: i))) */
                i,
                Random().nextInt(100) + 50));
        data2.insert(
            j,
            liveData(
                /* DateFormat('MMMd')
                      .format(dateTimeRange.start.add(Duration(days: i))) */
                i,
                Random().nextInt(100) + 50));
        data3.insert(
            j,
            liveData(
                /* DateFormat('MMMd')
                      .format(dateTimeRange.start.add(Duration(days: i))) */
                i,
                Random().nextInt(100) + 50));
        j++;
      }
      // print(dateTimeRange.start.millisecondsSinceEpoch);
    }

    // print(datehere);
    // // print('first : ${dateTimeRange.start.millisecondsSinceEpoch}');
    // // // num.parse(dateTimeRange.start.millisecondsSinceEpoch);
    // print(
    //     'converted to datetime : ${DateTime.fromMillisecondsSinceEpoch(datehere)}');
    return [
      charts.Series<liveData, int>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data,
      ),
      charts.Series<liveData, int>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data2,
      ),
      charts.Series<liveData, int>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data3,
      )
    ];
  }
}

class liveData {
  final int day;
  final int value;

  liveData(this.day, this.value);
}
