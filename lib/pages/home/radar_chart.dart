import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/food_radarchart_model.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/food_write_list.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';

final List<String> foodList = ["고기, 생선, 달걀, 콩류", "과일", "채소", "유제품", "곡류"];
final List<Color> colorList = [
  Colors.amber,
  Colors.orange,
  AppColor_Oxygen,
  AppColor_Red,
  AppColor_Primary,
];

/// 레이더 차트 위젯을 생성하는 클래스
class RadarChartWidget extends StatefulWidget {
  RadarChartWidget({Key? key, this.state = false, required this.date})
      : super(key: key);
  bool? state;
  String? date;
  @override
  State<RadarChartWidget> createState() => _RadarChartWidgetState();
}

class _RadarChartWidgetState extends State<RadarChartWidget> {
  final HttpService httpService = HttpService();
  ChartData? foodData;
  List<double> main = [0, 0, 0, 0, 0];
  List<double> average = [0, 0, 0, 0, 0];
  List<Comment?> commentList = [null, null, null, null, null];

  double clickX = 50;
  double clickY = 50;

  PageController bannerController = PageController();
  double bannerNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChartData();
    Provider.of<FoodResultProvider>(context, listen: false)
        .changeGraphIndex2(-1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bannerController.dispose();
  }

  Future<void> getChartData() async {
    final p = Provider.of<FoodResultProvider>(context, listen: false);
    Future<FoodRadarchartModel> info =
    httpService.getFoodRadarChart(widget.date);
    await info.then((FoodRadarchartModel value) async {
      if (value.result == 0) {
        p.setDataProvider(value.data!);
        foodData = p.foodData;
        for (int i = 0; i < foodData!.graph!.length; i++) {
          main[i] = value.data!.graph![foodList[i]]!.data;
          average[i] = value.data!.graph![foodList[i]]!.average;
          commentList[i] = foodData!.graph![foodList[i]]!.comment!;
        }
        // p.changeSelDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Widget banner() {
    final selIndex = context.watch<FoodResultProvider>().foodGraphIndex;
    return PageView.builder(
      controller: bannerController,
      itemCount: foodList.length,
      itemBuilder: (context, index) =>
          buildBannerItem(context, index, selIndex),
      onPageChanged: (i) {
        setState(() {
          bannerNum = i.toDouble();
          Provider.of<FoodResultProvider>(context, listen: false)
              .changeGraphIndex(i);
        });
      },
    );
  }

  Widget buildBannerItem(BuildContext context, int index, int selIndex) {
    Comment? com = commentList[index];
    return Container(
      width: MediaQuery.of(context).size.width - 64,
      height: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: AppColor_Light_Gray),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          com!.content.isEmpty
              ? H16(text: "아직 기록이 없어요.")
              : H16(
              text: selIndex == -1 ? foodData!.comment!.title : com.title),
          const SizedBox(
            height: 10,
          ),
          com.content.isEmpty
              ? H14(
            text: "기록이 필요해요 :)",
            maxLine: 2,
            align: TextAlign.start,
            color: const Color(0xff707071),
            weight: FW.medium,
          )
              : H14(
            text:
            selIndex == -1 ? foodData!.comment!.content : com.content,
            maxLine: 10,
            height: 1.3,
            align: TextAlign.start,
            color: const Color(0xff707071),
            weight: FW.medium,
          ),
        ],
      ),
    );
  }

  _dotIndicator() {
    // List _items = [mData.mainImage!, mData.mainImage!];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DotsIndicator(
        dotsCount: 5,
        position: bannerNum,
        decorator: DotsDecorator(
          color: const Color(0xFF000000).withOpacity(0.12), // Inactive color
          activeColor: AppColor_Primary,
        ),
      ),
    );
  }

  Widget explain() {
    final selIndex = context.watch<FoodResultProvider>().foodGraphIndex;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: selIndex < 0 ? AppColor_Primary : colorList[selIndex]),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // left: 10, right: 10, top: 20, bottom: 20),
          child: H18(
            text: selIndex < 0 ? "영양 총평" : foodList[selIndex],
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        // bannerList.isNotEmpty ? CareBanner() : const Center(child: CircularProgressIndicator()),
        SizedBox(height: 180, child: banner()),
        SizedBox(
          height: 50,
          child: Column(
            children: [
              foodList.isNotEmpty
                  ? Center(child: _dotIndicator())
                  : Container(),
            ],
          ),
        ),
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

      sel = sel != -1
          ? sel
          : click
          ? i
          : -1;
    }
    return sel;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - 200;

    return Container(
      padding:
      widget.state! ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          foodData == null
              ? const SizedBox()
              : H18(
            text: !widget.state! ? foodData!.title! : widget.date!,
            align: TextAlign.start,
            maxLine: 3,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: Colors.pink.withOpacity(0.3)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    // left: 10, right: 10, top: 20, bottom: 20),
                    child: H12(
                      text: "권장량",
                      color: Colors.white,
                      weight: FW.medium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: AppColor_Primary.withOpacity(0.3)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    // left: 10, right: 10, top: 20, bottom: 20),
                    child: H12(
                      text: gSelChildInfo!.name!,
                      color: Colors.white,
                      weight: FW.medium,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container( height:1.0,
                            width:40.0,
                            color:Colors.black.withOpacity(0.4)),
                        SizedBox(width: 15,),
                        H12(
                          text: "과다 섭취 기준선",
                          color: AppColor_GrayText,
                          weight: FW.medium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container( height:1.0,
                          width:40.0,
                          color:AppColor_Red,),
                        SizedBox(width: 15,),
                        H12(
                          text: "부족 섭취 기준선",
                          color: AppColor_GrayText,
                          weight: FW.medium,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),

          Container(
            height: size + 200,
            width: size + 200,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: GestureDetector(
                onTapDown: (details) {
                  if (widget.state!) {
                    clickX = details.localPosition.dx;
                    clickY = details.localPosition.dy;
                    int cacul = caculator(Size(size, size), clickX, clickY);
                    bannerController.jumpToPage(cacul);
                    Provider.of<FoodResultProvider>(context, listen: false)
                        .changeGraphIndex(cacul);
                  }
                },
                child: CustomPaint(
                  painter: widget.state!
                      ? RadarChartPainter(
                    context,
                    main,
                    average,
                    clickX,
                    clickY,
                  )
                      : RadarChartPainter(
                    context,
                    main,
                    average,
                    -1,
                    -1,
                  ),
                  size: Size(size, size),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.state!,
            child: SizedBox(
              height: 450,
              child: Column(
                children: [
                  foodData == null
                      ? SizedBox(
                    height: 50,
                    child: H16(
                      text: "아직 기록된 식단이 없습니다.",
                      color: AppColor_BlackText,
                    ),
                  )
                      : explain(),
                  Center(
                    child: MainTextButton(
                      text: "식단 기록하기",
                      style:
                      AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                      width: 185,
                      height: 40,
                      radius: 6,
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          SlideRightTransRoute(
                              builder: (context) =>
                                  FoodWriteList(date: widget.date!)),
                        );

                        if (result) {
                          getChartData();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 레이더 차트를 그리는 CustomPainter 클래스
class RadarChartPainter extends CustomPainter {
  final context;
  final List<double> avg; // 데이터 리스트
  final List<double> main; // 데이터 리스트
  double clickX;
  double clickY;

  RadarChartPainter(
      this.context, this.avg, this.main, this.clickX, this.clickY); // 생성자

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
      ..color = const Color(0xFFF8F8F8)
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

    paint.color = const Color(0xFFE3E3E3); // 회색 반투명

    for (var i = 0; i < 5; i++) {
      // 중심부터 꼭지점까지 선 그리기
      final angle = 2 * pi / 5 * i - pi / 2; // 선의 각도
      final x = centerX + radius * cos(angle); // 선의 x좌표
      final y = centerY + radius * sin(angle); // 선의 y좌표
      canvas.drawLine(Offset(centerX, centerY), Offset(x, y), paint);
    }

    int graphNum =
        Provider.of<FoodResultProvider>(context, listen: false).foodGraphIndex;
    if (clickX == -1 && clickY == -1) {
      graphNum = -1;
    }
    for (var i = 0; i < 5; i++) {
      // 5개의 꼭지점 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 꼭지점의 각도
      final x = centerX + radius * cos(angle); // 꼭지점의 x좌표
      final y = centerY + radius * sin(angle); // 꼭지점의 y좌표

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
            color: graphNum == i ? Colors.white : Colors.grey,
            fontSize: graphNum == i ? 14 : 12,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      final textX = centerX + radius * cos(angle) * 1.5 - textPainter.width / 2;
      final textY =
          centerY + radius * sin(angle) * 1.4 - textPainter.height / 2;
      final backgroundPaint = Paint()
        ..color = graphNum == i
            ? colorList[i]
            : const Color(0xFFF8F8F8) // Set a custom background color
        ..style = PaintingStyle.fill; // Set the painting style to fill
      final backgroundRect = RRect.fromLTRBR(
        textX - 20 / 2,
        textY - 20 / 2,
        textX + textPainter.width + 20 / 2,
        textY + textPainter.height + 20 / 2,
        Radius.circular(radius),
      );
      canvas.drawRRect(
        backgroundRect,
        backgroundPaint,
      );
      textPainter.paint(canvas, Offset(textX, textY));
    }




    //과다 라인 그리기
    paint.color = Colors.black.withOpacity(0.4);
    final dataPoints4 = <Offset>[]; // 데이터 좌표 리스트
    for (var i = 0; i < 5; i++) {
      // 5개의 데이터 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 데이터의 각도
      final value = main[i]; // 데이터 값
      final x = centerX + radius * cos(angle) * (value*2); // 데이터의 x좌표
      final y = centerY + radius * sin(angle) * (value*2); // 데이터의 y좌표
      dataPoints4.add(Offset(x, y)); // 데이터 좌표 리스트에 추가
    }
    final dataPath4 = Path()..addPolygon(dataPoints4, true); // 데이터 다각형 경로 생성
    paint.strokeWidth = 0.5;
    canvas.drawPath(dataPath4, paint); // 다각형 테두리 그리기

    //권장량 그리기 -> 핑크색
    paint.color = Colors.pink.withOpacity(1); // 핑크 반투명 => 권장량
    fillPaint.color = Colors.pink.withOpacity(0.3);

    final dataPoints = <Offset>[]; // 데이터 좌표 리스트
    for (var i = 0; i < 5; i++) {
      // 5개의 데이터 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 데이터의 각도
      final value = main[i]; // 데이터 값
      final x = centerX + radius * cos(angle) * value; // 데이터의 x좌표
      final y = centerY + radius * sin(angle) * value; // 데이터의 y좌표
      dataPoints.add(Offset(x, y)); // 데이터 좌표 리스트에 추가
    }

    final dataPath = Path()..addPolygon(dataPoints, true); // 데이터 다각형 경로 생성
    canvas.drawPath(dataPath, fillPaint); // 데이터 다각형 그리기


    //부족 라인 그리기
    paint.color= AppColor_Red;
    final dataPoints3 = <Offset>[]; // 데이터 좌표 리스트
    for (var i = 0; i < 5; i++) {
      // 5개의 데이터 좌표 계산
      final angle = 2 * pi / 5 * i - pi / 2; // 데이터의 각도
      final value = main[i]; // 데이터 값
      final x = centerX + radius * cos(angle) * (value/2); // 데이터의 x좌표
      final y = centerY + radius * sin(angle) * (value/2); // 데이터의 y좌표
      dataPoints3.add(Offset(x, y)); // 데이터 좌표 리스트에 추가
    }
    final dataPath3 = Path()..addPolygon(dataPoints3, true); // 데이터 다각형 경로 생성
    paint.strokeWidth = 0.5;
    canvas.drawPath(dataPath3, paint); // 다각형 테두리 그리기

    //내아이 섭취량 그리기 -> 파란색
    paint.color = Colors.blueAccent.withOpacity(1); // 파란색 반투명
    fillPaint.color = Colors.blueAccent.withOpacity(0.5);

    final dataPoints1 = <Offset>[]; // 데이터 좌표 리스트
    final List<double> data2 = avg;
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




  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) => true; // 다시 그릴 필요 없음
}
