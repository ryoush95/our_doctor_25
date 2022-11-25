import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:sprintf/sprintf.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key, required this.gradientColor, required this.data, this.data1, required this.type, this.gradientflag = true}) : super(key: key);

  final Color gradientColor;
  final List<ReportDto> data;
  final HomeGraphLifeStyleDto? data1;
  final String type; // temperature or saturation
  final bool gradientflag;

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<Color> gradientColors = [];

  Widget getBottomTitle(int value, TitleMeta meta) {
    String title = '';
    final style = AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium);

    if (widget.data.isNotEmpty) {
      if (value % 2 == 0) {
        title = widget.data[(value / 2).floor()].morning_time.substring(8, 10) + LanguageService.trans("M");
      } else {
        title = widget.data[(value / 2).floor()].afternoon_time.substring(8, 10) + LanguageService.trans("M");
      }
      // return title;
    } else if (widget.data1 != null) {
      if (widget.type == 'food') {
        title = widget.data1!.graphFood![value].date!.substring(8, 10) + '일';
      } else if (widget.type == 'night') {
        title = widget.data1!.graphSleep![value].date!.substring(8, 10) + '일';
      } else if (widget.type == 'launch') {
        title = widget.data1!.graphSleep![value].date!.substring(8, 10) + '일';
      }
    }
    return SideTitleWidget(child: Text(title, style: style), axisSide: meta.axisSide);
  }

  @override
  void initState() {
    super.initState();
    gradientColors = [
      widget.gradientColor.withOpacity(0.8),
      const Color(0xffffffff),
      // widget.type == 'temperature'? const Color(0xffc3c9c7): widget.type == 'saturation'? const Color(0xffc9c8c3): const Color(0xffc9c9c4)
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'food' || widget.type == 'night' || widget.type == 'launch') {
      return Scrollbar(
          thickness: 4,
          radius: const Radius.circular(2),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // aspectRatio: 1.70,
            child: Container(
              width: 900,
              height: 150,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.only(right: 0.0, left: 16.0, top: 12, bottom: 12),
                  child: Stack(
                    children: [
                      LineChart(
                        mainData(),
                      ),
                    ],
                  )),
            ),
          ));
    } else {
      return /*Scrollbar(
        thickness: 4,
        radius: const Radius.circular(2),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // aspectRatio: 1.70,
          child: */
          Container(
        /*width: 600,*/
        height: 150,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            color: Colors.white),
        child: Padding(
            padding: const EdgeInsets.only(right: 0.0, left: 16.0, top: 12, bottom: 12),
            child: Stack(
              children: [
                LineChart(
                  mainData(),
                ),
              ],
            )),
      ) /*,
        ))*/
          ;
    }
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            if (widget.type == 'food') {
              return LineTooltipItem(sprintf("%.1f", [barSpot.y]), const TextStyle(color: Colors.white));
            } else if (widget.type == 'night' || widget.type == 'launch') {
              return LineTooltipItem(sprintf("%.1f", [barSpot.y / 60.0]), const TextStyle(color: Colors.white));
            }
            return LineTooltipItem(sprintf("%.1f", [barSpot.y / 60.0]), const TextStyle(color: Colors.white));
          }).toList();
        }),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xfff4f4f4),
            strokeWidth: 2,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
            interval: ((getMaxY() - getMinY()) / 4) == 0 ? 1 : 1,
            getTitlesWidget: (value, meta) {
              return getBottomTitle(value.toInt(), meta);
            },
            // margin: 10,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // interval: 10,
            getTitlesWidget: (value, meta) {
              String title = '';
              final style = AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium);
              if (widget.type == 'food') {
                title = sprintf("%.0f", [value]);
              } else if (widget.type == 'night' || widget.type == 'launch') {
                title = sprintf("%.1f", [value / 60.0]);
              } else {
                title = value.toString();
              }

              return SideTitleWidget(child: Text(title, style: style), axisSide: meta.axisSide);
            },
            reservedSize: 32,
            // margin: 12,
          ),
        )

      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: widget.data.isNotEmpty ? 13 : (widget.type == 'food' ? widget.data1!.graphFood!.length.toDouble() - 1 : widget.data1!.graphSleep!.length.toDouble() - 1),
      minY: getMinY().floor() - 1.0,
      maxY: getMaxY().ceil() + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: spotList(),
          isCurved: false,
          color: widget.gradientColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: customDotPainter),
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(colors: gradientColors.map((color) => color.withOpacity(0.8)).toList(),),
              // colors: gradientColors.map((color) => color.withOpacity(0.8)).toList(),
              // gradientFrom: const Offset(0, 0),
              // gradientTo: const Offset(0, 1),
              // cutOffY:
          ),
        ),
      ],
    );
  }

  FlDotPainter customDotPainter(FlSpot spot, double xPercentage, LineChartBarData bar, int index, {double? size}) {
    return FlDotCirclePainter(radius: 3.0, color: widget.gradientColor, strokeColor: Colors.white, strokeWidth: 1);
  }

  double getMinY() {
    double minY = 0;

    double i = 0;
    if (widget.data.isNotEmpty) {
      for (var report in widget.data) {
        if (double.parse(report.morning_temperature) == 0.0) {
          continue;
        }
        if (i == 0) {
          minY = double.parse(report.morning_temperature);
        }
        if (report.morning_temperature != '') {
          if (minY > double.parse(report.morning_temperature)) {
            minY = double.parse(report.morning_temperature);
          }
        }
        i += 1;
      }
    } else if (widget.data1 != null) {
      if (widget.type == 'food') {
        for (var report in widget.data1!.graphFood!) {
          if (report.kcal! == 0.0) {
            continue;
          }
          if (i == 0) {
            minY = report.kcal!;
          }
          if (minY > report.kcal!) {
            minY = report.kcal!;
          }
          i += 1;
        }
      } else if (widget.type == 'night') {
        for (var report in widget.data1!.graphSleep!) {
          if (report.sleepNight!.toDouble() == 0.0) {
            continue;
          }
          if (i == 0) {
            minY = report.sleepNight!.toDouble();
          }
          if (minY > report.sleepNight!.toDouble()) {
            minY = report.sleepNight!.toDouble();
          }
          i += 1;
        }
      } else if (widget.type == 'launch') {
        for (var report in widget.data1!.graphSleep!) {
          if (report.sleepLaunch!.toDouble() == 0.0) {
            continue;
          }
          if (i == 0) {
            minY = report.sleepLaunch!.toDouble();
          }
          if (minY > report.sleepLaunch!.toDouble()) {
            minY = report.sleepLaunch!.toDouble();
          }
          i += 1;
        }
      }
    }
    return minY;
  }

  double getMaxY() {
    double maxY = 0;

    double i = 0;
    if (widget.data.isNotEmpty) {
      for (var report in widget.data) {
        if (i == 0) {
          maxY = double.parse(report.morning_temperature);
        }
        if (report.morning_temperature != '') {
          if (maxY < double.parse(report.morning_temperature)) {
            maxY = double.parse(report.morning_temperature);
          }
        }
        i += 1;
      }
    } else if (widget.data1 != null) {
      if (widget.type == 'food') {
        for (var report in widget.data1!.graphFood!) {
          if (i == 0) {
            maxY = report.kcal!;
          }
          if (maxY < report.kcal!) {
            maxY = report.kcal!;
          }
          i += 1;
        }
      } else if (widget.type == 'night') {
        for (var report in widget.data1!.graphSleep!) {
          if (i == 0) {
            maxY = report.sleepNight!.toDouble();
          }
          if (maxY < report.sleepNight!.toDouble()) {
            maxY = report.sleepNight!.toDouble();
          }
          i += 1;
        }
      } else if (widget.type == 'launch') {
        for (var report in widget.data1!.graphSleep!) {
          if (i == 0) {
            maxY = report.sleepLaunch!.toDouble();
          }
          if (maxY < report.sleepLaunch!.toDouble()) {
            maxY = report.sleepLaunch!.toDouble();
          }
          i += 1;
        }
      }
    }
    return maxY;
  }

  List<FlSpot> spotList() {
    List<FlSpot> spotList = [];

    double i = 0;
    spotList.clear();
    if (widget.data.isNotEmpty) {
      for (var report in widget.data) {
        if (report.morning_temperature != '' && double.parse(report.morning_temperature) != 0.0) {
          spotList.add(FlSpot(i, double.parse(report.morning_temperature)));
        }
        i += 1;
      }
    } else if (widget.data1 != null) {
      if (widget.type == 'food') {
        for (var report in widget.data1!.graphFood!) {
          if (report.kcal != 0.0) {
            spotList.add(FlSpot(i, report.kcal!));
          }
          i += 1;
        }
      } else if (widget.type == 'night') {
        for (var report in widget.data1!.graphSleep!) {
          if (report.sleepNight!.toDouble() != 0.0) {
            spotList.add(FlSpot(i, report.sleepNight!.toDouble()));
          }
          i += 1;
        }
      } else if (widget.type == 'launch') {
        for (var report in widget.data1!.graphSleep!) {
          if (report.sleepLaunch!.toDouble() != 0.0) {
            spotList.add(FlSpot(i, report.sleepLaunch!.toDouble()));
          }
          i += 1;
        }
      }
    }
    return spotList;
  }
}
