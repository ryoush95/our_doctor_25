import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/price_point.dart';
import 'package:sprintf/sprintf.dart';

class LineChartTemp extends StatefulWidget {
  const LineChartTemp({Key? key, required this.points, required this.points2}) : super(key: key);

  final List<PricePoint> points;
  final List<PricePoint> points2;

  @override
  State<LineChartTemp> createState() => _LineChartTempState(points: this.points);
}

class _LineChartTempState extends State<LineChartTemp> {
  final List<PricePoint> points;
  late int showingTooltipSpot;

  _LineChartTempState({required this.points});

  List<String> d = [];
  List<Color> gradientColors = [];
  ScrollController sc = ScrollController();
  DateTime now = DateTime.now();
  int dateCount = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - 1;


  @override
  void initState() {
    showingTooltipSpot = -1;
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      sc.jumpTo(now.day.toDouble() * 22);
    });
    DateTime(now.year, now.month + 1, 0).day.toDouble();

    for (int i = 0; i <= dateCount; i++) {
      String a = (i +1).toString();
      d.add(a);
    }
  }

  List<FlSpot>? spotList() {
    List<FlSpot>? spotList = [];

    double i = 0;
    spotList.clear();
    for (var report in points) {
      if (report.y != 0.0) {
        spotList.add(FlSpot(i, double.parse(report.y.toStringAsFixed(2))));
      }
      i += 1;
    }
    // print();
    return spotList;
  }

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      thickness: 4,
      child: SingleChildScrollView(
        controller: sc,
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 150,
          margin: const EdgeInsets.all(10),
          child: Stack(
            children: [
              defaultData(widget.points2),
              mainData(widget.points),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainData(List<PricePoint> points) {
    final _lineBarsData = [
      LineChartBarData(
          spots: spotList(),
          isCurved: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 3,
                  color: AppColor_Height,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
          ),
          color: AppColor_Height
      ),
    ];
    return AspectRatio(
      aspectRatio: 6,
      child: LineChart(
        LineChartData(
          minY: 34,
          maxY: 42,
          minX: 0,
          maxX: dateCount.toDouble(),
          lineBarsData: _lineBarsData,
          borderData: FlBorderData(show: false),
          // 회색 가로줄
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            // 회색 가로줄
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xfff4f4f4),
                strokeWidth: 2,
              );
            },
          ),
          // 가로세로 수치 입력
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  final style = AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium);
                  String title = sprintf("%.0f", [value]);

                  return SideTitleWidget(child: Text(title, style: style), axisSide: meta.axisSide);
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
                interval:  1,
                getTitlesWidget: (value, meta) {
                  final style = AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium);
                  return SideTitleWidget(child: Text(d[value.toInt()] + "일", style: style), axisSide: meta.axisSide);
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          // 터치시 툴팁 표시
          showingTooltipIndicators: showingTooltipSpot != -1 ? [ShowingTooltipIndicators([
            LineBarSpot(_lineBarsData[0], showingTooltipSpot,
                _lineBarsData[0].spots[showingTooltipSpot]),
          ])] : [],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppColor_Primary,
              tooltipRoundedRadius: 20.0,
              fitInsideHorizontally: true,
              tooltipMargin: 0,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map(
                      (LineBarSpot touchedSpot) {
                    const textStyle = TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    );
                    return LineTooltipItem(
                      touchedSpot.y.toStringAsFixed(2),
                      textStyle,
                    );
                  },
                ).toList();
              },
            ),
            handleBuiltInTouches: false,
            touchCallback: (event, response) {
              if (response?.lineBarSpots != null && event is FlTapUpEvent) {
                setState(() {
                  final spotIndex = response?.lineBarSpots?[0].spotIndex ?? -1;
                  if(spotIndex == showingTooltipSpot) {
                    showingTooltipSpot = -1;
                  }
                  else {
                    showingTooltipSpot = spotIndex;
                  }
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget defaultData(List<PricePoint> points) {
    final _lineBarsData = [
      LineChartBarData(
          spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
          isCurved: false,
          dotData: FlDotData(
            show: false,
          ),
          color: AppColor_Oxygen
      ),
    ];
    return AspectRatio(
      aspectRatio: 6,
      child: LineChart(
        LineChartData(
          minY: 34,
          maxY: 42,
          minX: 0,
          lineBarsData: _lineBarsData,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.5,
                getTitlesWidget: (value, meta) {
                  var style = AppTextStyle.PD(const Color(0xff585859), 11, weight: FW.medium);
                  // String title = sprintf("%.0f", [value]);
                  String title = value.toString();
                  if(title != "36.5") {
                    style = AppTextStyle.PD(
                        Colors.transparent, 11, weight: FW.medium);
                    return SideTitleWidget(child: Text(title, style: style), axisSide: meta.axisSide);
                  }

                  return SideTitleWidget(child: Text(title, style: style), axisSide: meta.axisSide);
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                //interval: ((maxY - minY) / 4) == 0 ? 1 : ((maxY - minY) / 4).ceil().toDouble(),
                interval:  1,
                getTitlesWidget: (value, meta) {
                  final style = AppTextStyle.PD(Colors.transparent, 11, weight: FW.medium);
                  return SideTitleWidget(child: Text(d[value.toInt()] + "일", style: style), axisSide: meta.axisSide);
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: false,
            touchCallback: (event, response) {
              if (response?.lineBarSpots != null && event is FlTapUpEvent) {
                setState(() {
                  final spotIndex = response?.lineBarSpots?[0].spotIndex ?? -1;
                  if(spotIndex == showingTooltipSpot) {
                    showingTooltipSpot = -1;
                  } else {
                    showingTooltipSpot = spotIndex;
                  }
                });
              }
            },
          ),

        ),
      ),
    );
  }
}