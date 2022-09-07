import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:substring_highlight/substring_highlight.dart';

class CustomInspectionResultPage extends StatefulWidget {
  final score;
  final void Function(int) onTap;

  const CustomInspectionResultPage({Key? key, required this.score, required this.onTap}) : super(key: key);

  @override
  CustomInspectionResultPageState createState() => CustomInspectionResultPageState();
}

class CustomInspectionResultPageState extends BaseState<CustomInspectionResultPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      SizedBox(width: screenSize.width, child: H22(text: LanguageService.trans("inspection_title"), align: TextAlign.left)),
                      const SizedBox(height: 10),
                      SizedBox(width: screenSize.width, child: H22(text: LanguageService.trans("response_answer_result"), align: TextAlign.left)),
                      RangeShow(
                          start: LanguageService.trans('low_level_danger'),
                          end: LanguageService.trans('high_level_danger'),
                          rate: (widget.score * 100.0 / 20.0),
                          unit: "",
                          cur_value: double.parse(widget.score.toString()),
                          color: widget.score < 3 ? AppColor_Primary : (widget.score > 7 ? AppColor_Red : AppColor_Yellow),
                          isInspect: true),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            H18(text: widget.score < 3 ? LanguageService.trans('autism_low') : (widget.score > 7 ? LanguageService.trans('autism_high') : LanguageService.trans('autism_mid')), weight: FW.semi_bold),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(widget.score > 7 ? "assets/icon4.png" : "assets/icon1.png", width: 48, height: 48),
                                const SizedBox(width: 12),
                                Image.asset((widget.score >= 3 && widget.score <= 7) ? "assets/icon5.png" : "assets/icon2.png", width: 48, height: 48),
                                const SizedBox(width: 12),
                                Image.asset(widget.score < 3 ? "assets/icon6.png" : "assets/icon3.png", width: 48, height: 48),
                              ],
                            ),
                            const SizedBox(height: 32),
                            widget.score < 3
                                ? H16(text: LanguageService.trans('autism_low_description'), weight: FW.regular, color: AppColor_GrayText, maxLine: 10, height: 1.2)
                                : widget.score > 7
                                    ? H16(text: LanguageService.trans('autism_high_description'), weight: FW.regular, color: AppColor_GrayText, maxLine: 10, height: 1.2)
                                    : SubstringHighlight(
                                        text: LanguageService.trans('autism_mid_description'),
                                        term: "추적 관찰 문항",
                                        textAlign: TextAlign.center,
                                        textStyle: AppTextStyle.PD(AppColor_GrayText, 16, weight: FW.regular, height: 1.2),
                                        textStyleHighlight: AppTextStyle.PD(AppColor_Red, 16, weight: FW.medium, height: 1.2),
                                      ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
              Container(
                padding: const EdgeInsets.all(30),
                child: MainTextButton(
                  text: (widget.score >= 3 && widget.score <= 7) ? LanguageService.trans("answer_additional") : LanguageService.trans("go_home"),
                  backgroundColor: AppColor_Primary,
                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                  radius: 16,
                  height: 66,
                  onPressed: () {
                    eventBus.fire(SelectChildEvent());
                    Navigator.pop(context);
                    widget.onTap(widget.score);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
