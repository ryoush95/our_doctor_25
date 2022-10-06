import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/check_child_model.dart';
import 'package:ourdoctor/models/child_quiz_list_res_model.dart';
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
import 'package:ourdoctor/provider/child_quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class InspectionSecondPage2 extends StatefulWidget {
  final List<ChildQuizDto> list;
  final int birth_code;

  InspectionSecondPage2({Key? key, required this.list, required this.birth_code}) : super(key: key);

  @override
  InspectionSecondPage2State createState() => InspectionSecondPage2State();
}

class InspectionSecondPage2State extends BaseState<InspectionSecondPage2> {
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
    final p = Provider.of<ChildQuizProvider>(context, listen: false);
    if (widget.list.sublist(0,widget.list.length).where((element) => element.answer == "").toList().isNotEmpty) {
      showToast('모든 문항에 대한 답변이 필요합니다.');
      return;
    }
    for(var i in widget.list){
      p.updateList(i.id!, i.answer);
    }
    // eventBus.fire(UpdateQuizEvent());
    // String birth = gSelChildInfo!.birth.toString();
    String ql = json.encode(p.quizList);
    String rl = json.encode(p.resultList);
    Future<CheckChildQuizModel> insert = httpService.checkChildQuiz(ql, rl, widget.birth_code.toString());
    insert.then((value) async {
      if(value.result != 0){
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      print(onError.toString());
    });
    // p.clearList();
    eventBus.fire(CheckChildQuizEvent());
    Navigator.pop(context);
    showToast('검사가 저장되었습니다.');
  }

  bool checkValid() {
    if (widget.list.sublist(0,widget.list.length).where((element) => element.answer == "").toList().isNotEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(width: screenSize.width, child: H24B(text: "영유아 검진", align: TextAlign.left)),
                    const SizedBox(height: 20),
                    H16(
                        text: "⭐ 안내사항 ⭐\n" +
                            " - 자녀의 영유아 검진 진행시 필수로 작성 해야 하는 문진표입니다.\n"+
                            " - 국민건강보험(건강iN)에서 작성가능한 문진표와 동일한 것으로 작성 후 병원에서 사용이 가능합니다.",
                        maxLine: 100,
                        height: 1.7,
                        color: AppColor_707071,
                        weight: FW.medium,
                        align: TextAlign.left),
                    const Divider(color: AppColor_707071,
                      thickness: 1,),
                    H16(
                        text: "아이 질문",
                        maxLine: 100,
                        height: 1.7,
                        color: AppColor_707071,
                        weight: FW.medium,
                        align: TextAlign.left),
                    const SizedBox(height: 40),
                    ListView.builder(shrinkWrap: true, itemBuilder: _itemBuilder, itemCount: widget.list.length, controller: _listController)
                  ],
                ),
              ),
            ),
            MainTextButton(
              text: "완료",
              backgroundColor: AppColor_Primary,
              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
              radius: 0,
              height: 66,
              disable: !checkValid(),
              disableBackground: !checkValid() ? AppColor_Primary_Disable : Colors.transparent,
              onPressed: () {
                goNext();
              },
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int idx) {
    int index = idx;
    var screenSize = MediaQuery.of(context).size;
    return Container(
      child: Column(children: [
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: "${index + 1}. " + widget.list[index].quiz!,
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
        ),
        const SizedBox(height: 15),
        widget.list[index].result == "1"
            ? SizedBox(
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: "답변"
            ),
            onChanged: (value) {
              setState(() {
                widget.list[index].answer = value;
              });
            },
          ),
        ) : SizedBox(
          height: 40,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    widget.list[index].answer = "예";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == "예" ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
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
                    widget.list[index].answer = "아니오";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == "아니오" ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
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
        const SizedBox(height: 30)
      ]),
    );
  }
}
