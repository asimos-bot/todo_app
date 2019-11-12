import 'package:flutter/material.dart';
import 'TagManager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Tag.dart';
import 'package:todo_yourself/globals.dart' as globals;

class TagMaster extends StatefulWidget {

  final TagManager tags;

  TagMaster(this.tags);

  @override
  createState() => TagMasterState(tags);
}

class TagMasterState extends State<TagMaster>{

  DateTime currentDate;

  int highest_y=-1;

  TagManager manager;

  TagMasterState(this.manager){

    DateTime now = DateTime.now();

    currentDate = DateTime(now.year, now.month, now.day);
  }

  String daysAgoToDate(DateTime currentDate, int daysAgo){

    DateTime date = currentDate.subtract(Duration(days: daysAgo));

    return "${date.day}/${date.month}";
  }

  Future<LineChartBarData> getCurveFromTag(Tag tag) async {

    List<FlSpot> spots = manager.pointsToSpots(await manager.getPoints(tag.id), currentDate.subtract(Duration(days: 30)));

    for(int i=0; i<spots.length; i++) if( highest_y < spots[i].y ) highest_y = spots[i].y.toInt();

    return LineChartBarData(
        spots: spots,
        isCurved: true,
        preventCurveOverShooting: true,
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
    );
  }

  Future<List<LineChartBarData>> getCurvesList() async {

    List<Tag> tags = await manager.list();

    List<LineChartBarData> curves = [];

    for(int i=0; i < tags.length; i++){

      curves.add(await getCurveFromTag(tags[i]));
    }

    return curves;
  }

  Widget getLineChart(List<LineChartBarData> curves) {

    return LineChart(
        LineChartData(
          minX: 0,
          minY: 0,
          maxX: globals.chartPastSpanDays + globals.chartFutureSpanDays.toDouble(),
          maxY: highest_y == 0 ? 1 : highest_y*1.2,
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
          lineBarsData: curves,
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
                    FlDotData(dotSize: 4, dotColor: globals.secondaryForegroundColor),
                  );
                }).toList();
              },
              touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: globals.secondaryForegroundColor,
                  tooltipRoundedRadius: 4,
                  tooltipPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  tooltipBottomMargin: -128,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {

                    return touchedBarSpots.map((barSpot){

                      return LineTooltipItem(
                          barSpot.y.toInt().toString(),
                          TextStyle(
                            color: barSpot.bar.colors[0],
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Master Chart")
        )
      ),
      body: FutureBuilder(

        future: getCurvesList(),
        builder: (context, snapshot) {

          if( snapshot.connectionState == ConnectionState.done ){

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.fromLTRB(27.0, 10.0, 27.0, 10.0),
                child: getLineChart(snapshot.data)
              )
            );
          }

          return Center(
            child: CircularProgressIndicator()
          );
        }
      )
    );
  }
}