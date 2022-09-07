import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:substring_highlight/substring_highlight.dart';

class CustomInspectionFinalPage extends StatefulWidget {
  final int score;

  const CustomInspectionFinalPage({Key? key, required this.score}) : super(key: key);

  @override
  CustomInspectionFinalPageState createState() => CustomInspectionFinalPageState();
}

class CustomInspectionFinalPageState extends BaseState<CustomInspectionFinalPage> with TickerProviderStateMixin {
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
                  child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          SizedBox(width: screenSize.width, child: H22(text: LanguageService.trans("inspection_title"), align: TextAlign.left)),
                          const SizedBox(height: 10),
                          SizedBox(width: screenSize.width, child: H22(text: LanguageService.trans("response_answer_result"), align: TextAlign.left)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Visibility(
                        visible: widget.score == 0,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset('assets/Path 12612.png', width: 80),
                                Positioned(
                                  left: 23,
                                  top: 22,
                                  child: H18(
                                    text: "${widget.score}점",
                                    color: AppColor_Primary,
                                    weight: FW.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Image.asset(
                              'assets/ic_inspection.png',
                              width: 342,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(height: 120),
                            H18(text: LanguageService.trans("autism_check_result"), weight: FW.semi_bold, align: TextAlign.center, maxLine: 2),
                            SizedBox(height: 40),
                          ],
                        )),
                    Visibility(
                      visible: widget.score > 0,
                      child: Column(
                        children: [
                          RangeShow(
                              start: LanguageService.trans('low_level_danger'),
                              end: LanguageService.trans('high_level_danger'),
                              rate: (widget.score * 100.0 / 20.0),
                              unit: "",
                              cur_value: widget.score.toDouble(),
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
                                            text: "3-7점 중간위험.\n추적 관찰 문항 을 실시하세요.\n반드시 추가 검사가 필요합니다. 추가문항 응답 후 최종 응답결과도 중간위험일 경우\n소아청소년정신과 전문의와 상담이 필요합니다.",
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
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: MainTextButton(
                        text: LanguageService.trans("go_home"),
                        backgroundColor: AppColor_Primary,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        radius: 16,
                        height: 66,
                        onPressed: () {
                          eventBus.fire(SelectChildEvent());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ));
  }

  Widget _buildTabHeaderItem(int step) {
    print(step);
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
              Positioned(right: 0, child: H12(text: LanguageService.trans("additional_questions"), color: step >= 2 ? AppColor_Primary : AppColor_Gray))
            ]),
          ],
        ));
  }
}
