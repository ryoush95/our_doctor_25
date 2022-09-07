import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';

class LineChart3Widget extends StatefulWidget {
  const LineChart3Widget(
      {Key? key,
      required this.gradientColor,
      required this.gradientColor1,
      required this.gradientColor2,
      required this.data1,
      required this.data2,
      required this.type,
      this.gradientflag = true})
      : super(key: key);

  final Color gradientColor;
  final Color gradientColor1;
  final Color gradientColor2;
  final HomeGraphTallDto? data1;
  final HomeGraphWeightDto? data2;
  final String type; // temperature or saturation
  final bool gradientflag;

  @override
  _LineChart3WidgetState createState() => _LineChart3WidgetState();
}

class _LineChart3WidgetState extends State<LineChart3Widget> {
  List<Color> gradientColors = [];

  String getBottomTitle(int value) {
    if (widget.type == 'height') {
      return widget.data1!.graph![value].date!.substring(5, 7) + LanguageService.trans("M");
    } else if (widget.type == 'weight') {
      return widget.data2!.graph![value].date!.substring(5, 7) + LanguageService.trans("M");
    }
    return '';
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
              // LineChart(
              //   mainData(),
              // ),
              // LineChart(
              //   mainData1(),
              // ),
              // widget.type == 'height'
              //     ? LineChart(
              //         mainData2(),
              //       )
              //     : Container(),
              LineChart(
                allData(),
              )
            ],
          )),
    ) /*,
        ))*/
        ;
  }

  LineChartData allData() {
    return LineChartData(
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
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
          interval: ((getMaxY() - getMinY()) / 4) == 0 ? 1 : 1,
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium),
          getTitles: (value) {
            return getBottomTitle(value.toInt());
          },
          margin: 10,
        ),
        rightTitles: SideTitles(
          showTitles: true,
          // interval: ((maxY - minY) / 3).floor().toDouble(),
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xffa0a0a0), 11, weight: FW.medium),
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 32,
          // margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: widget.type == 'height' ? widget.data1!.graph!.length.toDouble() - 1 : widget.data2!.graph!.length.toDouble() - 1,
      minY: getMinY().floor() - 1.0,
      maxY: getMaxY().ceil() + 1.0,
      lineBarsData: widget.type == 'height'
          ? [
              LineChartBarData(
                spots: spotList(),
                isCurved: false,
                colors: [widget.gradientColor],
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true, getDotPainter: customDotPainter),
                //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
              ),
              LineChartBarData(
                spots: spotList1(),
                isCurved: false,
                colors: [widget.gradientColor1],
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true, getDotPainter: customDotPainter1),
                //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
              ),
              LineChartBarData(
                spots: spotList2(),
                isCurved: false,
                colors: [widget.gradientColor2],
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true, getDotPainter: customDotPainter2),
                //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
              ),
            ]
          : [
              LineChartBarData(
                spots: spotList(),
                isCurved: false,
                colors: [widget.gradientColor],
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true, getDotPainter: customDotPainter),
                //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
              ),
              LineChartBarData(
                spots: spotList1(),
                isCurved: false,
                colors: [widget.gradientColor1],
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true, getDotPainter: customDotPainter1),
                //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
              ),
            ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
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
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
          interval: ((getMaxY() - getMinY()) / 4) == 0 ? 1 : 1,
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium),
          getTitles: (value) {
            return getBottomTitle(value.toInt());
          },
          margin: 10,
        ),
        rightTitles: SideTitles(
          showTitles: true,
          // interval: ((maxY - minY) / 3).floor().toDouble(),
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xffa0a0a0), 11, weight: FW.medium),
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 32,
          // margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: widget.type == 'height' ? widget.data1!.graph!.length.toDouble() - 1 : widget.data2!.graph!.length.toDouble() - 1,
      minY: getMinY().floor() - 1.0,
      maxY: getMaxY().ceil() + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: spotList(),
          isCurved: false,
          colors: [widget.gradientColor],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: customDotPainter),
          //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
        ),
      ],
    );
  }

  LineChartData mainData1() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
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
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
          interval: ((getMaxY() - getMinY()) / 4) == 0 ? 1 : 1,
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium),
          getTitles: (value) {
            return getBottomTitle(value.toInt());
          },
          margin: 10,
        ),
        rightTitles: SideTitles(
          showTitles: true,
          // interval: ((maxY - minY) / 3).floor().toDouble(),
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xffa0a0a0), 11, weight: FW.medium),
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 32,
          // margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: widget.type == 'height' ? widget.data1!.graph!.length.toDouble() - 1 : widget.data2!.graph!.length.toDouble() - 1,
      minY: getMinY().floor() - 1.0,
      maxY: getMaxY().ceil() + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: spotList1(),
          isCurved: false,
          colors: [widget.gradientColor1],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: customDotPainter1),
          //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
        ),
      ],
    );
  }

  LineChartData mainData2() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
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
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
          interval: ((getMaxY() - getMinY()) / 4) == 0 ? 1 : 1,
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium),
          getTitles: (value) {
            return getBottomTitle(value.toInt());
          },
          margin: 10,
        ),
        rightTitles: SideTitles(
          showTitles: true,
          // interval: ((maxY - minY) / 3).floor().toDouble(),
          getTextStyles: (context, value) => AppTextStyle.PD(const Color(0xffa0a0a0), 11, weight: FW.medium),
          getTitles: (value) {
            return value.toString();
          },
          reservedSize: 32,
          // margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: widget.data1!.graph!.length.toDouble() - 1,
      minY: getMinY().floor() - 1.0,
      maxY: getMaxY().ceil() + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: spotList2(),
          isCurved: false,
          colors: [widget.gradientColor2],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: customDotPainter2),
          //belowBarData: BarAreaData(show: true, colors: gradientColors.map((color) => this.widget.gradientflag ? color.withOpacity(0.8) : Colors.white).toList(), gradientFrom: const Offset(0, 0), gradientTo: const Offset(0, 1)),
        ),
      ],
    );
  }

  FlDotPainter customDotPainter(FlSpot spot, double xPercentage, LineChartBarData bar, int index, {double? size}) {
    return FlDotCirclePainter(radius: 3.0, color: widget.gradientColor, strokeColor: Colors.white, strokeWidth: 1);
  }

  FlDotPainter customDotPainter1(FlSpot spot, double xPercentage, LineChartBarData bar, int index, {double? size}) {
    return FlDotCirclePainter(radius: 3.0, color: widget.gradientColor1, strokeColor: Colors.white, strokeWidth: 1);
  }

  FlDotPainter customDotPainter2(FlSpot spot, double xPercentage, LineChartBarData bar, int index, {double? size}) {
    return FlDotCirclePainter(radius: 3.0, color: widget.gradientColor2, strokeColor: Colors.white, strokeWidth: 1);
  }

  double getMinY() {
    double minY = 0;

    double i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (double.parse(report.child!) == 0.0) {
          continue;
        }
        if (i == 0) {
          minY = double.parse(report.child!);
        }
        if (report.child! != '') {
          if (minY > double.parse(report.child!)) {
            minY = double.parse(report.child!);
          }
        }
        i += 1;
      }
    } else if (widget.type == 'weight') {
      for (var report in widget.data2!.graph!) {
        if (double.parse(report.child!) == 0.0) {
          continue;
        }
        if (i == 0) {
          minY = double.parse(report.child!);
        }
        if (report.child! != '') {
          if (minY > double.parse(report.child!)) {
            minY = double.parse(report.child!);
          }
        }
        i += 1;
      }
    }

    i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (double.parse(report.country!) == 0.0) {
          continue;
        }
        if (report.country! != '') {
          if (minY > double.parse(report.country!)) {
            minY = double.parse(report.country!);
          }
        }
        i += 1;
      }
    } else if (widget.type == 'weight') {
      for (var report in widget.data2!.graph!) {
        if (double.parse(report.country!) == 0.0) {
          continue;
        }
        if (report.country! != '') {
          if (minY > double.parse(report.country!)) {
            minY = double.parse(report.country!);
          }
        }
        i += 1;
      }
    }

    i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (double.parse(report.expect!) == 0.0) {
          continue;
        }
        if (report.expect! != '') {
          if (minY > double.parse(report.expect!)) {
            minY = double.parse(report.expect!);
          }
        }
        i += 1;
      }
    }
    return minY;
  }

  double getMaxY() {
    double maxY = 0;

    double i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (i == 0) {
          maxY = double.parse(report.child!);
        }
        if (report.child! != '') {
          if (maxY < double.parse(report.child!)) {
            maxY = double.parse(report.child!);
          }
        }
        i += 1;
      }
    } else if (widget.type == 'weight') {
      for (var report in widget.data2!.graph!) {
        if (i == 0) {
          maxY = double.parse(report.child!);
        }
        if (report.child! != '') {
          if (maxY < double.parse(report.child!)) {
            maxY = double.parse(report.child!);
          }
        }
        i += 1;
      }
    }

    i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (report.country! != '') {
          if (maxY < double.parse(report.country!)) {
            maxY = double.parse(report.country!);
          }
        }
        i += 1;
      }
    } else if (widget.type == 'weight') {
      for (var report in widget.data2!.graph!) {
        if (report.country! != '') {
          if (maxY < double.parse(report.country!)) {
            maxY = double.parse(report.country!);
          }
        }
        i += 1;
      }
    }

    i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (report.expect! != '') {
          if (maxY < double.parse(report.expect!)) {
            maxY = double.parse(report.expect!);
          }
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
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (report.child! != '' && double.parse(report.child!) != 0.0) {
          spotList.add(FlSpot(i, double.parse(report.child!)));
        }
        i += 1;
      }
    } else if (widget.type == 'weight') {
      for (var report in widget.data2!.graph!) {
        if (report.child! != '' && double.parse(report.child!) != 0.0) {
          spotList.add(FlSpot(i, double.parse(report.child!)));
        }
        i += 1;
      }
    }
    return spotList;
  }

  List<FlSpot> spotList1() {
    List<FlSpot> spotList1 = [];

    double i = 0;
    spotList1.clear();
    i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (report.country! != '' && double.parse(report.country!) != 0.0) {
          spotList1.add(FlSpot(i, double.parse(report.country!)));
        }
        i += 1;
      }
    } else if (widget.type == 'weight') {
      for (var report in widget.data2!.graph!) {
        if (report.country! != '' && double.parse(report.country!) != 0.0) {
          spotList1.add(FlSpot(i, double.parse(report.country!)));
        }
        i += 1;
      }
    }
    return spotList1;
  }

  List<FlSpot> spotList2() {
    List<FlSpot> spotList2 = [];

    double i = 0;
    spotList2.clear();
    i = 0;
    if (widget.type == 'height') {
      for (var report in widget.data1!.graph!) {
        if (report.expect! != '' && double.parse(report.expect!) != 0.0) {
          spotList2.add(FlSpot(i, double.parse(report.expect!)));
        }
        i += 1;
      }
    }
    return spotList2;
  }
}
