import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';

/// 레이더 차트 위젯을 생성하는 클래스
class RadarChartWidget extends StatefulWidget {
  @override
  State<RadarChartWidget> createState() => _RadarChartWidgetState();
}

class _RadarChartWidgetState extends State<RadarChartWidget> {
  final List<List<double>> data = [
    [10.0, 20, 28, 5, 16, 15, 17, 6],
    [14.5, 1, 4, 14, 23, 10, 6, 19],
    [37.5, 5, 4, 14, 23, 10, 6, 20],
    [50, 50, 50, 50, 50, 50, 50, 50]
  ];

  List<List<RadarEntry>> dataa = [];
  List<RadarDataSet> radarData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataa = data.map((list) {
      return [
        for (int i = 0; i < 5; i++) RadarEntry(value: list[i]) // RadarEntry로 변환
      ];
    }).toList();

    for(int i = 0; i < dataa.length; i++) {
        radarData.add(RadarDataSet(
          dataEntries: dataa[i],
          fillColor: dataa.length - 1 == i ? colors[i] : colors[i].withOpacity(0.5),
          borderColor: colors[i],
          borderWidth: 1,
        ));
    }
  }

  // 레이더 차트의 각 항목 이름
  final List<String> titles = [
    '항목1',
    '항목2',
    '항목3',
    '항목4',
    '항목5'
    // '항목6',
    // '항목7',
    // '항목8',
  ];

  int touchedIndex = -1;

  // 레이더 차트의 최대값
  double maxValue = 40;

  // 레이더 차트의 각 항목 색상
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.transparent,
  ];

  // 레이더 차트의 각 항목에 대한 데이터를 반환하는 함수
  List<FlSpot> getData(int index) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data[index].length; i++) {
      spots.add(FlSpot(i.toDouble(), data[index][i]));
    }
    return spots;
  }

  Widget radar1() {
    return RadarChart(
      RadarChartData(
        // maxX: 50,
        // 레이더 차트의 각 항목 이름 설정
        radarTouchData: RadarTouchData(
          enabled: true,
          touchCallback:
              (FlTouchEvent event, RadarTouchResponse? response) {
            if (response != null &&
                response.touchedSpot != null &&
                event is FlTapUpEvent) {
              print(response.touchedSpot!.touchedDataSetIndex);
              print(response.touchedSpot!.touchedRadarEntryIndex);
              setState(() {
                touchedIndex =
                    response.touchedSpot!.touchedRadarEntryIndex;
              });
            } else {
              setState(() {
                touchedIndex = -1;
              });
            }
          },
        ),
        getTitle: (index, angle) {
          return RadarChartTitle(text: titles[index]);
        },
        titleTextStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        borderData: FlBorderData(
          show: true,
        ),
        radarBackgroundColor: Colors.white,
        radarBorderData: const BorderSide(
          color: Colors.grey, // style: BorderStyle
          width: 1,
        ),
        radarShape: RadarShape.polygon,
        tickBorderData: const BorderSide(
          color: Colors.grey,
        ),
        ticksTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        tickCount: 3,
        // 레이더 차트의 각 항목 색상 설정
        dataSets: radarData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final List<double> data = [0.5, 0.8, 0.6, 0.9, 0.4];
    return Column(
      children: [
        Text(touchedIndex.toString()),
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: radar1()
            // CustomPaint(
            //   painter: RadarChartPainter(data),
            //   size: Size(300,300),
            // )
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 64,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: AppColor_Light_Gray),
          padding: const EdgeInsets.only(
              left: 30, right: 30, top: 20, bottom: 20),
          // margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H16(text: "title"),
              const SizedBox(
                height: 10,
              ),
              H14(
                text: "contentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontent",
                maxLine: 10,
                height: 1.5,
                align: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class RadarChartPainter extends CustomPainter {
  final List<double> data;

  RadarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = <Offset>[];
    for (var i = 0; i < 5; i++) {
      final angle = 2 * pi / 5 * i - pi / 2;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      points.add(Offset(x, y));
    }

    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);

    paint.color = Colors.blueAccent.withOpacity(0.5);

    final dataPoints = <Offset>[];
    for (var i = 0; i < 5; i++) {
      final angle = 2 * pi / 5 * i - pi / 2;
      final value = data[i];
      final x = centerX + radius * cos(angle) * value;
      final y = centerY + radius * sin(angle) * value;
      dataPoints.add(Offset(x, y));
    }

    final dataPath = Path()..addPolygon(dataPoints, true);
    canvas.drawPath(dataPath, paint);
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) => false;
}