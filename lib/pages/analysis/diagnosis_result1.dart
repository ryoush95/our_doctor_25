import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/free_test_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/h40_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/home/bmi_bar.dart';
import 'package:ourdoctor/pages/home/bmi_bar1.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

class DiagnosisResult1Page extends StatefulWidget {
  DiagnosisResult1Page({Key? key, required this.data, this.dadHeight = "", this.momHeight = "", this.childHeight = "", this.childWeight = ""}) : super(key: key);

  // String? snsid;
  // String? type;
  // String? alarm;
  FreeTtestDto? data;
  String? dadHeight;
  String? momHeight;
  String? childHeight;
  String? childWeight;

  @override
  DiagnosisResult1PageState createState() => DiagnosisResult1PageState();
}

class DiagnosisResult1PageState extends BaseState<DiagnosisResult1Page> {
  // final HttpService httpService = HttpService();

  final tooltip = GlobalKey();

  void showMoreText(String msg) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(
      context,
      text: msg,
      textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
      height: 87,
      width: 220,
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: BorderRadius.circular(0.0),
      onDismiss: () {},
    );
    popup.show(
      widgetKey: tooltip,
    );
  }

  final tooltip1 = GlobalKey();

  void showMoreText1(String msg) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(
      context,
      text: msg,
      textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
      height: 60,
      width: 200,
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: BorderRadius.circular(0.0),
      onDismiss: () {},
    );
    popup.show(
      widgetKey: tooltip1,
    );
  }

  final tooltip2 = GlobalKey();

  void showMoreText2(String msg) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(
      context,
      text: msg,
      textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
      height: 60,
      width: 200,
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: BorderRadius.circular(0.0),
      onDismiss: () {},
    );
    popup.show(
      widgetKey: tooltip2,
    );
  }

  final tooltip3 = GlobalKey();

  void showMoreText3(String msg) {
    ShowMoreTextPopup popup =
        ShowMoreTextPopup(context, text: msg, textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(0.0), onDismiss: () {});
    popup.show(
      widgetKey: tooltip3,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void goNext() {
    Navigator.push(context, SlideRightTransRoute(builder: (context) => FirstPage(dadHeight: widget.dadHeight, momHeight: widget.momHeight, childHeight: widget.childHeight, childWeight: widget.childWeight)));
    // if (isChildren) {
    //   SignupInfo info = SignupInfo(id, pwd, name, birth, gender, hosiptalId, phone, date, address1, address2, address3, widget.alarm!, widget.type!);
    //   Navigator.push(context, SlideRightTransRoute(builder: (context) => AddChildrenpPage(info: info)));
    // } else {
    //   reqSignup();
    // }
  }

  Color getStatusColor(String status) {
    if (status == "Y") {
      return const Color(0xFFFFCE20);
    } else if (status == "R") {
      return const Color(0xFFFF3838);
    } else {
      return const Color(0xFF4B9EFF);
    }
  }

  String getWeightStatus(WEIGHT info) {
    String result = "";
    String status = info.diagnose!.color!;
    double diff = double.parse(info.curValue!) - info.predict!.toDouble();
    diff = diff.abs();
    if (status == "Y") {
      result = "-" + diff.toStringAsFixed(2) + "kg";
    } else if (status == "R") {
      result = diff.toStringAsFixed(2) + "kg";
    } else {
      result = "정상 범주";
    }
    return result;
  }

  String getWeightContent(String result) {
    if (result.contains("저체중")) {
      return "체중부족";
    } else if (result.contains("과체중")) {
      return "체중과다";
    } else {
      return "정상체중";
    }
  }

  _launchURL(String _url) async {
    try {
      await launch(_url);
    } catch (err) {
      showToast(err.toString());
    }
    // await launch(_url);
    // if (await canLaunch(_url)) {
    //   await launch(_url);
    // } else {
    //   throw 'Could not launch $_url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(
                    height: 62,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            onBackPressed();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            height: 62,
                            padding: const EdgeInsets.only(left: 30, right: 10),
                            child: Image.asset(
                              'assets/path_12225.png',
                              width: 10,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                            child: Center(
                              child: H18(
                                text: "1분 간편 체크 결과",
                                weight: FW.medium,
                                height: 1.2,
                                color: AppColor_BlackText,
                                maxLine: 2,
                              ),
                            ),
                          ),
                        const SizedBox(width: 30),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            H18(
                              text: LanguageService.trans("diagnosis_result_title"),
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              H18(
                                text: LanguageService.trans("diagnosis_result_title1"),
                              ),
                              const SizedBox(width: 3),
                              Image.asset('assets/ic_daily_monitoring.png', width: 18),
                            ]),
                            const SizedBox(height: 50),
                            H16(
                              text: LanguageService.trans("height"),
                            ),
                            const SizedBox(height: 20),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              H18(
                                text: LanguageService.trans("my_child_future_prediction_key"),
                                weight: FW.regular,
                              ),
                              const SizedBox(width: 3),
                              InkWell(
                                onTap: () {
                                  showMoreText("부모의 신장으로 예측한 우리아이의\n미래 예측키로써 영양상태 및\n각종 외부환경 영향으로 변경될 수\n있습니다.");
                                },
                                child: Container(
                                  key: tooltip,
                                  child: Image.asset(
                                    'assets/question_mark_black_24dp.png',
                                    width: 24,
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 6),
                            Center(child: H40B(text: sprintf("%s %s", [widget.data!.hEIGHT!.predict!.toStringAsFixed(1), "cm"]), color: AppColor_BlackText.withOpacity(0.8))),
                            const SizedBox(height: 35),
                            BMIBar1(
                              weight: double.parse(widget.data!.hEIGHT!.curValue!),
                              res: widget.data!.hEIGHT!.diagnose!.color! == "Y" ? 0 : (widget.data!.hEIGHT!.diagnose!.color! == "R" ? 2 : 1),
                              color: getStatusColor(widget.data!.hEIGHT!.diagnose!.color!),
                              text: widget.data!.hEIGHT!.diagnose!.result!,
                              subtext: widget.data!.hEIGHT!.diagnose!.result!.contains("정상") ? "" : (widget.data!.hEIGHT!.diff! >= 0 ? "+" : "") + convertScore(widget.data!.hEIGHT!.diff!.toStringAsFixed(1)) + "cm",
                            ),
                            const SizedBox(height: 35),
                            Divider(height: 1, color: AppColor_BlackText.withOpacity(0.2)),
                            const SizedBox(height: 30),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              H18(
                                text: getChildAge(widget.data!.ageMonth!) + (widget.data!.gender == "1" ? LanguageService.trans("age_under1_percent") : LanguageService.trans("age_under_percent")),
                                weight: FW.regular,
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  showMoreText1("보건복지부 및 대한소아과학회\n소아청소년 성장도표 기준");
                                },
                                child: Container(
                                  key: tooltip1,
                                  child: Image.asset(
                                    'assets/question_mark_black_24dp.png',
                                    width: 24,
                                  ),
                                ),
                              ),
                            ]),
                            RangeShow(
                              start: widget.data!.hEIGHT!.min!.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), ''),
                              end: widget.data!.hEIGHT!.max!.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), ''),
                              rate: widget.data!.hEIGHT!.percent!,
                              unit: "cm",
                              cur_value: double.parse(widget.data!.hEIGHT!.curValue!),
                              color: getStatusColor(widget.data!.hEIGHT!.diagnose!.color!),
                            ),
                            const SizedBox(height: 30),
                            Container(
                                decoration: const BoxDecoration(color: Colors.white),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      H18(text: widget.data!.hEIGHT!.diagnose!.result!),
                                      const SizedBox(height: 20),
                                      widget.data!.hEIGHT!.diagnose!.color! == "R"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon4.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon2.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon3.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      widget.data!.hEIGHT!.diagnose!.color! == "Y"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon1.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon5.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon3.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      widget.data!.hEIGHT!.diagnose!.color! == "B"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon1.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon2.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon6.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(height: 20),
                                      // height_estimation == 2 ? H16(text: LanguageService.trans("minute_height_comment1"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      // height_estimation == 1 ? H16(text: LanguageService.trans("minute_height_comment2"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      // height_estimation == 4 ? H16(text: LanguageService.trans("minute_height_comment4"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      // height_estimation == 3 ? H16(text: LanguageService.trans("minute_height_comment3"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      H16(
                                        text: widget.data!.hEIGHT!.diagnose!.comment!,
                                        weight: FW.regular,
                                        height: 1.6,
                                        color: AppColor_Result_Text,
                                        maxLine: 15,
                                        align: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 55),
                            H20(
                              text: LanguageService.trans("weight"),
                            ),
                            const SizedBox(height: 25),
                            BMIBar(
                              type: 1,
                              weight: widget.data!.wEIGHT!.predict!,
                              res: int.parse(widget.data!.wEIGHT!.diagnose!.value!),
                              color: getStatusColor(widget.data!.wEIGHT!.diagnose!.color!),
                              text: getWeightContent(widget.data!.wEIGHT!.diagnose!.result!),
                              subtext: widget.data!.wEIGHT!.diagnose!.result!.contains("정상") ? "" : (widget.data!.wEIGHT!.diff! >= 0 ? "+" : "") + convertScore(widget.data!.wEIGHT!.diff!.toStringAsFixed(2)) + "kg",
                              tiptext: "BMI는 체질량 지수를의미합니다. (kg/m2)",
                            ),
                            // weight_estimation == 1 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 0, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            // weight_estimation == 2 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 1, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString())) : const SizedBox(),
                            // weight_estimation == 3 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 2, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString())) : const SizedBox(),
                            // weight_estimation == 4 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 3, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString())) : const SizedBox(),
                            // weight_estimation == 5 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 4, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            // weight_estimation == 6 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 4, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            // weight_estimation == 7 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 4, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            const SizedBox(height: 30),
                            Divider(height: 1, color: AppColor_BlackText.withOpacity(0.2)),
                            const SizedBox(height: 30),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              H18(
                                text: getChildAge(widget.data!.ageMonth!) + (widget.data!.gender == "1" ? LanguageService.trans("age_under1_percent") : LanguageService.trans("age_under_percent")),
                                weight: FW.regular,
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  showMoreText2("보건복지부 및 대한소아과학회\n소아청소년 성장도표 기준");
                                },
                                child: Container(
                                  key: tooltip2,
                                  child: Image.asset(
                                    'assets/question_mark_black_24dp.png',
                                    width: 24,
                                  ),
                                ),
                              ),
                            ]),
                            RangeShow(
                              start: widget.data!.wEIGHT!.min!.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), ''),
                              end: widget.data!.wEIGHT!.max!.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), ''),
                              rate: widget.data!.wEIGHT!.percent!,
                              unit: "kg",
                              cur_value: double.parse(widget.data!.wEIGHT!.curValue!),
                              color: getStatusColor(widget.data!.wEIGHT!.diagnose!.color!),
                            ),
                            const SizedBox(height: 30),
                            Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      H18(text: widget.data!.wEIGHT!.diagnose!.result!),
                                      const SizedBox(height: 20),
                                      widget.data!.wEIGHT!.diagnose!.color! == "R"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon4.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon2.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon3.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      widget.data!.wEIGHT!.diagnose!.color! == "Y"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon1.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon5.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon3.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      widget.data!.wEIGHT!.diagnose!.color! == "B"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon1.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon2.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon6.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(height: 20),
                                      H16(
                                        text: widget.data!.wEIGHT!.diagnose!.comment!,
                                        weight: FW.regular,
                                        height: 1.6,
                                        color: AppColor_Result_Text, maxLine: 15,
                                        align: TextAlign.justify,
                                      )
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 60),
                            H20(
                              text: LanguageService.trans("sleep"),
                            ),
                            const SizedBox(height: 25),
                            widget.data!.sLEEP!.diagnose!.result! == "부족"
                                ? BMIBar(
                                    type: 2,
                                    weight: widget.data!.sLEEP!.predict!,
                                    color: getValueColor(2),
                                    res: 1,
                                    text: widget.data!.sLEEP!.diagnose!.result!,
                                    subtext: "-" + widget.data!.sLEEP!.percent!.toStringAsFixed(1) + LanguageService.trans('hour'),
                                  )
                                : BMIBar(
                                    type: 2,
                                    weight: widget.data!.sLEEP!.predict!,
                                    color: getValueColor(3),
                                    res: 2,
                                    text: widget.data!.sLEEP!.diagnose!.result!,
                                    subtext: "", //sleep_hint, 정상범주
                                  ),
                            const SizedBox(height: 30),
                            Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      H18(
                                        text: widget.data!.sLEEP!.diagnose!.result! == "부족" ? "수면시간이 부족해요. 😞" : "수면시간이 충분해요. 😊",
                                        maxLine: 2,
                                        height: 1.2,
                                      ),
                                      const SizedBox(height: 20),
                                      widget.data!.sLEEP!.diagnose!.result! == "부족"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon4.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon3.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      widget.data!.sLEEP!.diagnose!.result! != "부족"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon1.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon6.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(height: 20),
                                      H16(
                                        text: widget.data!.sLEEP!.diagnose!.comment!,
                                        weight: FW.regular,
                                        height: 1.6,
                                        color: AppColor_Result_Text,
                                        maxLine: 15,
                                        align: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 52),
                            InkWell(
                              onTap: () {
                                _launchURL(DATEBOOK_URL);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  height: 58,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: AppColor_BlackText.withOpacity(0.2),
                                        width: 1,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/ic_databook.png', height: 20, width: 20),
                                      const SizedBox(width: 5),
                                      H18(
                                        text: "발달리포트 자료집",
                                        weight: FW.semi_bold,
                                        height: 1.5,
                                        color: AppColor_BlackText,
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: MainTextButton(
                                text: LanguageService.trans("sign_up"),
                                backgroundColor: AppColor_Primary,
                                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                                width: MediaQuery.of(context).size.width - 60,
                                //disable: !isValid,
                                radius: 8,
                                //disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                                onPressed: () {
                                  goNext();
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Center(child: H14(text: LanguageService.trans("minute_hint"), color: AppColor_GrayText, maxLine: 2, height: 1.4, weight: FW.regular)),
                      ),
                      const SizedBox(height: 80),
                      // 노션 5-37 배너삭제
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: (MediaQuery.of(context).size.width * 1170) / 1218,
                      //   child: Stack(
                      //     children: [
                      //       Image.asset(
                      //         'assets/bg_result.png',
                      //         width: MediaQuery.of(context).size.width,
                      //         height: (MediaQuery.of(context).size.width * 1170) / 1218,
                      //         fit: BoxFit.cover,
                      //       ),
                      //       Container(
                      //         padding: const EdgeInsets.only(top: 60.0, left: 32.0, right: 20.0,),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             H22(
                      //               text: LanguageService.trans("monitorint_result1"),
                      //               color: AppColor_White,
                      //               maxLine: 2,
                      //               height: 1.4,
                      //               align: TextAlign.left,
                      //               weight: FW.bold,
                      //             ),
                      //             const SizedBox(height: 12),
                      //             H18(
                      //               text: LanguageService.trans("monitorint_result2"),
                      //               color: AppColor_White,
                      //               maxLine: 2,
                      //               align: TextAlign.left,
                      //               weight: FW.semi_bold,
                      //             ),
                      //             const SizedBox(height: 92),
                      //             Wrap(
                      //               crossAxisAlignment: WrapCrossAlignment.start,
                      //               children:  [...List.generate(3, (int idx) => monitorint_result3_text(
                      //                 LanguageService.trans("monitorint_result3-${idx+1}")
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 133,
                      //   color: AppColor_BlackText.withOpacity(0.8),
                      //   padding: const EdgeInsets.only(left: 32.0, right: 28.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: Container(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               H16(
                      //                 text: LanguageService.trans("monitorint_result4"),
                      //                 color: AppColor_White,
                      //                 maxLine: 1,
                      //                 align: TextAlign.left,
                      //                 weight: FW.bold,
                      //               ),
                      //               const SizedBox(height: 5),
                      //               H16(
                      //                 text: LanguageService.trans("monitorint_result5"),
                      //                 color: AppColor_White,
                      //                 maxLine: 1,
                      //                 align: TextAlign.left,
                      //                 weight: FW.regular,
                      //               ),
                      //               const SizedBox(height: 13),
                      //               H12(
                      //                 text: LanguageService.trans("monitorint_result6"),
                      //                 color: AppColor_White,
                      //                 maxLine: 2,
                      //                 height: 1.4,
                      //                 align: TextAlign.left,
                      //                 weight: FW.regular,
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       Image.asset(
                      //         'assets/ic_ad.png',
                      //         width: 89,
                      //         height: 89,
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )),
                ),
              ],
            )));
  }

monitorint_result3_text(String text) => Container(
  margin: const EdgeInsets.only(top: 12),
  child: H14(
      text: text,
      color: AppColor_White,
      maxLine: 1,
      align: TextAlign.left,
      weight: FW.medium,
    ),
  );

   // H16(
                                  //   text: LanguageService.trans("monitorint_result3"),
                                  //   color: AppColor_White,
                                  //   maxLine: 4,
                                  //   height: 1.4,
                                  //   align: TextAlign.justify,
                                  //   weight: FW.medium,
                                  // ),
}
