import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/monitoring/food_write_list.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';

final List<String> foodList = [ "고기, 생선, 달걀, 콩류", "과일류", "채소류", "유제품", "곡류"];
final List<Color> colorList = [
  Colors.amber,
  Colors.orange,
  AppColor_Oxygen,
  AppColor_Red,
  AppColor_Primary,
];

/// 레이더 차트 위젯을 생성하는 클래스
class RadarChartWidget extends StatefulWidget {
  RadarChartWidget({Key? key, this.state = false}) : super(key: key);
  bool? state;
  @override
  State<RadarChartWidget> createState() => _RadarChartWidgetState();
}

class _RadarChartWidgetState extends State<RadarChartWidget> {
  bool darkMode = false;
  bool useSides = false;
  double numberOfFeatures = 5;

  Offset position = const Offset(0, 0);
  final List<bool> isPointSelected = List.generate(5, (_) => false);
  double size = 200;
  double clickX = -1;
  double clickY = -1;
  int _graphIndex = -1;


  Widget explain() {
    final selIndex = context.watch<FoodResultProvider>().foodGraphIndex;
    return Column(
      children: [
        // H18(
        //   text: context.watch<FoodResultProvider>().foodGraphIndex.toString(),
        //   color: Colors.black,
        // ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: selIndex < 0 ? AppColor_Primary : colorList[selIndex]),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          // left: 10, right: 10, top: 20, bottom: 20),
          child: H18(
            text: selIndex < 0 ? "영양 총평" : foodList[selIndex],
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
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
        const SizedBox(height: 50),
      ],
    );
  }

  int caculator(Size size, clickX, clickY) {
    final radius = size.width / 2; // 반지름
    final centerX = size.width / 2; // 중심 x좌표
    final centerY = size.height / 2; // 중심 y좌표
    int sel = -1;

    for (var i = 0; i < 5; i++) {
      // 5개의 꼭지점 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 꼭지점의 각도
      final x = centerX + radius * cos(angle); // 꼭지점의 x좌표
      final y = centerY + radius * sin(angle); // 꼭지점의 y좌표
      double ss = 10;
      bool click = (clickX >= x - ss && clickX <= x + ss) &&
          (clickY >= y - ss && clickY <= y + ss);

      sel = sel != -1 ? sel : click ? i : -1;
    }
    return sel;
  }


  @override
  Widget build(BuildContext context) {
    final List<double> data2 = [0.5, 0.8, 0.6, 0.9, 0.4];

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.pink.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              // left: 10, right: 10, top: 20, bottom: 20),
              child: H12(
                text:  "권장량",
                color: Colors.white,
                weight: FW.medium,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: AppColor_Primary.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              // left: 10, right: 10, top: 20, bottom: 20),
              child: H12(
                text:  gSelChildInfo!.name!,
                color: Colors.white,
                weight: FW.medium,
              ),
            ),
          ],
        ),
        Container(
            height: 400,
            width: 400,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: GestureDetector(
                onTapDown: (details) {
                  if (widget.state!) {
                      clickX = details.localPosition.dx;
                      clickY = details.localPosition.dy;
                      _graphIndex = caculator(Size(size,size), clickX, clickY);
                      Provider.of<FoodResultProvider>(context, listen: false).changeGraphIndex(_graphIndex);
                  }
                },
                child: CustomPaint(
                  painter: RadarChartPainter(
                    context,
                    data2,
                    clickX,
                    clickY,
                  ),
                  size: Size(size, size),
                ),
              ),
            ),
        ),
        Visibility(
          visible: widget.state!,
            child: Column(
              children: [
                explain(),
                Center(
                  child: MainTextButton(
                    text: "식단 기록하기",
                    style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                    width: 185,
                    height: 40,
                    radius: 6,
                    onPressed: () {
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => FoodWriteList()));
                    },
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }
}

// 레이더 차트를 그리는 CustomPainter 클래스
class RadarChartPainter extends CustomPainter {
  final context;
  final List<double> data; // 데이터 리스트
  double clickX;
  double clickY;

  RadarChartPainter(this.context, this.data, this.clickX, this.clickY); // 생성자

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2; // 반지름
    final centerX = size.width / 2; // 중심 x좌표
    final centerY = size.height / 2; // 중심 y좌표

    final paint = Paint()
      ..color = Color(0xFFCECECE) // 회색
      ..style = PaintingStyle.stroke // 선 스타일
      ..strokeWidth = 1; // 선 두께

    final fillPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1) // 파란색, 투명도 30%
      ..style = PaintingStyle.fill; // 채우기 스타일

    final points = <Offset>[]; // 꼭지점 좌표 리스트
    for (var i = 0; i < 5; i++) {
      // 5개의 꼭지점 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 꼭지점의 각도
      final x = centerX + radius * cos(angle); // 꼭지점의 x좌표
      final y = centerY + radius * sin(angle); // 꼭지점의 y좌표
      points.add(Offset(x, y)); // 꼭지점 좌표 리스트에 추가
    }

    final path = Path()..addPolygon(points, true); // 다각형 경로 생성
    canvas.drawPath(path, fillPaint); // 다각형 내부를 채우는 패스 그리기
    // canvas.drawPath(path, paint); // 다각형 테두리 그리기

    paint.color = Colors.grey.withOpacity(0.8); // 회색 반투명

    for (var i = 0; i < 5; i++) {
      // 중심부터 꼭지점까지 선 그리기
      final angle = 2 * pi / 5 * i - pi / 2; // 선의 각도
      final x = centerX + radius * cos(angle); // 선의 x좌표
      final y = centerY + radius * sin(angle); // 선의 y좌표
      canvas.drawLine(Offset(centerX, centerY), Offset(x, y), paint);
    }

    int sel = -1;

    for (var i = 0; i < 5; i++) {
      // 5개의 꼭지점 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 꼭지점의 각도
      final x = centerX + radius * cos(angle); // 꼭지점의 x좌표
      final y = centerY + radius * sin(angle); // 꼭지점의 y좌표
      double ss = 10;
      bool click = (clickX >= x - ss && clickX <= x + ss) &&
          (clickY >= y - ss && clickY <= y + ss);

      sel = sel != -1 ? sel : click ? i : -1;

      points.add(Offset(x, y)); // 꼭지점 좌표 리스트에 추가
      canvas.drawCircle(
          Offset(x, y),
          9, // 꼭지점에 그리는 점의 크기를 9으로 변경
          Paint()
            ..color = colorList[i]
            ..strokeWidth = 2
            ..style = PaintingStyle.fill); // 꼭지점에 클릭 가능한 점 그리기
      // 꼭지점 주변에 12시부터 시계방향으로 foodList의 텍스트를 넣어줌
      final textPainter = TextPainter(
        text: TextSpan(
          text: foodList[i],
          style: TextStyle(
            color: Colors.white,
            fontSize: click ? 14 : 12,
            background: Paint()
              ..strokeWidth = click ? 24.0 : 20.0
              ..color = click ? colorList[i] : Colors.grey
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      final textX = centerX + radius * cos(angle) * 1.5 - textPainter.width / 2;
      final textY =
          centerY + radius * sin(angle) * 1.5 - textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    }

    paint.color = Colors.pink.withOpacity(0.5); // 파란색 반투명
    fillPaint.color = Colors.pink.withOpacity(0.3);
    final dataPoints = <Offset>[]; // 데이터 좌표 리스트
    for (var i = 0; i < 5; i++) {
      // 5개의 데이터 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 데이터의 각도
      final value = data[i]; // 데이터 값
      final x = centerX + radius * cos(angle) * value; // 데이터의 x좌표
      final y = centerY + radius * sin(angle) * value; // 데이터의 y좌표
      dataPoints.add(Offset(x, y)); // 데이터 좌표 리스트에 추가
    }

    final dataPath = Path()..addPolygon(dataPoints, true); // 데이터 다각형 경로 생성
    canvas.drawPath(dataPath, fillPaint); // 데이터 다각형 그리기
    canvas.drawPath(dataPath, paint); // 데이터 다각형 그리기

    paint.color = Colors.blueAccent.withOpacity(0.5); // 파란색 반투명
    fillPaint.color = Colors.blueAccent.withOpacity(0.5);
    final dataPoints1 = <Offset>[]; // 데이터 좌표 리스트
    final List<double> data2 = data.reversed.toList();
    for (var i = 0; i < 5; i++) {
      // 5개의 데이터 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 데이터의 각도
      final value = data2[i]; // 데이터 값
      final x = centerX + radius * cos(angle) * value; // 데이터의 x좌표
      final y = centerY + radius * sin(angle) * value; // 데이터의 y좌표
      dataPoints1.add(Offset(x, y)); // 데이터 좌표 리스트에 추가
    }

    final dataPath1 = Path()..addPolygon(dataPoints1, true); // 데이터 다각형 경로 생성
    canvas.drawPath(dataPath1, fillPaint); // 데이터 다각형 그리기
    canvas.drawPath(dataPath1, paint); // 데이터 다각형 그리기
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) => true; // 다시 그릴 필요 없음
}
