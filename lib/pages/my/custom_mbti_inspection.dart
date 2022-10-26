import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/check_chat_res_model.dart';
import 'package:ourdoctor/models/child_quiz_list_res_model.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/res/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

import '../app_event.dart';
import 'custom_inspection_final.dart';
import 'custom_inspection_result.dart';
import 'custom_mbti_inspection_result.dart';
import 'inspection_first.dart';
import 'inspection_first2.dart';
import 'inspection_mbti_final.dart';
import 'inspection_mbti_first.dart';
import 'inspection_mbti_second.dart';
import 'inspection_mbti_third.dart';
import 'inspection_second.dart';
import 'inspection_second2.dart';
import 'inspection_third.dart';

class CustomMbtiInspectionMainPage extends StatefulWidget {
  const CustomMbtiInspectionMainPage({Key? key}) : super(key: key);

  @override
  CustomMbtiInspectionMainPageState createState() =>
      CustomMbtiInspectionMainPageState();
}

class CustomMbtiInspectionMainPageState extends BaseState<CustomMbtiInspectionMainPage> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  final HttpService httpService = HttpService();

  List<MbtiQuizDto> quizList1 = [];   //E,I
  List<MbtiQuizDto> quizList2 = [];   //N,S
  List<MbtiQuizDto> quizList3 = [];   //T,F
  List<MbtiQuizDto> quizList4 = [];   //J,P

  String mbti = "";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      // changeTab(tabController.index);
    });
    eventBus.on<UpdateQuizEvent>().listen((event) {
      if (mounted) {
        goNext();
      }
    });
    getQuiz();
    checkMbtiResult();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void changeTab(int tab) {
    setState(() {
      tabIndex = tab;
      tabController.index = tabIndex;
    });
  }

  void goNext() {
    if (tabIndex == 0) {
      tabIndex = 1;
      changeTab(tabIndex);
    } else if (tabIndex == 1) {
      tabIndex = 2;
      changeTab(tabIndex);
    } else if (tabIndex == 2) {
      tabIndex = 3;
      changeTab(tabIndex);
    } else if (tabIndex == 3) {
      tabIndex = 4;
      checkMbtiResult();
    }
  }

  Future<void> checkMbtiResult() async {
    setState(() {
      isLoading = false;
    });
    List<Map<String, dynamic>> arrlist = [];
    List<String> value = [];

    for (int i = 0; i <quizList1.length; i++) {
      if (quizList1[i].result == "e") {
        value.add(quizList1[i].answer == "3" || quizList1[i].answer == "4" ? "e" : "i");
      } else {
        value.add(quizList1[i].answer == "3" || quizList1[i].answer == "4" ? "i" : "e");
      }
    }
    for (int i = 0; i <quizList2.length; i++) {
      if (quizList2[i].result == "s") {
        value.add(quizList2[i].answer == "3" || quizList2[i].answer == "4" ? "s" : "n");
      } else {
        value.add(quizList2[i].answer == "3" || quizList2[i].answer == "4" ? "n" : "s");
      }
    }
    for (int i = 0; i <quizList3.length; i++) {
      if (quizList3[i].result == "t") {
        value.add(quizList3[i].answer == "3" || quizList3[i].answer == "4" ? "t" : "f");
      } else {
        value.add(quizList3[i].answer == "3" || quizList3[i].answer == "4" ? "f" : "t");
      }
    }
    for (int i = 0; i <quizList4.length; i++) {
      if (quizList4[i].result == "j") {
        value.add(quizList4[i].answer == "3" || quizList4[i].answer == "4" ? "j" : "p");
      } else {
        value.add(quizList4[i].answer == "3" || quizList4[i].answer == "4" ? "p" : "j");
      }
    }
    Map<String, dynamic> info = {
      'value': value,
    };
    arrlist.add(info);
    String mbti_info = json.encode(arrlist);


    var count = value.where((c) => c.contains("e")).toList().length;
    var count1 = value.where((c) => c.contains("i")).toList().length;

    var count2 = value.where((c) => c.contains("s")).toList().length;
    var count3 = value.where((c) => c.contains("n")).toList().length;

    var count4 = value.where((c) => c.contains("t")).toList().length;
    var count5 = value.where((c) => c.contains("f")).toList().length;

    var count6 = value.where((c) => c.contains("j")).toList().length;
    var count7 = value.where((c) => c.contains("p")).toList().length;

    if(count < count1 && count2 < count3 && count4 < count5 && count6 < count7) {
      mbti = "infp";
    } else if(count < count1 && count2 > count3 && count4 < count5 && count6 < count7) {
      mbti = "isfp";
    } else if(count < count1 && count2 < count3 && count4 > count5 && count6 < count7) {
      mbti = "intp";
    } else if(count < count1 && count2 < count3 && count4 < count5 && count6 > count7) {
      mbti = "infj";
    } else if(count > count1 && count2 < count3 && count4 < count5 && count6 < count7) {
      mbti = "enfp";
    } else if(count > count1 && count2 > count3 && count4 < count5 && count6 < count7) {
      mbti = "esfp";
    } else if(count > count1 && count2 < count3 && count4 > count5 && count6 < count7) {
      mbti = "entp";
    } else if(count > count1 && count2 < count3 && count4 < count5 && count6 > count7) {
      mbti = "enfj";
    } else if(count > count1 && count2 > count3 && count4 > count5 && count6 < count7) {
      mbti = "estp";
    } else if(count > count1 && count2 > count3 && count4 > count5 && count6 > count7) {
      mbti = "estj";
    } else if(count < count1 && count2 < count3 && count4 > count5 && count6 > count7) {
      mbti = "intj";
    } else if(count < count1 && count2 > count3 && count4 > count5 && count6 < count7) {
      mbti = "istp";
    } else if(count > count1 && count2 < count3 && count4 > count5 && count6 > count7) {
      mbti = "entj";
    } else if(count < count1 && count2 > count3 && count4 > count5 && count6 > count7) {
      mbti = "istj";
    } else if(count > count1 && count2 > count3 && count4 < count5 && count6 > count7) {
      mbti = "esfj";
    } else if(count < count1 && count2 > count3 && count4 < count5 && count6 > count7) {
      mbti = "isfj";
    }

    Future<MbtiQuizSendResModel> insert = httpService.getMbtiSendResult(mbti_info, mbti);
    insert.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.push(context, SlideRightTransRoute(builder: (context) => CustomMbtiInspectionResultPage(mbti: mbti)));
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> getQuiz() async {
    print(gUserInfo!.id!);
    setState(() {
      isLoading = true;
    });
    Future<MbtiQuizListResModel> info = httpService.getMbtiQuizList();
    info.then((MbtiQuizListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        quizList1.clear();
        for (var e in value.data!) {
          if (e.type == "1") {
            quizList1.add(e);
          } else if (e.type == "2") {
            quizList2.add(e);
          } else if (e.type == "3") {
            quizList3.add(e);
          } else if (e.type == "4") {
            quizList4.add(e);
          }
        }
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {}
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: quizList1.isEmpty
            ? Container()
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    SimpleHeader(
                      title: LanguageService.trans('우리 아이 성격테스트'),
                      onBackPressed: onBackPressed,
                    ),
                    Container(
                      height:40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: DefaultTabController(
                        length: 4,
                        child: Scaffold(
                            body: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            InspectionMbtiFirstPage(list: quizList1),
                            InspectionMbtiSecondPage(list: quizList2),
                            InspectionMbtiThirdPage(list: quizList3),
                            InspectionMbtiFinalPage(list: quizList4,)
                          ],
                        )),
                      ),
                    )),
                  ],
                ),
              ));
  }
}
