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

  TagChartState(this.futurePoints, this.tag);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: futurePoints,
      builder: (context, snapshot) {

        List<Map> points = snapshot.data;

        if( snapshot.connectionState == ConnectionState.done ){

          DateTime now = DateTime.now();

          List<FlSpot> spots = tag.manager.pointsToSpots(
              points,
              DateTime(now.year, now.month, now.day).subtract(Duration(days: 30))
          );

          //get highest point
          int highest_point = (){
            int highest=spots[0].y.toInt();
            for(int i=1; i < spots.length; i++) highest = spots[i].y.toInt() > highest ? spots[i].y.toInt() : highest;
            return highest;
          }();

          //get lowest point
          int lowest_point = (){
            int lowest=spots[0].y.toInt();
            for(int i=1; i < spots.length; i++) lowest = spots[i].y.toInt() < lowest ? spots[i].y.toInt() : lowest;
            return lowest;
          }();

          return Padding(
                  padding: EdgeInsets.fromLTRB(27.0, 10.0, 27.0, 10.0),
                  child: getCurveChart(
                    spots,
                    highest_point,
                    lowest_point
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

  Widget getCurveChart(List<FlSpot> points, int highest_point, int lowest_point){

    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    return LineChart(
        LineChartData(
            minX: 0,
            minY: lowest_point >= 0 ? 0 : lowest_point*1.2,
            maxX: globals.chartPastSpanDays + globals.chartFutureSpanDays.toDouble(),
            maxY: highest_point == 0 ? 1 : highest_point*1.2,
            clipToBorder: false,
            gridData: FlGridData(
                show: false,
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
                show: false,
                border: Border.all(color: globals.secondaryBackgroundColor, width: 1)
            ),
            //ACTUAL CURVES
            lineBarsData: [
              LineChartBarData(
                  spots: points,
                  isCurved: false,
                  colors: [tag.color],
                  colorStops: null,
                  barWidth: 5,
                  isStrokeCapRound: true,

                  //make dots invisible
                  dotData: const FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [tag.color.withOpacity(0.3)],
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

                if( daysAgo % 10 !=0 ) return '';

                return daysAgoToDate(currentDate, daysAgo.toInt());
              }
            )
          ),
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes){

              return spotIndexes.map((spotIndex) {

                return TouchedSpotIndicatorData(
                  FlLine(color: globals.secondaryForegroundColor, strokeWidth: 4),
                  FlDotData(dotSize: 3, dotColor: globals.secondaryForegroundColor),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: globals.secondaryForegroundColor,
              tooltipRoundedRadius: 4,
              tooltipPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              tooltipBottomMargin: -26,

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
          ),
        )
    );
  }
}