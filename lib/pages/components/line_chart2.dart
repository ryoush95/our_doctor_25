import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitoring/sleep_graph_model.dart';
import 'package:sprintf/sprintf.dart';

class LineChartWidget2 extends StatefulWidget {
  const LineChartWidget2({Key? key, required this.data1, required this.type})
      : super(key: key);

  final SleepDataDto? data1;
  final String type; // temperature or saturation

  @override
  _LineChartWidget2State createState() => _LineChartWidget2State();
}

class _LineChartWidget2State extends State<LineChartWidget2> {
  List<Color> gradientColors = [];
  ScrollController sc = ScrollController();
  DateTime now = DateTime.now();

  Widget getBottomTitle(int value, TitleMeta meta) {
    String title = '';
    final style =
        AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium);

    if (widget.type == 'night') {
      title = widget.data1!.graphSleep![value].date!.substring(8, 10) + '일';
    } else if (widget.type == 'launch') {
      title = widget.data1!.graphSleep![value].date!.substring(8, 10) + '일';
    }
    return SideTitleWidget(
        child: Text(title, style: style), axisSide: meta.axisSide);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      sc.jumpTo(now.day.toDouble() * 22);
    });
    gradientColors = [
    widget.type == "night" ? AppColor_Primary.withOpacity(0.8) : AppColor_Breath.withOpacity(0.8),
      const Color(0xffffffff),
      // widget.type == 'temperature'? const Color(0xffc3c9c7): widget.type == 'saturation'? const Color(0xffc9c8c3): const Color(0xffc9c9c4)
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'night' ||
        widget.type == 'launch') {
      return Scrollbar(
          thickness: 4,
          radius: const Radius.circular(2),
          child: SingleChildScrollView(
            controller: sc,
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
                  padding: const EdgeInsets.only(
                      right: 0.0, left: 16.0, top: 12, bottom: 12),
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
            padding: const EdgeInsets.only(
                right: 0.0, left: 16.0, top: 12, bottom: 12),
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
        touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            if (widget.type == 'food') {
              return LineTooltipItem(sprintf("%.1f", [barSpot.y]),
                  const TextStyle(color: Colors.white));
            } else if (widget.type == 'night' || widget.type == 'launch') {
              return LineTooltipItem(sprintf("%.1f", [barSpot.y / 60.0]),
                  const TextStyle(color: Colors.white));
            }
            return LineTooltipItem(sprintf("%.1f", [barSpot.y / 60.0]),
                const TextStyle(color: Colors.white));
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
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              // interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
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
              // interval: 20,
              getTitlesWidget: (value, meta) {
                String title = '';
                final style = AppTextStyle.PD(const Color(0xff585859), 11,
                    weight: FW.medium);
                if (widget.type == 'food') {
                  title = sprintf("%.0f", [value]);
                } else if (widget.type == 'night' || widget.type == 'launch') {
                  if (meta.min == value || meta.max == value) {
                    return SideTitleWidget(
                        child: Text("", style: style), axisSide: meta.axisSide);
                  }
                  title = sprintf("%.1f", [value / 60.0]);
                } else {
                  title = value.toString();
                }

                return SideTitleWidget(
                    child: Text(title, style: style), axisSide: meta.axisSide);
              },
              reservedSize: 32,
            ),
          )),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - 1,
      minY: getMinY().ceil() - 1.0,
      maxY: getMaxY().ceil() + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: spotList(),
          isCurved: false,
          color: widget.type == "night" ? AppColor_Primary : AppColor_Breath,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: customDotPainter),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.8))
                  .toList(),
            ),
            // colors: gradientColors.map((color) => color.withOpacity(0.8)).toList(),
            // gradientFrom: const Offset(0, 0),
            // gradientTo: const Offset(0, 1),
            // cutOffY:
          ),
        ),
      ],
    );
  }

  FlDotPainter customDotPainter(
      FlSpot spot, double xPercentage, LineChartBarData bar, int index,
      {double? size}) {
    return FlDotCirclePainter(
        radius: 3.0,
        color: widget.type == "night" ? AppColor_Primary : AppColor_Breath,
        strokeColor: Colors.white,
        strokeWidth: 1);
  }

  double getMinY() {
    double minY = 0;

    double i = 0;
    if (widget.type == 'night') {
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
    return minY;
  }

  double getMaxY() {
    double maxY = 0;

    double i = 0;
    if (widget.type == 'night') {
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
    return maxY;
  }

  List<FlSpot> spotList() {
    List<FlSpot> spotList = [];

    double i = 0;
    spotList.clear();
    if (widget.type == 'night') {
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
    return spotList;
  }
}
