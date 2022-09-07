import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/alarm/alarm.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';

class InspectionThirdPage extends StatefulWidget {
  final List<QuizDto> list;
  final List<int> additional_list;

  InspectionThirdPage({Key? key, required this.list, required this.additional_list}) : super(key: key);

  @override
  InspectionThirdPageState createState() => InspectionThirdPageState();
}

class InspectionThirdPageState extends BaseState<InspectionThirdPage> {
  int additionalIndex = 0; //추가 질문에서 index
  int selectedIndex = -1; //기본 20개리스트에서 index
  List<String> answers = [];
  bool repeat = false;
  bool repeat2 = false;

  List<dynamic> valueList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.list.length; i++) {
      valueList.add("");
    }
    loadAdditionalQuiz(additionalIndex);
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void loadAdditionalQuiz(int index) {
    setState(() {
      repeat = false;
      repeat2 = false;
      selectedIndex = widget.additional_list[index];
      answers.clear();
      answers.add(widget.list[selectedIndex].answer == 1 ? "Y" : "N");
      for (int i = 0; i < widget.list[selectedIndex].addtionalQuizs!.length; i++) {
        answers.add("");
      }
      if (scrollController.hasClients) {
        scrollController.animateTo(0, duration: const Duration(microseconds: 100), curve: Curves.linear);
      }
    });
  }

  void goNext() {
    if ((widget.list[selectedIndex].giveFlag == 'y' && widget.list[selectedIndex].answer == 1) ||
        (widget.list[selectedIndex].giveFlag == 'n' && widget.list[selectedIndex].answer == 2)) {
      if (selectedIndex == 0) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3], answers[4]]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add([answers[5] == "Y0" ? "Y" : "N", answers[5] == "Y1" ? "Y" : "N", answers[5] == "Y2" ? "Y" : "N"]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 1) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 2) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 3) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 4) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 5) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 6) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3], answers[4]]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add(answers[5]);
        val.add(answers[6]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 7) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add(answers[5]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 8) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 9) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3], answers[4]]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 10) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add([answers[5] == "Y0" ? "Y" : "N", answers[5] == "Y1" ? "Y" : "N", answers[5] == "Y2" ? "Y" : "N", answers[5] == "Y3" ? "Y" : "N"]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 11) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3], answers[4]]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add([answers[6], answers[7], answers[8]]);
        val.add(answers[6]);
        val.add(answers[7]);
        val.add(answers[8]);
        val.add([answers[9] == "Y0" ? "Y" : "N", answers[9] == "Y1" ? "Y" : "N", answers[9] == "Y2" ? "Y" : "N"]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 12) {
        List<dynamic> val = [];
        val.add(answers[0]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 13) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add(answers[5]);
        val.add(answers[6]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 14) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3], answers[4]]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 15) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3], answers[4], answers[5]]);
        val.add(answers[2]);
        val.add(answers[3]);
        val.add(answers[4]);
        val.add(answers[5]);
        val.add([answers[6] == "Y0" ? "Y" : "N", answers[6] == "Y1" ? "Y" : "N", answers[6] == "Y2" ? "Y" : "N", answers[6] == "Y3" ? "Y" : "N"]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 16) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3]]);
        val.add(answers[2]);
        val.add(answers[3]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 17) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2]]);
        val.add(answers[2]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 18) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add(answers[1]);
        val.add(answers[2]);
        val.add(answers[3]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      } else if (selectedIndex == 19) {
        List<dynamic> val = [];
        val.add(answers[0]);
        val.add([answers[2], answers[3]]);
        val.add(answers[2]);
        val.add(answers[3]);
        valueList[selectedIndex] = val;
        print(valueList[selectedIndex]);
      }
    }

    if (additionalIndex == widget.additional_list.length - 1) {
      //추가 질문 끝
      print(gUserInfo!.accessToken);
      for (int i = 0; i < widget.list.length; i++) {
        //추가질문을 거치지 않은 질문들
        if (valueList[i] == "") {
          valueList[i] = widget.list[i].giveFlag == 'y' ? "N" : "Y";
        }
      }
      //json string
      List<Map<String, dynamic>> list = [];
      for (int i = 0; i < widget.list.length; i++) {
        Map<String, dynamic> info = {
          'id': int.parse(widget.list[i].id!),
          'value': valueList[i],
        };
        list.add(info);
      }
      String plist = json.encode(list);
      print(plist);

      eventBus.fire(CheckChatQuizEvent(chat_info: plist));
    } else {
      additionalIndex++;
      loadAdditionalQuiz(additionalIndex);
    }
  }

  bool checkValid() {
    if ((widget.list[selectedIndex].giveFlag == 'y' && widget.list[selectedIndex].answer == 2) ||
        (widget.list[selectedIndex].giveFlag == 'n' && widget.list[selectedIndex].answer == 1)) {
      return true;
    }

    if (selectedIndex == 0) {
      setState(() {
        repeat = false;
      });
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2] == "Y" && answers[3] == "N" && answers[4] == "N") {
        return true;
      } else if (answers[2] == "N" && answers[3] == "Y" && answers[4] == "Y") {
        return true;
      } else if (answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty) {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && answers[5].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 4) {
      setState(() {
        repeat = false;
      });
      if (answers[2] == "Y" || answers[3] == "Y") {
        setState(() {
          repeat = true;
        });
      }
      if (repeat) {
        return answers.sublist(1).where((element) => element.isEmpty).toList().isEmpty;
      } else {
        return answers.sublist(1, answers.length - 1).where((element) => element.isEmpty).toList().isEmpty;
      }
    } else if (selectedIndex == 5) {
      setState(() {
        repeat = false;
      });
      //answer[0]:기본질문
      if (answers[1] == "Y" || answers[2] == "Y") {
        setState(() {
          repeat = true;
        });
      }
      if (repeat) {
        return answers.sublist(1).where((element) => element.isEmpty).toList().isEmpty;
      } else {
        return answers.sublist(1, answers.length - 1).where((element) => element.isEmpty).toList().isEmpty;
      }
    } else if (selectedIndex == 6) {
      setState(() {
        repeat = false;
        repeat2 = false;
      });
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2] == "N" && answers[3] == "N" && answers[4] == "N") {
        return true;
      } else if (answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty) {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && answers[5] == "Y") {
        setState(() {
          repeat2 = true;
        });
      } else if (repeat && answers[5] == "N") {
        return true;
      }
      if (repeat2 && answers[6].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 7) {
      setState(() {
        repeat = false;
        repeat2 = false;
      });
      //answer[0]:기본질문
      if (answers[1] == "Y") {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && (answers[2] == "Y" || answers[3] == "Y" || answers[4] == "Y")) {
        setState(() {
          repeat2 = true;
        });
      }
      if (repeat && answers[2] == "N" && answers[3] == "N" && answers[4] == "N") {
        return true;
      }
      if (repeat2 && answers[5].isNotEmpty) {
        return true;
      }
      if (repeat) {
        return answers.sublist(1).where((element) => element.isEmpty).toList().isEmpty;
      } else {
        return answers.sublist(1, answers.length - 4).where((element) => element.isEmpty).toList().isEmpty;
      }
    } else if (selectedIndex == 8) {
      setState(() {
        repeat = false;
      });
      //answer[0]:기본질문
      if (answers[1] == "Y" || answers[2] == "Y" || answers[3] == "Y") {
        setState(() {
          repeat = true;
        });
      }
      if (repeat) {
        return answers.sublist(1).where((element) => element.isEmpty).toList().isEmpty;
      } else {
        return answers.sublist(1, answers.length - 1).where((element) => element.isEmpty).toList().isEmpty;
      }
    } else if (selectedIndex == 9) {
      //answer[0]:기본질문, answer[1]:추가질문
      return answers.sublist(2).where((element) => element.isEmpty).toList().isEmpty;
    } else if (selectedIndex == 10) {
      setState(() {
        repeat = false;
      });
      //answer[0]:기본질문,
      if (answers[1] == "Y" && answers[2] == "N" && answers[3] == "N" && answers[4] == "N") {
        return true;
      } else if (answers[1] == "N" && answers[2] == "N" && answers[3] == "Y" && answers[4] == "Y") {
        return true;
      } else if (answers[1].isNotEmpty && answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty) {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && answers[5].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 11) {
      setState(() {
        repeat = false;
        repeat2 = false;
      });
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty) {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && answers[6] == "Y" && answers[7] == "Y" && answers[8] == "N") {
        return true;
      } else if (repeat && answers[6] == "N" && answers[7] == "N" && answers[8] == "Y") {
        return true;
      }
      if (repeat && answers[6].isNotEmpty && answers[7].isNotEmpty && answers[8].isNotEmpty) {
        setState(() {
          repeat2 = true;
        });
      }
      if (repeat2 && answers[9].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 12) {
      return true;
    } else if (selectedIndex == 13) {
      setState(() {
        repeat = false;
        repeat2 = false;
      });
      //answer[0]:기본질문

      if (answers[1].isNotEmpty && answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty) {
        List<String> yesList = answers.sublist(1, 5).where((element) => element == "Y").toList();
        if (yesList.isEmpty || yesList.length >= 2) {
          //모두 아니오, 예가 두개 이상
          return true;
        } else {
          setState(() {
            repeat = true;
          });
        }
      }
      if (repeat && answers[5] == "N") {
        return true;
      } else if (repeat && answers[5] == "Y") {
        setState(() {
          repeat2 = true;
        });
      }
      if (repeat2 && answers[6].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 14) {
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 15) {
      setState(() {
        repeat = false;
      });
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2] == "Y" && answers[3] == "Y" && answers[4] == "N" && answers[5] == "N") {
        return true;
      } else if (answers[2] == "N" && answers[3] == "N" && answers[4] == "Y" && answers[5] == "Y") {
        return true;
      } else if (answers[2].isNotEmpty && answers[3].isNotEmpty && answers[4].isNotEmpty && answers[5].isNotEmpty) {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && answers[6].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 16) {
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2].isNotEmpty && answers[3].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 17) {
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 18) {
      setState(() {
        repeat = false;
        repeat2 = false;
      });
      //answer[0]:기본질문
      if (answers[1] == "Y") {
        return true;
      } else if (answers[1] == "N") {
        setState(() {
          repeat = true;
        });
      }
      if (repeat && answers[2] == "Y") {
        return true;
      } else if (repeat && answers[2] == "N") {
        setState(() {
          repeat2 = true;
        });
      }
      if (repeat2 && answers[3].isNotEmpty) {
        return true;
      }
    } else if (selectedIndex == 19) {
      //answer[0]:기본질문, answer[1]:추가질문
      if (answers[2].isNotEmpty && answers[3].isNotEmpty) {
        return true;
      }
    } else {
      //answer[0]:기본질문
      return answers.sublist(1).where((element) => element.isEmpty).toList().isEmpty;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    if (selectedIndex == -1) {
      return Container();
    }
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                        width: screenSize.width,
                        child: H24B(
                          text: "공통문항 응답결과에 따른 \n추가 문항입니다.",
                          align: TextAlign.left,
                          maxLine: 2,
                          height: 1.5,
                        )),
                    const SizedBox(height: 50),
                    H16(
                      text: "${selectedIndex + 1}. " + widget.list[selectedIndex].quiz!,
                      maxLine: 5,
                      align: TextAlign.left,
                      height: 1.5,
                      weight: FW.medium,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.list[selectedIndex].answer = 1;
                                answers[0] = "Y";
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  widget.list[selectedIndex].answer == 1 ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                                  width: 25,
                                  height: 25,
                                ),
                                const SizedBox(width: 10),
                                H16(text: LanguageService.trans("yes1"), weight: FW.medium, color: AppColor_BlackText),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.list[selectedIndex].answer = 2;
                                answers[0] = "N";
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  widget.list[selectedIndex].answer == 2 ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                                  width: 25,
                                  height: 25,
                                ),
                                const SizedBox(width: 10),
                                H16(text: LanguageService.trans("no1"), weight: FW.medium, color: AppColor_BlackText),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Visibility(
                      visible: (widget.list[selectedIndex].giveFlag == 'y' && widget.list[selectedIndex].answer == 1) ||
                          (widget.list[selectedIndex].giveFlag == 'n' && widget.list[selectedIndex].answer == 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(thickness: 1, color: AppColor_Gray),
                          const SizedBox(height: 50),
                          questionBuilder(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            MainTextButton(
              text: LanguageService.trans("next"),
              backgroundColor: AppColor_Primary,
              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
              radius: 0,
              height: 66,
              disable: !checkValid(),
              disableBackground: !checkValid() ? AppColor_Primary_Disable : Colors.transparent,
              onPressed: () {
                if (checkValid()) {
                  goNext();
                }
              },
            ),
          ],
        ));
  }

  String removeExtra(String question) {
    String text = question;
    if (text.contains('[') && text.contains(']')) {
      text = text.substring(0, text.indexOf('['));
    }
    return text;
  }

  Widget questionBuilder() {
    if (selectedIndex == 0) {
      return Column(
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, repeat ? 5 : 4), index);
              },
              itemCount: repeat ? 4 : 3),
        ],
      );
    } else if (selectedIndex == 4) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(0, repeat ? 4 : 3), index);
              },
              itemCount: repeat ? 4 : 3),
        ],
      );
    } else if (selectedIndex == 5) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(0, repeat ? 3 : 2), index);
              },
              itemCount: repeat ? 3 : 2),
        ],
      );
    } else if (selectedIndex == 6) {
      return Column(
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(
                    context,
                    widget.list[selectedIndex].addtionalQuizs!.sublist(
                        1,
                        repeat2
                            ? 6
                            : repeat
                                ? 5
                                : 4),
                    index);
              },
              itemCount: repeat2
                  ? 5
                  : repeat
                      ? 4
                      : 3),
        ],
      );
    } else if (selectedIndex == 7) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(
                    context,
                    widget.list[selectedIndex].addtionalQuizs!.sublist(
                        0,
                        repeat2
                            ? 5
                            : repeat
                                ? 4
                                : 1),
                    index);
              },
              itemCount: repeat2
                  ? 5
                  : repeat
                      ? 4
                      : 1),
        ],
      );
    } else if (selectedIndex == 8) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(0, repeat ? 4 : 3), index);
              },
              itemCount: repeat ? 4 : 3),
        ],
      );
    } else if (selectedIndex == 9) {
      return Column(
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, 4), index);
              },
              itemCount: 3),
        ],
      );
    } else if (selectedIndex == 10) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(0, repeat ? 5 : 4), index);
              },
              itemCount: repeat ? 5 : 4),
        ],
      );
    } else if (selectedIndex == 11) {
      return Column(
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(
                    context,
                    widget.list[selectedIndex].addtionalQuizs!.sublist(
                        1,
                        repeat2
                            ? 9
                            : repeat
                                ? 8
                                : 4),
                    index);
              },
              itemCount: repeat2
                  ? 8
                  : repeat
                      ? 7
                      : 3),
        ],
      );
    } else if (selectedIndex == 12) {
      return Container();
    } else if (selectedIndex == 13) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(
                    context,
                    widget.list[selectedIndex].addtionalQuizs!.sublist(
                        0,
                        repeat2
                            ? 6
                            : repeat
                                ? 5
                                : 4),
                    index);
              },
              itemCount: repeat2
                  ? 6
                  : repeat
                      ? 5
                      : 4),
        ],
      );
    } else if (selectedIndex == 14) {
      return Column(
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, 4), index);
              },
              itemCount: 3),
        ],
      );
    } else if (selectedIndex == 15) {
      return Column(
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, repeat ? 6 : 5), index);
              },
              itemCount: repeat ? 5 : 4),
        ],
      );
    } else if (selectedIndex == 16) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.start,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, 3), index);
              },
              itemCount: 2),
        ],
      );
    } else if (selectedIndex == 17) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.start,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, 2), index);
              },
              itemCount: 1),
        ],
      );
    } else if (selectedIndex == 18) {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(
                    context,
                    widget.list[selectedIndex].addtionalQuizs!.sublist(
                        0,
                        repeat2
                            ? 3
                            : repeat
                                ? 2
                                : 1),
                    index);
              },
              itemCount: repeat2
                  ? 3
                  : repeat
                      ? 2
                      : 1),
        ],
      );
    } else if (selectedIndex == 19) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H16(
            text: '[추가 응답] ' + removeExtra(widget.list[selectedIndex].addtionalQuizs![0]),
            maxLine: 5,
            align: TextAlign.start,
            height: 1.5,
            weight: FW.medium,
          ),
          const SizedBox(height: 25),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!.sublist(1, 3), index);
              },
              itemCount: 2),
        ],
      );
    } else {
      return Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(context, widget.list[selectedIndex].addtionalQuizs!, index);
              },
              itemCount: widget.list[selectedIndex].addtionalQuizs!.length),
        ],
      );
    }
    return Container();
  }

  Widget _itemBuilder(BuildContext context, List<String> list, int index) {
    int extraIndex = (selectedIndex == 0 ||
            selectedIndex == 6 ||
            selectedIndex == 9 ||
            selectedIndex == 11 ||
            selectedIndex == 14 ||
            selectedIndex == 15 ||
            selectedIndex == 16 ||
            selectedIndex == 17 ||
            selectedIndex == 19)
        ? 2
        : 1; //1더한것은 기본질문, 1더한것은 추가질문
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: H16(
            align: repeat && index == 3 && selectedIndex == 11 ? TextAlign.center : TextAlign.start,
            text: (repeat && index == 3 && selectedIndex == 11 ? '[추가 응답] ' : '') + removeExtra(list[index]),
            weight: FW.medium,
            maxLine: 5,
          ),
        ),
        const SizedBox(height: 15),
        repeat && index == 3 && selectedIndex == 11
            ? Container()
            : repeat &&
                    index == list.length - 1 &&
                    (selectedIndex == 0 || selectedIndex == 10 || selectedIndex == 15 || (selectedIndex == 11 && repeat2))
                ? SizedBox(
                    height: 40 * (selectedIndex == 11 ? 3 : (list.length - 1)),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index1) {
                          return SizedBox(
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  answers[index + extraIndex] = "Y$index1";
                                  checkValid();
                                });
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    answers[index + extraIndex] == "Y$index1" ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: H16(
                                          text: list[index1 + (selectedIndex == 11 ? 4 : 0)],
                                          weight: FW.medium,
                                          color: AppColor_BlackText,
                                          maxLine: 5,
                                          align: TextAlign.start)),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: selectedIndex == 11 ? 3 : (list.length - 1)),
                  )
                : SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              answers[index + extraIndex] = "Y"; // +2을 한 이유는 기본 질문, 추가질문이 포함되기때문
                              checkValid();
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                answers[index + extraIndex] == "Y" ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              H16(text: LanguageService.trans("yes1"), weight: FW.medium, color: AppColor_BlackText),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            setState(() {
                              answers[index + extraIndex] = "N"; // +2을 한 이유는 기본 질문, 추가질문이 포함되기때문
                              checkValid();
                            });
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                answers[index + extraIndex] == "N" ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              H16(text: LanguageService.trans("no1"), weight: FW.medium, color: AppColor_BlackText),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        const SizedBox(height: 15),
      ],
    );
  }
}
