import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/food_habits_result_model.dart';
import 'package:ourdoctor/models/monitoring/note_profile_model.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test2.dart';
import 'package:ourdoctor/provider/global_provider.dart';
import 'package:provider/provider.dart';
import 'monitoring_food_test1.dart';

class MonitoringFoodHabit extends StatefulWidget {
  const MonitoringFoodHabit({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodHabit> createState() => _MonitoringFoodHabitState();
}

class _MonitoringFoodHabitState extends State<MonitoringFoodHabit> {
  HttpService httpService = HttpService();
  bool isLoading = false;
  List<Comment> commentsList = []; //코멘트
  List<String> missionKeys = []; //미션키
  List<Mission> missionList = []; //미션
  MonitoringProfileDto? data;
  bool isChecked = false; //식습관 테스트 완료 comment O
  bool hasComments = false; //식습관 테스트 완료 comment X mission O
  int months = 0;

  @override
  void initState() {
    getFoodHabitResult();
    super.initState();
  }

  Future<void> getFoodHabitResult() async {
    final ageInfo = await httpService.getChildMonths();
    months = ageInfo["data"]["month"];
    Future<FoodHabitModel> info = httpService.getFoodHabitResults();
    info.then((FoodHabitModel value) {
      if (value.data!.comments!.isEmpty && value.data!.missions!.isNotEmpty) {
        setState(() {
          isChecked = true;
          hasComments = false;
          commentsList = value.data!.comments!.values.toList();
          missionKeys = value.data!.missions!.keys.toList();
          missionList = value.data!.missions!.values.toList();
        });
      } else if (value.data!.comments!.isNotEmpty &&
          value.data!.missions!.isNotEmpty) {
        setState(() {
          isChecked = true;
          hasComments = true;
        });
        commentsList = value.data!.comments!.values.toList();
        missionKeys = value.data!.missions!.keys.toList();
        missionList = value.data!.missions!.values.toList();
      } else {
        setState(() {
          isChecked = false;
          hasComments = false;
        });
      }
      setState(() {});
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

  Widget pageItem(index, Comment comment) {
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
                      text: comment.title!,
                      height: 1.3,
                      maxLine: 2,
                      align: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 130,
                    child: H14(
                      weight: FW.regular,
                      color: AppColor_707071,
                      height: 1.3,
                      text: comment.content!,
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
      height: 100,
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
                        text: missionList[index].text!,
                        height: 1.3,
                        weight: FW.bold,
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              missionList[index].imgUrl != null
                  ? CachedNetworkImage(
                      imageUrl: missionList[index].imgUrl!,
                      height: 70,
                      width: 70,
                    )
                  : const SizedBox(height: 70),
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
            Image.asset(
              "assets/food_habit_0.png",
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: H18(
                height: hasComments ? 1.0 : 1.3,
                weight: FW.bold,
                text: hasComments
                    ? "식습관 분석을 완료했어요!"
                    : "우리 아이의 냠냠 습관은 어떤가요?\n식습관과 문제행동을 체크해 보고,\n 더 건강한 냠냠습관을 가져 보세요.",
                maxLine: hasComments ? 2 : 3,
                color: hasComments ? AppColor_Primary : AppColor_BlackText,
              ),
            ),
            if (hasComments)
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
                      itemCount: commentsList.length,
                      itemBuilder: (context, i) {
                        return pageItem(i, commentsList[i]);
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return const SizedBox(height: 30);
                      },
                    ),
                  ],
                ),
              ),
            _dotIndicator(0.0),
            const SizedBox(height: 20),
            MainTextButton(
              text: isChecked ? "다시 점검하기" : "점검하기",
              style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
              width: 185,
              height: 40,
              radius: 6,
              onPressed: () {
                Navigator.pushReplacement(
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
            Image.asset(
              "assets/food_habit_1.png",
              width: 200,
              height: 200,
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
            if (isChecked)
              SizedBox(
                height: missionList.length * 100,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missionList.length,
                  itemBuilder: (context, index) {
                    return page1Item(index);
                  },
                ),
              ),
            months > 36 ? const SizedBox() : _dotIndicator(1.0),
            const SizedBox(
              height: 20,
            ),
            MainTextButton(
              text: isChecked ? "다시 점검하기" : "점검하기",
              style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
              width: 185,
              height: 40,
              radius: 6,
              onPressed: () {
                Navigator.pushReplacement(context, SlideRightTransRoute(
                  builder: (context) {
                    if (months > 36) {
                      return MonitoringFoodTest1();
                    } else {
                      return MonitoringFoodTest2(test1Data: const []);
                    }
                  },
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
          if (months > 36) ...[
            page(),
          ],
          page1(),
        ],
      ),
    );
  }
}
