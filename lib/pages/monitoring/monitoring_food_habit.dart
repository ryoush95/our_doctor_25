import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';

import 'monitoring_food_test2.dart';

class MonitoringFoodHabit extends StatefulWidget {
  const MonitoringFoodHabit({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodHabit> createState() => _MonitoringFoodHabitState();
}

class _MonitoringFoodHabitState extends State<MonitoringFoodHabit> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget pageItem(index) {
    List<String> aa = ["요어겠좋 면리늘 를취섭 류소채 ,만다", ".요해요필 이선개 식음취섭\n선해위 기하방예 을등염장위아소 ,병인성\n!요아않 지좋 에강건 은식음 인적극자","1aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n2\n3\n4"];
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
                      text: "건강하고 다양한 음식을 골고루 잘 먹고있네요.aaaaaaaaaaaaaaaa",
                      maxLine: 2,
                      align: TextAlign.start,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    child: H14(
                      text: aa[index],
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
                  H18(
                    text: "Mission 1",
                    color: AppColor_Primary,
                    weight: FW.medium,
                  ),
                  const SizedBox(height: 10,),
                  H18(text: "채소 1가지 이상 먹어보기")
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
            const SizedBox(height: 40,),
            FutureBuilder(
              builder: (context, snapshot) => CachedNetworkImage(
                imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: H24B(
                text: "식습관 분석을 완료했어요!",maxLine: 2,
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
              pageItem(0),
              const SizedBox(height: 50),
              pageItem(1),
              const SizedBox(height: 50),
              pageItem(2),
            ],
          ),
          // child: ListView.builder(itemBuilder: (context, index) {
          //   return pageItem(index);
          // },)
        ),
          const SizedBox(height: 20,),

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
            const SizedBox(height: 40,),
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
            const SizedBox(height: 40,),
            FutureBuilder(
              builder: (context, snapshot) => CachedNetworkImage(
                imageUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  H24B(
                    text: "미션을 수행하며",maxLine: 2,
                  ),
                  const SizedBox(height: 8),
                  H24B(
                    text: "건강한 식습관을 가져보세요!",maxLine: 2,
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              height: 4 * 90,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                return page1Item(index);
              },),
            ),
            const SizedBox(height: 20,),

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
            const SizedBox(height: 40,),
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
