import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class StackedFillColor extends StatelessWidget {
  var x;
  var start;
  var end;
  double xAxis;
  final endInt;
  final checkMinHr;
  DateTimeRange dateTimeRange;
  StackedFillColor(this.x, this.start, this.end, this.xAxis, this.endInt,
      this.checkMinHr, this.dateTimeRange);

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 101).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    var showFromDate = dateTimeRange.start.toString();
    return charts.BarChart(
      barGroupingType: charts.BarGroupingType.stacked,
      behaviors: [
        charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        charts.PanAndZoomBehavior(),

        charts.ChartTitle(
          'No. of Busy Agents',
          titleStyleSpec:
              charts.TextStyleSpec(color: charts.MaterialPalette.black.lighter),
          behaviorPosition: charts.BehaviorPosition.start,
        ),
        // charts.BehaviorPosition.start is label at y axis
        charts.ChartTitle(
          checkMinHr == 0
              ? 'Intervals of 5 Minutes'
              : checkMinHr == 1
                  ? 'Intervals of 1 Hour'
                  : 'Intervals of 1 Day',
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
      // defaultRenderer: charts.BarRendererConfig(
      //   maxBarWidthPx: 50,
      //   // bar width
      // ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        showAxisLine: true,
        viewport: charts.NumericExtents(0, 270),
        // y axis from  0 to 270 fixed
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 20),
      ),
      domainAxis: charts.OrdinalAxisSpec(
          viewport: charts.OrdinalViewport(
              // for showing the part of the graph, and then click right to go right and left to go left
              checkMinHr == 1
                  ? '00:00'
                  : checkMinHr == 0
                      ? '5'
                      : showFromDate,
              4 /* = how many bars you wanna show on one screen */)),
    );
  }

  List<charts.Series<liveData, String>> _createSampleData() {
    // String temp = start.toString() + ' --> ' + end.toString();
    List<liveData> data = [];
    List<liveData> data2 = [];
    List<liveData> data3 = [];
    var temp = '';
    if (checkMinHr == 0) {
      // minutes interval
      for (var i = 0, j = 0, count = 5; i < 12; i++) {
        temp = '$count';
        // count = 5 , 10, 15 like this 5 minute interval
        data.insert(j, liveData(temp, Random().nextInt(20) + 5));
        data2.insert(j, liveData(temp, Random().nextInt(20) + 5));
        data3.insert(j, liveData(temp, Random().nextInt(20) + 5));
        j++;
        count += 5;
      }
    } else if (checkMinHr == 1) {
      // hour interval
      // print(endInt);
      // print(DateTime.now().toString().substring(11, 13));

      for (var i = xAxis, j = 0; i <= endInt; i++) {
        int flooredValue = i.floor();
        double decimalValue = i - flooredValue;
        String hourValue = getHourString(flooredValue);
        String minuteString = getMinuteString(decimalValue);

        // print('this : $hourValue:$minuteString');
        data.insert(
            j, liveData('$hourValue:$minuteString', Random().nextInt(40) + 10));
        data2.insert(
            j, liveData('$hourValue:$minuteString', Random().nextInt(40) + 10));
        data3.insert(
            j, liveData('$hourValue:$minuteString', Random().nextInt(40) + 10));
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
                Random().nextInt(60) + 30));
        data2.insert(
            j,
            liveData(
                DateFormat('MMMd')
                    .format(dateTimeRange.start.add(Duration(days: i))),
                Random().nextInt(60) + 30));
        data3.insert(
            j,
            liveData(
                DateFormat('MMMd')
                    .format(dateTimeRange.start.add(Duration(days: i))),
                Random().nextInt(60) + 30));
        j++;
      }
    }

    // date interval

    return [
      charts.Series<liveData, String>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data,
      ),
      charts.Series<liveData, String>(
        id: 'data2',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data2,
      ),
      charts.Series<liveData, String>(
        id: 'data3',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.darker,
        domainFn: (liveData value, _) => value.day,
        measureFn: (liveData value, _) => value.value,
        data: data3,
      )
    ];
  }
}

class liveData {
  final String day;
  final int value;

  liveData(this.day, this.value);
}
