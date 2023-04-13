import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/monitoring/food_check_list2_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_result.dart';

class MonitoringFoodTest2 extends StatefulWidget {
  MonitoringFoodTest2({Key? key, required this.test1Data}) : super(key: key);

  List<String> test1Data;

  @override
  State<MonitoringFoodTest2> createState() => _MonitoringFoodTest2State();
}

class _MonitoringFoodTest2State extends BaseState<MonitoringFoodTest2> {
  final HttpService httpService = HttpService();
  List<bool> checkList = [];
  List<FoodCheck2> answerList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCheckList2();
  }

  Future<void> getCheckList2() async {
    Future<FoodCheckList2> info = httpService.getCheckList2();
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        answerList = value.data!.values.toList();
        checkList = List.generate(answerList.length, (_) => false);
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> saveCheckList() async {
    List<String> data = widget.test1Data;
    data.addAll(answerList.map((e) => e.answer));
    String result = jsonEncode(data);
    Future<DefaultResModel> insert = httpService.saveCheckList(result);
    insert.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MonitoringFoodResult(
              tab: 2,
            ),
          ),
        );
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.pushReplacement(
        context,
        SlideRightTransRoute(
          builder: (context) => MonitoringFoodResult(
            tab: 2,
          ),
        ));
    return true;
  }

  Widget foodHabitTestTile1(index) {
    return InkWell(
      onTap: () {
        setState(() {
          checkList[index] = !checkList[index];
          answerList[index].answer = checkList[index] ? "1" : "0";
        });
      },
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color:
                    checkList[index] ? AppColor_Primary : AppColor_Light_Gray),
            child: Icon(
              Icons.check_rounded,
              color: checkList[index] ? AppColor_White : Colors.grey,
              size: 50,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: checkList[index]
                      ? AppColor_Primary
                      : AppColor_Light_Gray),
              child: Center(
                  child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: H16(
                  text: answerList[index].question!,
                  color: checkList[index] ? AppColor_White : Colors.black,
                  maxLine: 2,
                  align: TextAlign.start,
                  weight: FW.medium,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        onBack: onBackPressed,
        child: Column(
          children: [
            SimpleHeader(
              title: "영양모니터링",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: H18(
                              text: "문제 행동",
                              color: AppColor_Primary,
                              align: TextAlign.start,
                            ),
                          ),
                          H18(
                            text: "체크리스트",
                            align: TextAlign.start,
                          ),
                          const SizedBox(height: 35),
                          SizedBox(
                            height: checkList.length * 100,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: checkList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  height: 100,
                                  child: foodHabitTestTile1(index),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 55),
                          MainTextButton(
                            text: "완료하기",
                            style: AppTextStyle.PD(Colors.white, 18,
                                weight: FW.medium),
                            width: double.infinity,
                            height: 60,
                            radius: 10,
                            onPressed: () {
                              saveCheckList();
                            },
                          ),
                          const SizedBox(height: 55),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
