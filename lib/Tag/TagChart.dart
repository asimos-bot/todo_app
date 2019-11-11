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

          DateTime now = DateTime.now();

          return Padding(
                  padding: EdgeInsets.fromLTRB(23.0, 10.0, 23.0, 10.0),
                  child: getCurveChart(
                    tag.manager.pointsToSpots(
                      points,
                      DateTime(now.year, now.month, now.day).subtract(Duration(days: 30))
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

  String daysAgoToDate(DateTime currentDate, int daysAgo){

    DateTime date = currentDate.subtract(Duration(days: daysAgo));

    return "${date.day}/${date.month}";
  }

  Widget getCurveChart(List<FlSpot> points){

    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    //get highest point
    int highest_point = (){
      int highest=points[0].y.toInt();
      for(int i=1; i < points.length; i++) highest = points[i].y.toInt() > highest ? points[i].y.toInt() : highest;
      return highest;
    }();

    return LineChart(
        LineChartData(
            minX: 0,
            minY: 0,
            maxY: highest_point*1.2,
            maxX: globals.chartPastSpanDays + globals.chartFutureSpanDays.toDouble(),
            clipToBorder: false,
            gridData: FlGridData(
                show: true,
                drawVerticalGrid: true,
                getDrawingHorizontalGridLine: (value) {
                  return FlLine(
                    color: globals.secondaryBackgroundColor,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalGridLine: (value){
                  return FlLine(
                    color: globals.secondaryBackgroundColor,
                    strokeWidth: 1,
                  );
                }
            ),
            //BORDER
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: globals.secondaryBackgroundColor, width: 1)
            ),
            //ACTUAL CURVES
            lineBarsData: [
              LineChartBarData(
                  spots: points,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  colors: gradientColors,
                  barWidth: 5,
                  isStrokeCapRound: true,

                  //make dots invisible
                  dotData: const FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    colors:
                    gradientColors.reversed.map((color) => color.withOpacity(0.3)).toList(),
                  )
              )
            ],
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(
              showTitles: false
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              textStyle: TextStyle(
                color: globals.secondaryForegroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 13
              ),
              getTitles: (daysAgo) {

                daysAgo = globals.chartPastSpanDays - daysAgo;

                if( daysAgo % 7 !=0 ) return '';

                return daysAgoToDate(currentDate, daysAgo.toInt());
              }
            )
          ),
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes){

              return spotIndexes.map((spotIndex) {

                return TouchedSpotIndicatorData(
                  FlLine(color: globals.secondaryForegroundColor, strokeWidth: 4),
                  FlDotData(dotSize: 8, dotColor: globals.secondaryForegroundColor),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: globals.secondaryForegroundColor,
              tooltipRoundedRadius: 4,
              tooltipPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),

              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {

                return touchedBarSpots.map((barSpot){

                  return LineTooltipItem(
                    barSpot.y.toInt().toString() + '\n' + daysAgoToDate(currentDate, globals.chartPastSpanDays - barSpot.x.toInt()),
                    TextStyle(
                      color: globals.backgroundColor,
                      fontWeight: FontWeight.bold
                    )
                  );
                }).toList();
              }
            )
          )
        )
    );
  }
}