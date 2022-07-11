import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';

class TimeSeriesLine extends StatelessWidget {
  var x;
  TimeOfDay start;
  TimeOfDay end;
  int xAxis;
  final endInt;
  final checkMinHr;
  DateTimeRange dateTimeRange;
  TimeSeriesLine(this.x, this.start, this.end, this.xAxis, this.endInt,
      this.checkMinHr, this.dateTimeRange);

  @override
  Widget build(BuildContext context) {
    print('HERE : $checkMinHr');
    return charts.TimeSeriesChart(
      behaviors: [
        // charts.SlidingViewport(),
        // // A pan and zoom behavior helps demonstrate the sliding viewport
        // // behavior by allowing the data visible in the viewport to be adjusted
        // // dynamically.
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
      domainAxis: charts.DateTimeAxisSpec(
        viewport: charts.DateTimeExtents(
          start: DateTime(dateTimeRange.start.year, dateTimeRange.start.month,
              dateTimeRange.start.day, start.hour, start.minute),
          end: DateTime(dateTimeRange.start.year, dateTimeRange.start.month,
                  dateTimeRange.start.day, start.hour, start.minute)
              .add(
            checkMinHr == 0
                ? Duration(minutes: 25)
                : checkMinHr == 2
                    ? Duration(days: 5)
                    : Duration(hours: 5),
          ),
        ),
        // tickProviderSpec: charts.DateTimeTickProviderSpec(),
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: checkMinHr == 0
                ? 'HH:mm'
                : checkMinHr == 2
                    ? 'MMMd'
                    : "hh:mm",
            transitionFormat: checkMinHr == 0
                ? 'HH:mm'
                : checkMinHr == 2
                    ? 'MMMd'
                    : "HH",
          ),
        ),
      ),
    );
    // tickProviderSpec:
    //     charts.BasicNumericTickProviderSpec(desiredTickCount: 1),

    // viewport: charts.NumericExtents(, 7.0),
  }

  List<charts.Series<liveData, DateTime>> _createSampleData() {
    initializeDateFormatting();
    // some date formatting were giving errors without this

    // String temp = start.toString() + ' --> ' + end.toString();
    List<liveData> data = [];
    var temp = '';

    if (checkMinHr == 0) {
      // minutes interval
      for (var i = 0, j = 0, count = 0; i <= 12; i++) {
        data.insert(
            j,
            liveData(
                // start.add(
                //   Duration(minutes: 5),
                // ),
                DateTime(dateTimeRange.start.year, dateTimeRange.start.month,
                        dateTimeRange.start.day, start.hour, start.minute)
                    .add(
                  Duration(minutes: count),
                ),
                Random().nextInt(20) + 5));
        j++;
        count += 5;
      }
    } else if (checkMinHr == 1) {
      for (var i = xAxis, j = 0; i <= endInt; i++) {
        // print('this : $hourValue:$minuteString');
        data.insert(
            j,
            liveData(
                DateTime(dateTimeRange.start.year, dateTimeRange.start.month,
                        dateTimeRange.start.day, start.hour)
                    .add(
                  Duration(hours: j),
                ),
                Random().nextInt(40) + 10));
        j++;
      }
    } else if (checkMinHr == 2) {
      // days interval
      var duration = dateTimeRange.duration.inDays;

      for (var i = 0, j = 0; i <= duration; i++) {
        data.insert(
            j,
            liveData(dateTimeRange.start.add(Duration(days: i)),
                Random().nextInt(100) + 50));
        j++;
      }
    }

    return [
      charts.Series<liveData, DateTime>(
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
  final DateTime day;
  final int value;

  liveData(this.day, this.value);
}
