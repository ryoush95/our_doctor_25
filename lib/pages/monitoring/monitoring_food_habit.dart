import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/food_habits_result_model.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';

import 'monitoring_food_test1.dart';
import 'monitoring_food_test2.dart';

class MonitoringFoodHabit extends StatefulWidget {
  const MonitoringFoodHabit({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodHabit> createState() => _MonitoringFoodHabitState();
}

class _MonitoringFoodHabitState extends State<MonitoringFoodHabit> {
  HttpService httpService = HttpService();
  bool isLoading = false;
  List<FoodHabitModelDto> foodHabit = [
    FoodHabitModelDto(title: '건강하고 잘 먹고 있네요', content: '채소류를 더 먹어주세요'),
    FoodHabitModelDto(title: '건강하고 잘 먹고 있네요', content: '채소류를 더 먹어주세요'),
    FoodHabitModelDto(title: '건강하고 잘 먹고 있네요', content: '채소류를 더 먹어주세요'),
  ]; //식습관 결과
  List<String> missionResults = []; //미션

  @override
  void initState() {
    getFoodHabitResult();
    super.initState();
  }

  Future<void> getFoodHabitResult() async {
    Future<FoodHabitModel> info = httpService.getFoodHabitResults();

    info.then((FoodHabitModel value) {
      if (value.data != null) {
        for (int i = 1; i < value.data!.missions!.length; i++) {
          missionResults.add(value.data!.missions!['$i']['text']);
        }
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  _dotIndicator(index) {
    // List _items = [mData.mainImage!, mData.mainImage!];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DotsIndicator(
        // dotsCount: bannerList.length,
        dotsCount: 2,
        position: index,
        decorator: DotsDecorator(
          color: const Color(0xFF000000).withOpacity(0.12), // Inactive color
          activeColor: AppColor_Primary,
        ),
      ),
    );
  }

  Widget pageItem(index, habit) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/food_habit_icon_$index.png",
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: H16(
                      text: habit.title,
                      height: 1.3,
                      maxLine: 2,
                      align: TextAlign.start,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: H14(
                      weight: FW.regular,
                      color: AppColor_707071,
                      height: 1.3,
                      text: habit.content,
                      maxLine: 99,
                      align: TextAlign.start,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget page1Item(index) {
    return SizedBox(
      height: 90,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H16(
                    text: "Mission ${index + 1}",
                    color: AppColor_Primary,
                    weight: FW.medium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      H14(
                        text: "${missionResults[index]}",
                        height: 1.3,
                        weight: FW.bold,
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Image.asset(
                "assets/food_mission_icon_${index + 1}.png",
                height: 70,
                width: 70,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget page() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            FutureBuilder(
              builder: (context, snapshot) => CachedNetworkImage(
                imageUrl:
                    "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: H18(
                text: "식습관 분석을 완료했어요!",
                maxLine: 2,
                color: AppColor_Primary,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                  color: AppColor_White,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor_Light_Gray,
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                    )
                  ]),
              child: Column(
                children: [
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foodHabit.length,
                    itemBuilder: (context, index) {
                      return pageItem(index, foodHabit[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 30);
                    },
                  ),
                ],
              ),
            ),
            _dotIndicator(0.0),
            const SizedBox(height: 20),
            MainTextButton(
              text: "다시 점검하기",
              style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
              width: 185,
              height: 40,
              radius: 6,
              onPressed: () {
                Navigator.push(
                    context,
                    SlideRightTransRoute(
                      builder: (context) => MonitoringFoodTest1(),
                    ));
              },
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget page1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            FutureBuilder(
              builder: (context, snapshot) => CachedNetworkImage(
                imageUrl:
                    "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  H18(
                    text: "미션을 수행하며",
                    maxLine: 2,
                  ),
                  const SizedBox(height: 8),
                  H18(
                    text: "건강한 식습관을 가져보세요!",
                    maxLine: 2,
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              height: 4 * 90,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: missionResults.length,
                itemBuilder: (context, index) {
                  return page1Item(index);
                },
              ),
            ),
            _dotIndicator(1.0),
            const SizedBox(
              height: 20,
            ),
            MainTextButton(
              text: "다시 점검하기",
              style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
              width: 185,
              height: 40,
              radius: 6,
              onPressed: () {
                Navigator.push(
                    context,
                    SlideRightTransRoute(
                      builder: (context) => MonitoringFoodTest2(),
                    ));
              },
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          page(),
          page1(),
        ],
      ),
    );
  }
}
