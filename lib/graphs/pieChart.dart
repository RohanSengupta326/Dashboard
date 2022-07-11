import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';

class PieChart extends StatefulWidget {
  var _graphColors;
  PieChart(this._graphColors);

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<Task, String>> _seriesPieData = [];

  _generateData() {
    var piedata = [
      Task('Inbound', 10, widget._graphColors[0]),
      Task('Outbound', 14, widget._graphColors[1]),
      Task('Missed', 20, widget._graphColors[2]),
      Task('Waiting in queue', 30, widget._graphColors[3]),
      Task('Waiting in ivr', 0, widget._graphColors[4]),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'sample',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart<String>(
      animate: true,
      animationDuration: Duration(seconds: 3),
      _seriesPieData,
      behaviors: [
        charts.DatumLegend(
          horizontalFirst: false,
          desiredMaxRows: 3,
          cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            fontFamily: 'Lato',
              color: charts.MaterialPalette.black.lighter, fontSize: 20),
        )
      ],
      defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
        charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
            outsideLabelStyleSpec: charts.TextStyleSpec(
                fontSize: 25,
                fontFamily: 'Lato',
                color: charts.ColorUtil.fromDartColor(Colors.amber)))
      ]),
    );
  }
}

class Task {
  String task;
  int taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
