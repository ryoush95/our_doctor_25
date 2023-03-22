import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/product/test4_quiz_model.dart';
import 'package:ourdoctor/models/product/test_quiz_result_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'inspection_test4_final.dart';

class InspectionTest4AnswerPage extends StatefulWidget {
  final List<Test4QuizDto> listData;
  final ProductDetailDto info;

  InspectionTest4AnswerPage(
      {Key? key,
      required this.listData,
      required this.info})
      : super(key: key);

  @override
  InspectionTest4AnswerPageState createState() =>
      InspectionTest4AnswerPageState();
}

class InspectionTest4AnswerPageState
    extends BaseState<InspectionTest4AnswerPage> {
  final HttpService httpService = HttpService();
  late ScrollController _listController;
  List<Test4QuizDto> list = [];
  int quizNum = 0;
  int pageNum = 0;
  int nowNum = 0;
  final itemCount = 5;
  bool lastPage = false;
  List<Test4QuizDto> quizList = [];
  List<String> quizResult = [];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    list = widget.listData;
    goNext();
    setState(() {});
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    endAlert();

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  void selectQuiz(String s) {
    list[quizNum].answer = s;
    quizResult.add(s);

    if (quizNum < list.length - 1) {
      setState(() {
        quizNum++;
        Future.delayed(const Duration(milliseconds: 200));
      });
    } else {
      String r = '0';
      if (quizResult.indexOf('0') < quizResult.indexOf('1')) {
        r = '1';
      }

      // Navigator.of(context).pushReplacement(SlideRightTransRoute(builder: (context) =>
      //     InspectionTest2FinalPage(list: widget.listData, testName : widget.testName, result: r)),);
      quizNum = 0;
      quizResult.clear();
    }
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

/*  void backQuiz() {
    if (quizNum > 0) {
      setState(() {
        quizResult.removeLast();
        quizNum--;
      });
    } else {
      endAlert();
    }
  }*/

  void endAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('검사 중단'),
        titleTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.semi_bold),
        content: const Text('검사를 중단하시겠습니까?\n차감된 포인트는 환급되지 않습니다.'),
        contentTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.regular),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              return;
            },
            child: const Text('네'),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    int numId = index + ((pageNum - 1) * itemCount);
    return Container(
      height: 300,
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
        Row(
          children: [
            quizList[index].answer == "0" || quizList[index].answer == "1"
                ? Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor_Primary,
                      border: Border.all(color: AppColor_Primary),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 3),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.asset(
                                "assets/check_icon.png",
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: H16(
                              text: LanguageService.trans("아니다"),
                              weight: FW.medium,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ))
                : Container(
                    width: 80,
                    height: 30,
                    child: H16(
                      text: LanguageService.trans("아니다"),
                      weight: FW.medium,
                      color: AppColor_BlackText,
                    ),
                  ),
          ],
        ),
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    list[numId].answer = "0";
                    quizList[index].answer = "0";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      quizList[index].answer == "0"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    quizList[index].answer = "1";
                    list[numId].answer = "1";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      quizList[index].answer == "1"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    list[numId].answer = "2";
                    quizList[index].answer = "2";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      quizList[index].answer == "2"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    list[numId].answer = "3";
                    quizList[index].answer = "3";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      quizList[index].answer == "3"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            quizList[index].answer == "2" || quizList[index].answer == "3"
                ? Container(
                    alignment: Alignment.bottomLeft,
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor_Primary,
                      border: Border.all(color: AppColor_Primary),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 3),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.asset(
                                "assets/check_icon.png",
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: H16(
                              text: LanguageService.trans("그렇다"),
                              weight: FW.medium,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ))
                : Container(
                    width: 80,
                    height: 30,
                    child: H16(
                      text: LanguageService.trans("그렇다"),
                      weight: FW.medium,
                      color: AppColor_BlackText,
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Future<void> getResult() async {
    quizResult = list.map((e) => e.answer).toList();
    String r = jsonEncode(quizResult);
    Future<TestQuizResultModel> info = httpService.getTestQuizResult(widget.info.id!, r);
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.of(context).pushReplacement(
          SlideRightTransRoute(
              builder: (context) => InspectionTest4FinalPage(
                  info: widget.info, result: value.data!)),
        );
        quizNum = 0;
        quizResult.clear();
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: widget.info.name!,
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _listController,
                child: Container(
                  padding: EdgeInsets.all(30),
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
                                text: "${widget.info.description!}\n\n\n",
                                style: AppTextStyle.PD(AppColor_BlackText, 18,
                                    weight: FW.regular),
                              ),
                              TextSpan(
                                text: "다음 질문에 응답해 주세요.\n\n\n",
                                style: AppTextStyle.PD(AppColor_BlackText, 19,
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
                        height: quizList.length * 300,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: quizList.length,
                          itemBuilder: _itemBuilder,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MainTextButton(
              text: lastPage ? "결과보기" : "다음",
              backgroundColor: AppColor_Primary,
              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
              radius: 0,
              height: 66,
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
          ],
        ));
  }
}
