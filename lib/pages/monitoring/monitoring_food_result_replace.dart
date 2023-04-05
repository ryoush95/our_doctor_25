import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/radar_chart.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_habit.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test2.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonitoringFoodResultReplace extends StatefulWidget {
  final int months;
  final int dif;
  const MonitoringFoodResultReplace({Key? key, required this.months , required this.dif}) : super(key: key);

  @override
  State<MonitoringFoodResultReplace> createState() => _MonitoringFoodResultReplaceState();
}

class _MonitoringFoodResultReplaceState extends State<MonitoringFoodResultReplace> {

  int cateIndex = 2;

  int graphIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }


  Widget monitor1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30),
            child: H18(
              text: "일일 수유량 계산기",
              align: TextAlign.start,
            ),
          ),
          CachedNetworkImage(
            imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          CachedNetworkImage(
            imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          CachedNetworkImage(
            imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          CachedNetworkImage(
            imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",

            fit: BoxFit.contain,
          ),
          CachedNetworkImage(
            imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          CachedNetworkImage(
            imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),

          // explain(),
        ],
      ),
    );
  }
  Widget monitor2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H18(
                  text: "우리 아이",
                  align: TextAlign.start,
                ),
                H18(
                  text: "이유식 시작해도 될까?",
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",

              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",

              fit: BoxFit.contain,
            ),
          ),

          // explain(),
        ],
      ),
    );
  }
  Widget monitor3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",

              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",

              fit: BoxFit.contain,
            ),
          ),

          // explain(),
        ],
      ),
    );
  }


  Widget monitor31() {
    print(gUserInfo!.accessToken!);
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              CachedNetworkImage(
                imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              H18(
                text: "미션을 수행하며\n건강한 식습관을 가져보세요!",maxLine: 2,
              ),
              Divider(),
              MainTextButton(
                text: "다시 점검하기",
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                width: 185,
                height: 40,
                radius: 6,
                onPressed: () {
                  Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringFoodTest2(),));
                },
              ),
            ],
          ),
          MonitoringFoodHabit(),
        ],
      ),
    );
  }

  Widget _body() {
    if (widget.months <= 5) {
      return monitor1();
    } else if (widget.months == 6) {
      return monitor2();
    } else {
      return monitor3();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      onBack: onBackPressed,
      child: Column(
        children: [
          SimpleHeader(title:"영양모니터링",onBackPressed: onBackPressed,),

          Expanded(
            child: _body(),
          ),
        ],
      ),
    );
  }



}
