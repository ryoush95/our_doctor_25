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
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

import '../app_event.dart';
import 'custom_inspection_final.dart';
import 'custom_inspection_result.dart';
import 'inspection_first.dart';
import 'inspection_second.dart';
import 'inspection_third.dart';

class CustomInspectionMainPage extends StatefulWidget {
  const CustomInspectionMainPage({Key? key}) : super(key: key);

  @override
  CustomInspectionMainPageState createState() => CustomInspectionMainPageState();
}

class CustomInspectionMainPageState extends BaseState<CustomInspectionMainPage> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  final HttpService httpService = HttpService();

  List<QuizDto> quizList = [];
  List<int> needAdditionalQuizIndex = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      // changeTab(tabController.index);
    });
    eventBus.on<UpdateQuizEvent>().listen((event) {
      if (mounted) {
        goNext();
      }
    });
    eventBus.on<CheckChatQuizEvent>().listen((event) {
      if (mounted) {
        checkAdditionalChatScore(event.chat_info);
      }
    });

    getQuiz();
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

  Future<void> checkAdditionalChatScore(String chat_info) async {
    setState(() {
      isLoading = true;
    });
    Future<CheckChatResModel> info = httpService.checkChat(chat_info);
    info.then((CheckChatResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        eventBus.fire(SelectChildEvent());
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => CustomInspectionFinalPage(score: value.data!.point!)));
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

  Future<void> checkChatScore() async {
    List<Map<String, dynamic>> arrlist = [];
    for (int i = 0; i < quizList.length; i++) {
      List<String> value = [];
      value.add(quizList[i].answer == 1 ? "Y" : "N");
      Map<String, dynamic> info = {
        'id': int.parse(quizList[i].id!),
        'value': value,
      };
      arrlist.add(info);
    }
    String chat_info = json.encode(arrlist);
    print(gUserInfo!.accessToken! + "," + chat_info);

    setState(() {
      isLoading = true;
    });
    Future<CheckChatResModel> info = httpService.checkChat(chat_info);
    info.then((CheckChatResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.push(
            context,
            SlideRightTransRoute(
                builder: (context) => CustomInspectionResultPage(
                    score: value.data!.point!,
                    onTap: (int score) {
                      if (score >= 3 && score <= 7) {
                        loadAdditionalQuiz();

                        tabIndex = 2;
                        changeTab(tabIndex);
                      } else {
                        Navigator.pop(context);
                      }
                    })));
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

  void goNext() {
    if (tabIndex == 0) {
      tabIndex = 1;
      changeTab(tabIndex);
    } else if (tabIndex == 1) {
      checkChatScore();
    } else if (tabIndex == 2) {}
  }

  Future<void> getQuiz() async {
    print(gUserInfo!.id!);
    setState(() {
      isLoading = true;
    });
    Future<ChatQuizListResModel> info = httpService.getChatQuizList();
    info.then((ChatQuizListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        quizList.clear();
        quizList.addAll(value.data!);
        //for test
        // for (int i = 0; i < quizList.length; i++) {
        //   quizList[i].answer = 1;
        // }
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

  void loadAdditionalQuiz() {
    needAdditionalQuizIndex.clear();
    for (int i = 0; i < quizList.length; i++) {
      if ((quizList[i].giveFlag == 'y' && quizList[i].answer == 1) || (quizList[i].giveFlag == 'n' && quizList[i].answer == 2)) {
        needAdditionalQuizIndex.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: quizList.isEmpty
            ? Container()
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    SimpleHeader(
                      title: LanguageService.trans('custom_inspection'),
                      onBackPressed: onBackPressed,
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTabHeaderItem(tabIndex),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                            body: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            InspectionFirstPage(list: quizList),
                            InspectionSecondPage(list: quizList),
                            InspectionThirdPage(list: quizList, additional_list: needAdditionalQuizIndex)
                          ],
                        )),
                      ),
                    )),
                  ],
                ),
              ));
  }

  Widget _buildTabHeaderItem(int step) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 100,
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 30,
                child: Row(children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: AppColor_Primary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: step >= 1 ? AppColor_Primary : AppColor_Gray,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: step >= 1 ? AppColor_Primary : AppColor_Gray,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: step >= 2 ? AppColor_Primary : AppColor_Gray,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: step >= 2 ? AppColor_Primary : AppColor_Gray,
                    ),
                  ),
                ])),
            Stack(children: [
              Row(children: [
                H12(text: LanguageService.trans("common_questions"), color: AppColor_Primary),
                const SizedBox(width: 5),
                H12(text: "1-10", color: AppColor_Primary),
              ]),
              Positioned(
                left: 0,
                right: 0,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  H12(text: LanguageService.trans("common_questions"), color: step >= 1 ? AppColor_Primary : AppColor_Gray),
                  const SizedBox(width: 5),
                  H12(text: "11-20", color: step >= 1 ? AppColor_Primary : AppColor_Gray),
                ]),
              ),
              Positioned(
                  right: 0, child: H12(text: LanguageService.trans("additional_questions"), color: step >= 2 ? AppColor_Primary : AppColor_Gray))
            ]),
          ],
        ));
  }
}
