import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';

class InspectionFirstPage extends StatefulWidget {
  final List<QuizDto> list;

  InspectionFirstPage({Key? key, required this.list}) : super(key: key);

  @override
  InspectionFirstPageState createState() => InspectionFirstPageState();
}

class InspectionFirstPageState extends BaseState<InspectionFirstPage> {
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
    if (widget.list.sublist(0, 10).where((element) => element.answer == 0).toList().isNotEmpty) {
      showToast('모든 문항에 대한 답변이 필요합니다.');
      return;
    }
    eventBus.fire(UpdateQuizEvent());
  }

  bool checkValid() {
    if (widget.list.sublist(0, 10).where((element) => element.answer == 0).toList().isNotEmpty) {
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
                    SizedBox(width: screenSize.width, child: H24B(text: LanguageService.trans("inspection_title"), align: TextAlign.left)),
                    const SizedBox(height: 20),
                    H16(
                        text: LanguageService.trans("inspection_common"),
                        maxLine: 100,
                        height: 1.7,
                        color: AppColor_707071,
                        weight: FW.medium,
                        align: TextAlign.left),
                    const SizedBox(height: 40),
                    ListView.builder(shrinkWrap: true, itemBuilder: _itemBuilder, itemCount: 10, controller: _listController)
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
                goNext();
              },
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
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
        SizedBox(
          height: 40,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    widget.list[index].answer = 1;
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == 1 ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
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
                    widget.list[index].answer = 2;
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      widget.list[index].answer == 2 ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
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
