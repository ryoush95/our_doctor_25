import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/product/test4_quiz_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test.dart';

class MonitoringFoodTest2 extends StatefulWidget {
  const MonitoringFoodTest2({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodTest2> createState() => _MonitoringFoodTest2State();
}

class _MonitoringFoodTest2State extends BaseState<MonitoringFoodTest2> {
  final HttpService httpService = HttpService();
  List<Test4QuizDto> list = [];
  int quizNum = 0;
  int pageNum = 0;
  int nowNum = 0;
  List<Test4QuizDto> quizList = [];
  List<String> quizResult = [];
  final itemCount = 5;
  bool lastPage = false;
  late ScrollController _listController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listController = ScrollController();
    final jsonString =
      """[
      {
        "id": "1",
        "quiz_id": "43",
        "main_type": "통제",
        "quiz_image": null,
        "page": "1",
        "result": null,
        "quiz": "아이가 자기 물건이나 공간을 정리하지않으면 다른 일을 할 수 없도록 교육한다."
      },
      {
        "id": "2",
        "quiz_id": "43",
        "main_type": "애정",
        "quiz_image": null,
        "page": "1",
        "result": null,
        "quiz": "아이가 부르거나 찾으면 하던 일이 있더라도 즉각적인 반응을 해주는 편이다."
      }
    ]""";
    List<Test4QuizDto> testquiz = (json.decode(jsonString) as List).map((item) => Test4QuizDto.fromJson(item)).toList();
    list = testquiz;
    goNext();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  bool checkValid() {
    // print(list
    //     .sublist(pageNum * 5, )
    //     .where((element) => element.answer == "-1")
    //     .toList());
    if (quizList
        .sublist(0, quizList.length)
        .where((element) => element.answer == "-1")
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  void goNext() {
    quizList.clear();
    pageNum++;
    for (int i = nowNum; i < nowNum + itemCount; i++) {
      if(list.length == i) {
        lastPage = true;
        break;
      }
      quizList.add(list[i]);
    }
    nowNum = nowNum + itemCount;
    // for (var i in list) {
    //   if (i.page == pageNum.toString()) {
    //     quizList.add(i);
    //   }
    // }
    setState(() {});
  }

  Future<void> getResult() async {
    quizResult = list.map((e) => e.answer).toList();
    String r = jsonEncode(quizResult);
    Navigator
        .of(context)
        .pushReplacement(
        SlideRightTransRoute(
            builder: (context) => MonitoringFoodTest()));
    // Future<TestQuizResultModel> info = httpService.getTestQuizResult(widget.info.id!, r);
    // info.then((value) async {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   if (value.result == 0) {
    //     Navigator.of(context).pushReplacement(
    //       SlideRightTransRoute(
    //           builder: (context) => InspectionTest4FinalPage(
    //               info: widget.info, result: value.data!)),
    //     );
    //     quizNum = 0;
    //     quizResult.clear();
    //     setState(() {});
    //   }
    // }).catchError((onError) {
    //   print(onError.toString());
    // });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    int numId = index + ((pageNum - 1) * itemCount);
    return Container(
      height: 400,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Q${numId + 1}\n\n",
                style: AppTextStyle.PD(AppColor_Table_DateTime, 18,
                    weight: FW.bold),
              ),
              TextSpan(
                text: quizList[index].quiz!,
                style: AppTextStyle.PD(AppColor_BlackText, 17,
                    weight: FW.regular, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        checkbox(index, numId),
        const SizedBox(height: 30)
      ]),
    );
  }

  Widget checkbox(int index, int numId) {
    return Column(
      children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width - 64,
          child: ListView.builder(
            // scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, check) =>  Container(
              height: 50,
              width: (MediaQuery.of(context).size.width - 64) / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        list[numId].answer = "$check";
                        quizList[index].answer = "$check";
                      });
                    },
                    child: Image.asset(
                      quizList[index].answer == "$check"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(width: 10),
                  H16(text: "$check"),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        child: Column(children: [
      SimpleHeader(
        title: "영양모니터링",
        onBackPressed: onBackPressed,
      ),
          Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
                controller: _listController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "식습관\n",
                              style: AppTextStyle.PD(AppColor_Primary, 24,
                                  weight: FW.bold),
                            ),
                            TextSpan(
                              text: "체크리스트\n\n",
                              style: AppTextStyle.PD(AppColor_BlackText, 24,
                                  weight: FW.bold),
                            ),
                            TextSpan(
                              text: "$pageNum / ${(list.length / itemCount).round()}",
                              style: AppTextStyle.PD(
                                  AppColor_Table_DateTime, 15,
                                  weight: FW.regular),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 30),
                    Container(
                      height: quizList.length * 400,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quizList.length,
                        itemBuilder: _itemBuilder,
                      ),
                    ),
                  Container(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColor_Gray,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            H12(
                              text: "자료 출처",
                              color: AppColor_Gray,
                              align: TextAlign.start,
                            ),
                            H12(
                              text:
                              "\n김혜영. 어린이, 노인 등 맞춤 건강 식생활 정보 개발 및 활용 연구.\n\n식품의약안전처 연구용역보고서, 2021년",
                              color: AppColor_Gray,
                              align: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MainTextButton(
                      text: lastPage ? "결과보기" : "다음",
                      backgroundColor: AppColor_Primary,
                      style: AppTextStyle.PD(Colors.white, 18, weight: FW.medium),
                      width: double.infinity,
                      height: 60,
                      radius: 10,
                      disable: !checkValid(),
                      disableBackground:
                      !checkValid() ? AppColor_Primary_Disable : Colors.transparent,
                      onPressed: () {
                        if (!checkValid()) {
                          showToast("모든 문항에 체크해주세요");
                          return;
                        }
                        if (lastPage) {
                          getResult();
                          return;
                        }
                        goNext();
                        _listController.jumpTo(0.0);
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
    ]),
    );
  }
}
