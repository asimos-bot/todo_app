import 'package:flutter/material.dart';
import 'Tag.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:todo_yourself/globals.dart' as globals;

class TagChart extends StatefulWidget {

  final Future<List<Map>> futurePoints;
  final Tag tag;

  TagChart(this.futurePoints, this.tag);

  @override
  createState() => TagChartState(futurePoints, tag);
}

class TagChartState extends State<TagChart> {

  final Future<List<Map>> futurePoints;
  final Tag tag;

  List<Color> gradientColors = [
    globals.thirdForegroundColor,
    globals.forthForegroundColor
  ];

  TagChartState(this.futurePoints, this.tag);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: futurePoints,
      builder: (context, snapshot) {

        List<Map> points = snapshot.data;

        if( snapshot.connectionState == ConnectionState.done ){

          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(30)
                  ),
                  color: globals.primaryForegroundColor
              ),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: getCurveChart(
                      tag.manager.pointsToSpots(
                          points,
                          tag.created_at
                      )
                  )
              )
            )
          );
        }

        return Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }

  Widget getCurveChart(List<FlSpot> points){

    if( points.length == 0 ){

      return Center(
          child: Text("No Points Acquired")
      );
    }

    return LineChart(
        LineChartData(
            minX: 0,
            minY: 0,
            maxX: globals.chartPastSpanDays + globals.chartFutureSpanDays.toDouble(),
            lineBarsData: [
              LineChartBarData(
                  spots: points,
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 5,
                  isStrokeCapRound: true
              )
            ]
        )
    );
  }
}