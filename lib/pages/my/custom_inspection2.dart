import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/check_chat_res_model.dart';
import 'package:ourdoctor/models/child_quiz_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/provider/child_quiz_provider.dart';
import 'package:provider/provider.dart';

import '../app_event.dart';
import 'custom_inspection_final.dart';
import 'custom_inspection_result.dart';
import 'inspection_first2.dart';
import 'inspection_second2.dart';

class CustomInspectionMainPage2 extends StatefulWidget {
  const CustomInspectionMainPage2({Key? key}) : super(key: key);

  @override
  CustomInspectionMainPage2State createState() => CustomInspectionMainPage2State();
}

class CustomInspectionMainPage2State extends BaseState<CustomInspectionMainPage2> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  final HttpService httpService = HttpService();

  List<ChildQuizDto> quizList2 = [];
  List<ChildQuizDto> quizList3 = [];
  List<int> needAdditionalQuizIndex = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      // changeTab(tabController.index);
    });
    eventBus.on<UpdateQuizEvent>().listen((event) {
      if (mounted) {
        goNext();
      }
    });
    getQuiz2();
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

  // Future<void> checkAdditionalChatScore(String chat_info) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Future<CheckChatResModel> info = httpService.checkChat(chat_info);
  //   info.then((CheckChatResModel value) async {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     if (value.result == 0) {
  //       eventBus.fire(SelectChildEvent());
  //       Navigator.pushReplacement(
  //           context,
  //           SlideRightTransRoute(
  //               builder: (context) =>
  //                   CustomInspectionFinalPage(score: value.data!.point!)));
  //     } else {
  //       showToast(value.msg ?? "");
  //       if (value.result == 106) {}
  //     }
  //   }).catchError((onError) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showToast(onError);
  //   });
  // }

  void goNext() {
    if (tabIndex == 0) {
      tabIndex = 1;
      changeTab(tabIndex);
    } else if (tabIndex == 1) {
      // checkChatScore();
      // showToast("검사가 저장되었습니다");
    }
  }

  Future<void> getQuiz2() async {
    print(gUserInfo!.id!);
    int birth_code = 0;
    DateTime dt = DateTime.parse(gSelChildInfo!.birth!);
    int aa = DateTime.now().difference(dt).inDays ~/ 30;
    if (aa < 1) {
      birth_code = 1;
    } else if (aa >= 3 && aa <= 6) {
      birth_code = 2;
    } else if (aa >= 8 && aa <= 12) {
      birth_code = 3;
    } else if (aa >= 17 && aa <= 24) {
      birth_code = 4;
    } else if (aa >= 29 && aa <= 36) {
      birth_code = 5;
    } else if (aa >= 41 && aa <= 48) {
      birth_code = 6;
    } else if (aa >= 53 && aa <= 60) {
      birth_code = 7;
    }
    setState(() {
      isLoading = true;
    });
    Future<ChildQuizListResModel> info = httpService.getChildQuizList();
    info.then((ChildQuizListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        quizList2.clear();
        for (var e in value.data!) {
          if (e.age == birth_code.toString() && e.page == 1.toString()) {
            quizList2.add(e);
          } else if (e.age == birth_code.toString() && e.page == 2.toString()) {
            quizList3.add(e);
          }
        }
        print(birth_code);
        // quizList2.addAll(value.data!);
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

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: quizList2.isEmpty
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
                    Expanded(
                        child: Container(
                      // child: InspectionFirstPage2(list: quizList2),
                      child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                            body: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            InspectionFirstPage2(list: quizList2),
                            InspectionSecondPage2(list: quizList3),
                          ],
                        )),
                      ),
                    )),
                  ],
                ),
              ));
  }
}
