import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class LineChart extends StatelessWidget {
  var x;
  var start;
  var end;
  int xAxis;
  final endInt;
  final checkMinHr;
  DateTimeRange dateTimeRange;
  LineChart(this.x, this.start, this.end, this.xAxis, this.endInt,
      this.checkMinHr, this.dateTimeRange);

  final customTickFormatter =
      charts.BasicNumericTickFormatterSpec((num? value) {
    print(value);
    print(int.parse(value.toString()));
    print(DateTime.fromMillisecondsSinceEpoch(int.parse(value.toString())));
    return DateFormat('MMMd').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(value.toString())));
  });

  @override
  Widget build(BuildContext context) {
    print('this : ${dateTimeRange.start.millisecondsSinceEpoch}');
    var showFromDate = dateTimeRange.start.toString();
    return charts.LineChart(
      behaviors: [
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
      domainAxis: checkMinHr == 2
          ? charts.NumericAxisSpec(
              // tickProviderSpec:
              //     charts.BasicNumericTickProviderSpec(desiredTickCount: 7),
              tickFormatterSpec: customTickFormatter,
            )
          : null,
    );
  }

  List<charts.Series<liveData, int>> _createSampleData() {
    // String temp = start.toString() + ' --> ' + end.toString();
    List<liveData> data = [];
    var temp = '';
    if (checkMinHr == 0) {
      // minutes interval
      for (var i = 0, j = 0, count = 5; i < 12; i++) {
        // count = 5 , 10, 15 like this 5 minute interval
        data.insert(j, liveData(count, Random().nextInt(20) + 5));
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
        j++;
      }
    } else if (checkMinHr == 2) {
      var duration = dateTimeRange.duration.inDays;

      for (var i = 0, j = 0; i <= duration; i++) {
        data.insert(
            j,
            liveData(
                /* DateFormat('MMMd')
                      .format(dateTimeRange.start.add(Duration(days: i))) */
                dateTimeRange.start.millisecondsSinceEpoch,
                Random().nextInt(100) + 50));
        j++;
      }
      // print(dateTimeRange.start.millisecondsSinceEpoch);
    }

    // date interval

    return [
      charts.Series<liveData, int>(
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
  final int day;
  final int value;

  liveData(this.day, this.value);
}
