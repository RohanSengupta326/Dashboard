import 'package:flutter/material.dart';
import 'dart:math';
import '../graphs//RefreshGraph.dart';
import '../graphs/qBarChart.dart';
import '../graphs/timeLineChart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../graphs/pieChart.dart';
import 'dart:async';
import '../graphs/lineChart.dart';
import '../graphs/stackedBarChart.dart';
import '../graphs/stackedFillColor.dart';
import '../graphs/stackedArea.dart';
import '../graphs/stackedAreaCustomColor.dart';
import '../graphs/scatterPlotSimple.dart';
import '../graphs/scatterPlotShaped.dart';
import '../graphs/numericLineBarCombo.dart';
import '../graphs/pieChartGauge.dart';
import '../graphs/tabs.dart';
import '../graphs/tabStyletwo.dart';
import '../graphs/tabThreeStyle.dart';
import '../graphs/tabFourStyle.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MaterialColor> _graphColors = [
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.orange,
    Colors.brown,
  ];

  var graphData1 = 0.obs,
      graphData2 = 0.obs,
      selectedStartingTime = 0.0,
      selectedEndTime = 0.0,
      isDateHourMinutesToShow = -1,
      isDefaultTime = -1;
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
      } else {
        isDateHourMinutesToShow = 2;
        // isDateHourMinutesToShow 2 means date range is selected, no time range needed, so send this data to show graphs accordingly
      }
    });
  }

  Widget gotTimeRange(BuildContext context) {
    // body after timeRange selected
    if (isDefaultTime == -1) {
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
    var temp = false, disableTimeRange;

    if ((_dateTimeRange.value.start.toString().substring(0, 10) ==
            _dateTimeRange.value.end.toString().substring(0, 10)) &&
        (_dateTimeRange.value.start.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))) {
      disableTimeRange = TimeRange(
          // anytime in the future= after current time , time cant be selected, only from 12 am to current time of day
          startTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
          endTime: TimeOfDay(hour: 0, minute: 0));
      // temp = true;
      // print(temp);
    } else if ((_dateTimeRange.value.start.toString().substring(0, 10) ==
            _dateTimeRange.value.end.toString().substring(0, 10)) &&
        (_dateTimeRange.value.start.toString().substring(0, 10) !=
            DateTime.now().toString().substring(0, 10))) {
      disableTimeRange = null;
    }
    // print(temp);
    final newTimeRange = GetPlatform.isAndroid
        ? await showTimeRangePicker(
            context: context,
            start: TimeOfDay(hour: 0, minute: 0),
            end: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
            // maxDuration: Duration(days: 1),
            disabledTime: disableTimeRange,
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
            disabledTime: disableTimeRange,
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
    graphData2.value = Random().nextInt(100) + 1;
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
    selectedEndTime = double.parse(
        '${end.toString().substring(10, 12)}.${end.toString().substring(13, 15)}');

    var diff = selectedEndTime - startInt;

    if (diff == 1.0) {
      isDateHourMinutesToShow = 0;
      // isDateHourMinutesToShow = 0 means single date is selected
      selectedStartingTime = startInt;
      // startInt + 5, until it reaches selectedEndTime as xAxis of graph
      graphData1.value = 5;
    }

    // startInt + 1 , till selectedEndTime hour as xAxis
    else if (diff != 1.0) {
      isDateHourMinutesToShow = 1;
      selectedStartingTime = startInt;
      graphData1.value = 20;
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
                isDefaultTime = 0;
                // user pressed button so remove default date by changing isDefaultTime = 0
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return Column(children: [
                  gotDateRange(context),
                  const SizedBox(
                    height: 10,
                  ),
                  isDefaultTime == -1
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
                                    return SimpleBarChart(graphData2.value);
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
                                        graphData1.value,
                                        _timeRange.value.startTime
                                            .format(context),
                                        _timeRange.value.endTime
                                            .format(context),
                                        selectedStartingTime,
                                        selectedEndTime,
                                        isDateHourMinutesToShow,
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
                                      graphData1.value,
                                      _timeRange.value.startTime
                                          .format(context),
                                      _timeRange.value.endTime.format(context),
                                      selectedStartingTime,
                                      selectedEndTime,
                                      isDateHourMinutesToShow,
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
              Text(
                'Toggle Button',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              // tab1
              Container(
                height: 100,
                width: 500,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Tabs(),
                ),
              ),
              Text(
                'GestureDetector with Container',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              // tab2
              Container(
                height: 100,
                width: 500,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: TabStyleTwo(),
                ),
              ),

              Text(
                'ElevatedButton',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              // tab3
              Container(
                height: 100,
                width: 500,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: TabThreeStyle(),
                ),
              ),
              Text(
                'TextButton',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Container(
                height: 100,
                width: 500,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: TabFourStyle(),
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
                          'TimeSeriesChart',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(
                          child: Obx(() {
                            return TimeSeriesLine(
                              graphData1.value,
                              _timeRange.value.startTime,
                              _timeRange.value.endTime,
                              selectedStartingTime.toInt(),
                              selectedEndTime,
                              isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime,
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime,
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime.toInt(),
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime.toInt(),
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime.toInt(),
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime.toInt(),
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
                                    graphData1.value,
                                    _timeRange.value.startTime.format(context),
                                    _timeRange.value.endTime.format(context),
                                    selectedStartingTime.toInt(),
                                    selectedEndTime,
                                    isDateHourMinutesToShow,
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
