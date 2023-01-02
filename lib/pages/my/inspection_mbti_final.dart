import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/alarm/alarm.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';

import 'custom_mbti_inspection_result.dart';

class InspectionMbtiFinalPage extends StatefulWidget {
  final List<MbtiQuizDto> list;

  InspectionMbtiFinalPage({Key? key, required this.list}) : super(key: key);

  @override
  InspectionMbtiFinalPageState createState() =>
      InspectionMbtiFinalPageState();
}

class InspectionMbtiFinalPageState
    extends BaseState<InspectionMbtiFinalPage> {
  final HttpService httpService = HttpService();
  late ScrollController _listController;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
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
    super.dispose();
    _listController.dispose();
  }

  void goNext() {
    if (widget.list
        .sublist(0, widget.list.length)
        .where((element) => element.answer == "")
        .toList()
        .isNotEmpty) {
      showToast('모든 문항에 대한 답변이 필요합니다.');
      return;
    }
    eventBus.fire(UpdateQuizEvent());
  }

  bool checkValid() {
    if (widget.list
        .sublist(0, widget.list.length)
        .where((element) => element.answer == "")
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "우리 아이 성격 테스트!\n\n",
                              style: AppTextStyle.PD(AppColor_Primary, 20,
                                  weight: FW.bold),
                            ),
                            TextSpan(
                              text: "우리 아이 성격에 딱 맞는 유명인은 \n누가 있을까?\n\n\n",
                              style: AppTextStyle.PD(AppColor_BlackText, 18,
                                  weight: FW.regular),
                            ),
                            TextSpan(
                              text: "다음 질문에 응답해 주세요.\n\n\n",
                              style: AppTextStyle.PD(AppColor_BlackText, 19,
                                  weight: FW.bold),
                            ),
                            TextSpan(
                              text: "4 / 4 ",
                              style: AppTextStyle.PD(AppColor_Table_DateTime, 15,
                                  weight: FW.regular),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: AppColor_Table_DateTime,
                        thickness: 1,
                      ),
                      const SizedBox(height: 30),
                      ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: _itemBuilder,
                          itemCount: widget.list.length,
                          controller: _listController)
                    ],
                  ),
                ),
              ),
            ),
            MainTextButton(
              text: LanguageService.trans("결과 보기"),
              backgroundColor: AppColor_Primary,
              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
              radius: 0,
              height: 66,
              disable: !checkValid(),
              disableBackground:
                  !checkValid() ? AppColor_Primary_Disable : Colors.transparent,
              onPressed: () {
                goNext();
              },
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int idx) {
    int index = idx ;
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Q${index + 1}\n\n",
                    style: AppTextStyle.PD(AppColor_Table_DateTime, 18,
                        weight: FW.bold),
                  ),
                  TextSpan(
                    text: widget.list[index].quiz!,
                    style:
                    AppTextStyle.PD(AppColor_BlackText, 17, weight: FW.regular, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            checkbox(index),
            const SizedBox(height: 30)
          ]),
    );
  }


  Widget checkbox(int index) {
    return Column(
      children: [
        Row(
          children: [
            widget.list[index].answer == "1" || widget.list[index].answer == "2"
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
                    widget.list[index].answer = "1";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == "1"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),

              ),InkWell(
                onTap: () {
                  setState(() {
                    widget.list[index].answer = "2";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == "2"
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
                    widget.list[index].answer = "3";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == "3"
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
                    widget.list[index].answer = "4";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == "4"
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
            widget.list[index].answer == "3" || widget.list[index].answer == "4"
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
}
