import 'dart:math';

import 'package:dashboard/RefreshGraph.dart';
import 'package:dashboard/map.dart';
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
        ),
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
          labelMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
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
  double? phoneWidth = GetPlatform.isDesktop ? 700 : Get.width;

  var _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  var _timeRange = TimeRange(
    startTime: TimeOfDay(hour: 0, minute: 0),
    endTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
  ).obs;

  @override
  void initState() {
    // TODO: implement initState
    var refresh = Duration(seconds: 15);
    Timer.periodic(refresh, (Timer t) => onRefresh());
    super.initState();
  }

  Widget gotDateRange(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.secondary,
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      child: Text(DateFormat('dd/MMM/yyyy')
                          .format(_dateTimeRange.value.start)))),
              const Text('    -->    '),
              Container(
                color: Theme.of(context).colorScheme.secondary,
                height: 50,
                width: 100,
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                    child: Text(DateFormat('dd/MMM/yyyy')
                        .format(_dateTimeRange.value.end))),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getDateRange(BuildContext context) async {
    final newDateRange = showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      initialDateRange: _dateTimeRange.value,
    ).then((value) {
      if (value == null) return;

      _dateTimeRange.value = value;
      // log(DateFormat('MMMd')
      //                   .format(_dateTimeRange.value.start));
      // log(_dateTimeRange.value.duration.inDays.toString());
      if (_dateTimeRange.value.start == _dateTimeRange.value.end) {
        // log('equal');
        getTimeRange(context);
      }
      check = 2;
      x.value = 50;
    });
  }

  Widget gotTimeRange(BuildContext context) {
    if (def == -1) {
      busyAgents();
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
                  color: Theme.of(context).colorScheme.secondary,
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      child: Text(_timeRange.value.startTime
                          .toString()
                          .substring(10, 15)))),
              Text('    -->    '),
              Container(
                color: Theme.of(context).colorScheme.secondary,
                height: 50,
                width: 100,
                padding: EdgeInsets.all(10),
                child: FittedBox(
                    child: Text(
                        _timeRange.value.endTime.toString().substring(10, 15))),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getTimeRange(BuildContext context) async {
    final newTimeRange = await showTimeRangePicker(
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
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
      end: TimeOfDay.now(),
      maxDuration: Duration(days: 1),
      disabledTime: TimeRange(
          startTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0)),
      interval: Duration(hours: 1),
      use24HourFormat: true,
      minDuration: Duration(hours: 1),
      strokeWidth: 5,
      handlerRadius: 10,
      labelStyle: TextStyle(fontSize: 25),
      autoAdjustLabels: true,
      labels: ["24 h", "3 h", "6 h", "9 h", "12 h", "15 h", "18 h", "21 h"]
          .asMap()
          .entries
          .map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
      clockRotation: 180,
    );

    if (newTimeRange == null) {
      return;
    }
    _timeRange.value = newTimeRange;
    busyAgents();
  }

  Future<void> onRefresh() async {
    y.value = Random().nextInt(100) + 1;
  }

  void busyAgents() {
    var start = _timeRange.value.startTime;
    var end = _timeRange.value.endTime;
    var startInt = double.parse(start.toString().substring(10, 12));
    endInt = double.parse(end.toString().substring(10, 12));

    // log(start.toString().substring(10, 12));
    // log(end.toString().substring(10, 12));
    var diff = endInt - startInt;
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
          TextButton(
            child: Text(
              'Select DateTime',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            onPressed: () {
              def = 0;
              getDateRange(context);
            },
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
                print(_dateTimeRange.value.start);
                return Column(children: [
                  gotDateRange(context),
                  const SizedBox(
                    height: 10,
                  ),
                  def == -1
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
                        width: phoneWidth,
                        padding: EdgeInsets.all(20),
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(children: <Widget>[
                                  const Text(
                                    'PieChart',
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
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
                                  const Text(
                                    '15 sec Interval',
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
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
                                  const Text(
                                    'Agents Timeline',
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
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
                                          _dateTimeRange.value);
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
                                child: Column(children: <Widget>[
                                  const Text(
                                    'Queues',
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      return QbarChart(
                                          x.value,
                                          _timeRange.value.startTime
                                              .format(context),
                                          _timeRange.value.endTime
                                              .format(context),
                                          xAxis,
                                          endInt,
                                          check,
                                          _dateTimeRange.value);
                                    }),
                                  ),
                                ])))),
                  ],
                ),
              ),
              // IndianMap()
              Container(
                height: 600,
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyWidget(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
