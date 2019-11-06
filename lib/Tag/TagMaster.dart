import 'package:flutter/material.dart';
import 'TagManager.dart';
import 'package:fl_chart/fl_chart.dart';

class TagMaster extends StatefulWidget {

  final TagManager tags;

  TagMaster(this.tags);

  @override
  createState() => TagMasterState(tags);
}

class TagMasterState extends State<TagMaster>{

  TagManager tags;

  TagMasterState(this.tags);

  @override
  Widget build(BuildContext context) {

    return LineChart(
      LineChartData(
        gridData: FlGridData(

        )
      )
    );
  }
}