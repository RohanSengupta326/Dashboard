import 'dart:math';
import 'package:dashboard/RefreshGraph.dart';
import 'package:dashboard/qBarChart.dart';
import 'package:dashboard/timeLineChart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './pieChart.dart';
import 'dart:developer';
import 'dart:ui';
import 'dart:async';
import './customScroll.dart';
import 'lineChart.dart';
import 'stackedBarChart.dart';
import 'stackedFillColor.dart';
import 'stackedArea.dart';
import 'stackedAreaCustomColor.dart';
import 'scatterPlotSimple.dart';
import 'scatterPlotShaped.dart';
import 'numericLineBarCombo.dart';
import 'pieChartGauge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightGreen,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        primaryColor: Colors.lightGreen,
        primarySwatch: Colors.amber,
        fontFamily: 'Lato',
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.lightGreen,
            onPrimary: Colors.white,
            secondary: Colors.amber,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.amberAccent,
            onSurface: Colors.black,
            background: Colors.black,
            onBackground: Colors.white),
        textTheme: const TextTheme(
          labelMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lato',
            fontStyle: FontStyle.normal,
          ),
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
          ),
          headline6: TextStyle(
            fontSize: 25.0,
            fontStyle: FontStyle.normal,
            fontFamily: 'Lato',
          ),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
      ).copyWith(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MaterialColor> _graphColors = [
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.orange,
    Colors.brown,
  ];

  var x = 0.obs,
      y = 0.obs,
      xAxis = 0.0,
      endInt = 0.0,
      check = -1,
      l = -1,
      m = -1,
      n = -1,
      def = -1;
  double? phoneWidth = GetPlatform.isAndroid ? Get.width : 700;

  var _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  var _timeRange = TimeRange(
    startTime: TimeOfDay(hour: 0, minute: 0),
    endTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
    // endtime : current hour minus the minutes , cause we r showing data in minimum of 1 hour interval, so like
    // if its 11:35 show last time on timeRangePicker 11
  ).obs;

  @override
  void initState() {
    // for 15 second refresh graph
    var refresh = Duration(seconds: 15);
    Timer.periodic(refresh, (Timer t) => onRefresh());
    super.initState();
  }

  Widget gotDateRange(BuildContext context) {
    // body after getting the dateRange selected by user
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text('Date Range : ', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(25)),
                  height: 50,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      child: Text(
                    DateFormat('dd/MMM/yyyy')
                        .format(_dateTimeRange.value.start),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ))),
              const Text('    -->    '),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                        width: 1, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(25)),
                // color: Theme.of(context).colorScheme.secondary,
                height: 50,
                width: 130,
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                    child: Text(
                  DateFormat('dd/MMM/yyyy').format(_dateTimeRange.value.end),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getDateRange(BuildContext context) async {
    // calling dateRangePicker
    final newDateRange = showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      // dates selectable by user is from past 1 year to today
      initialDateRange: _dateTimeRange.value,
      // default selected date range = today to today
    ).then((value) {
      if (value == null) return;

      _dateTimeRange.value = value;
      // log(DateFormat('MMMd')
      //                   .format(_dateTimeRange.value.start));
      // log(_dateTimeRange.value.duration.inDays.toString());
      if (_dateTimeRange.value.start == _dateTimeRange.value.end) {
        // if same date start and end means time range selection needed for that particular date
        // log('equal');
        getTimeRange(context);
        // calling time range picker
      }
      check = 2;
      // check 2 means date range is selected, no time range needed, so send this data to show graphs accordingly
      x.value = 50;
      // updates Obx to rebuild graph with new data after dateTime selected
    });
  }

  Widget gotTimeRange(BuildContext context) {
    // body after timeRange selected
    if (def == -1) {
      busyAgents();
      // calling this function here to show agents in graph who are busy when default Time range is selected, def changes when user selects
      // different time range
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text('Time Range : ', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(25)),
                  // color: Theme.of(context).colorScheme.secondary,
                  height: 50,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      child: Text(
                    _timeRange.value.startTime.toString().substring(10, 15),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ))),
              Text('    -->    '),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                        width: 1, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(25)),
                // color: Theme.of(context).colorScheme.secondary,
                height: 50,
                width: 130,
                padding: EdgeInsets.all(10),
                child: FittedBox(
                    child: Text(
                  _timeRange.value.endTime.toString().substring(10, 15),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getTimeRange(BuildContext context) async {
    // print(_dateTimeRange.value.start.toString().substring(0, 10));
    // print(DateTime.now().toString().substring(0, 10));
    var temp = false, timerange;

    if ((_dateTimeRange.value.start.toString().substring(0, 10) ==
            _dateTimeRange.value.end.toString().substring(0, 10)) &&
        (_dateTimeRange.value.start.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))) {
      timerange = TimeRange(
          // anytime in the future= after current time , time cant be selected, only from 12 am to current time of day
          startTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0));
      // temp = true;
      // print(temp);
    } else if ((_dateTimeRange.value.start.toString().substring(0, 10) ==
            _dateTimeRange.value.end.toString().substring(0, 10)) &&
        (_dateTimeRange.value.start.toString().substring(0, 10) !=
            DateTime.now().toString().substring(0, 10))) {
      timerange = null;
    }
    // print(temp);
    final newTimeRange = GetPlatform.isAndroid
        ? await showTimeRangePicker(
            context: context,
            start: TimeOfDay(hour: 0, minute: 0),
            end: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
            // maxDuration: Duration(days: 1),
            disabledTime: timerange,
            interval: Duration(minutes: 1),
            rotateLabels: true,
            use24HourFormat: true,
            minDuration: Duration(hours: 1),
            strokeWidth: 5,
            handlerRadius: 5,
            labelStyle: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.onSecondary),
            // autoAdjustLabels: true,
            // labelOffset: 30,
            autoAdjustLabels: true,
            ticks: 8,
            ticksColor: Colors.black,
            ticksLength: 10,
            ticksWidth: 3,
            labels: [
              "00 h",
              "3 h",
              "6 h",
              "9 h",
              "12 h",
              "15 h",
              "18 h",
              "21 h"
            ].asMap().entries.map((e) {
              return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
            }).toList(),
            clockRotation: 180,
          )
        : await showTimeRangePicker(
            builder: (context, child) {
              // builder function to customize timeRangePicker widget size on screen ,
              return Column(
                // without this coloum size wouldnt change
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Container(
                      height: 450,
                      width: 700,
                      child: child,
                    ),
                  ),
                ],
              );
            },
            context: context,
            start: TimeOfDay(hour: 0, minute: 0),
            // from 12 am
            end: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
            // current hour minus minutes, 11:35 -> 11
            maxDuration: Duration(days: 1),
            disabledTime: timerange,
            interval: Duration(minutes: 1),
            use24HourFormat: true,
            minDuration: Duration(hours: 1),
            strokeWidth: 5,
            handlerRadius: 5,
            labelStyle: TextStyle(fontSize: 17),
            autoAdjustLabels: true,
            rotateLabels: false,
            labels: [
              "00 h",
              "3 h",
              "6 h",
              "9 h",
              "12 h",
              "15 h",
              "18 h",
              "21 h"
            ].asMap().entries.map((e) {
              return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
            }).toList(),
            clockRotation: 180,
          );

    if (newTimeRange == null) {
      return;
    }
    _timeRange.value = newTimeRange;
    busyAgents();
    // time range set now change data according to DateTime Range by calling this function
  }

  Future<void> onRefresh() async {
    y.value = Random().nextInt(100) + 1;
    // just chaning random obs value so that graph rebuilds
  }

  void busyAgents() {
    var start = _timeRange.value.startTime;
    var end = _timeRange.value.endTime;

    // print(double.parse(
    //     '${start.toString().substring(10, 12)}.${start.toString().substring(13, 15)}'));

    var startInt = double.parse(
        '${start.toString().substring(10, 12)}.${start.toString().substring(13, 15)}');
    // start = TimeOfDay(18:00) like this so cutting the string to 18 only then converting to double
    endInt = double.parse(
        '${end.toString().substring(10, 12)}.${end.toString().substring(13, 15)}');

    // log(start.toString().substring(10, 12));
    // log(end.toString().substring(10, 12));
    var diff = endInt - startInt;
    //if diff == 1 then 1 hour range is selected no date range
    // if(diff == 1.0){
    //   print('true');
    // }
    // log(diff.toString());
    // var intTime =
    //     double.parse(start.substring(0, 2)) - double.parse(end.substring(0, 2));
    // log(intTime.toString());
    // print(start.toString());
    // x.value = 200;
    // log(start.toString());
    // log('\n');
    // log(end.toString());

    if (diff == 1.0) {
      check = 0;
      // check = 0 means single date is selected
      xAxis = startInt;
      // startInt + 5, until it reaches endInt as xAxis of graph
      x.value = 5;
    }
    // if (startInt == 00 && endInt == 3) {
    //   x.value = 100;
    // } else if (startInt == 00 && endInt == 12) {
    //   x.value = 150;
    // } else if (startInt == 00 && endInt == 15) {
    //   x.value = 170;
    // } else if (startInt == 00 && endInt == 18) {
    //   x.value = 200;
    // } else if (startInt == 00 && endInt == 23) {
    //   x.value = 250;
    // }

    // startInt + 1 , till endInt hour as xAxis
    else if (diff != 1.0) {
      check = 1;
      xAxis = startInt;
      x.value = 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: TextButton.icon(
              icon: Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: Text(
                'DateTime',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () {
                def = 0;
                // user pressed button so remove default date by changing def = 0
                getDateRange(context);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: (() {
          return onRefresh();
        }),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                // print(_dateTimeRange.value.start);
                return Column(children: [
                  gotDateRange(context),
                  const SizedBox(
                    height: 10,
                  ),
                  def == -1
                      // show default or not
                      ? gotTimeRange(context)
                      : _dateTimeRange.value.start == _dateTimeRange.value.end
                          ? gotTimeRange(context)
                          : Text(''),
                ]);
              }),
              const SizedBox(
                height: 40.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                        height: 600,
                        width: phoneWidth! + 10,
                        padding: EdgeInsets.all(20),
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(children: <Widget>[
                                  Text(
                                    'PieChart',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  Expanded(child: PieChart(_graphColors)),
                                ])))),
                    // next widgets
                    Container(
                        height: 600,
                        width: phoneWidth,
                        padding: const EdgeInsets.all(20),
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(children: <Widget>[
                                  Text(
                                    '15 seconds Interval',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Expanded(child: Obx(() {
                                    return SimpleBarChart(y.value);
                                  })),
                                ])))),
                    //
                    Container(
                        height: 600,
                        width: 700,
                        padding: EdgeInsets.all(20),
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: <Widget>[
                                  Text(
                                    'Agents Timeline',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      return TimeLineChart(
                                        x.value,
                                        _timeRange.value.startTime
                                            .format(context),
                                        _timeRange.value.endTime
                                            .format(context),
                                        xAxis,
                                        endInt,
                                        check,
                                        _dateTimeRange.value,
                                      );
                                    }),
                                  ),
                                ])))),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Queues',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return QbarChart(
                                      x.value,
                                      _timeRange.value.startTime
                                          .format(context),
                                      _timeRange.value.endTime.format(context),
                                      xAxis,
                                      endInt,
                                      check,
                                      _dateTimeRange.value);
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 600,
                width: 700,
                padding: EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Agents Timeline',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(
                          child: Obx(() {
                            return TimeSeriesLine(
                              x.value,
                              _timeRange.value.startTime.format(context),
                              _timeRange.value.endTime.format(context),
                              xAxis.toInt(),
                              endInt,
                              check,
                              _dateTimeRange.value,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'StackedBar Chart',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return StackedBar(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis,
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Stacked Fill Colors',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return StackedFillColor(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis,
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Time Series Simple',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              // Expanded(
                              //   child: Obx(() {
                              //     return StackedFillColor(
                              //       x.value,
                              //       _timeRange.value.startTime.format(context),
                              //       _timeRange.value.endTime.format(context),
                              //       xAxis,
                              //       endInt,
                              //       check,
                              //       _dateTimeRange.value,
                              //     );
                              //   }),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Stacked Area',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return StackedArea(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis.toInt(),
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Stacked Area Custom Color',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return StackedAreaCustomColor(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis.toInt(),
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Scattered Plot Simple',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return ScatteredPlotSimple(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis.toInt(),
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Scattered Plot Shaped',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return ScatteredPlotShaped(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis.toInt(),
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Combo Numeric Line ',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return NumreicLineBarCombo(
                                    x.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    xAxis.toInt(),
                                    endInt,
                                    check,
                                    _dateTimeRange.value,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 700,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Pie Chart Gauge',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(
                                child: PieChartGauge(
                                  _graphColors,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
