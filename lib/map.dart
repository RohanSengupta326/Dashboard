import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late List<Model> data;
  late MapShapeSource _mapSource;

  @override
  void initState() {
    data = <Model>[
      Model('Goa', Colors.redAccent, 'Goa'),
      Model('West Bengal', Colors.yellowAccent, 'WB'),
      Model('Uttar Pradesh', Colors.blueAccent, 'UP'),
    ];

    _mapSource = MapShapeSource.asset(
      'assets/map.json',
      shapeDataField: 'NAME_1',
      dataCount: data.length,
      primaryValueMapper: (int index) => data[index].state,
      // dataLabelMapper: (int index) => data[index].stateCode,
      shapeColorValueMapper: (int index) => data[index].color,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfMaps(
      layers: <MapShapeLayer>[
        MapShapeLayer(
          source: _mapSource,
          // legend: MapLegend(MapElement.shape),
          // showDataLabels: true,
          shapeTooltipBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                data[index].stateCode,
              ),
            );
          },
          tooltipSettings: MapTooltipSettings(
              color: Colors.grey[700],
              strokeColor: Colors.white,
              strokeWidth: 2),
          strokeColor: Colors.white,
          strokeWidth: 0.5,
          dataLabelSettings: MapDataLabelSettings(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10)),
        ),
      ],
    );
  }
}

class Model {
  Model(this.state, this.color, this.stateCode);

  String state;
  Color color;
  String stateCode;
}
