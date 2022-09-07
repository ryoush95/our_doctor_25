import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/analysis/diagnosis_main.dart';
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
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:sprintf/sprintf.dart';

class DiagnosisResultPage extends StatefulWidget {
  DiagnosisResultPage({Key? key, required this.data}) : super(key: key);
  // String? snsid;
  // String? type;
  // String? alarm;
  FreeDiagnosis? data;
  @override
  DiagnosisResultPageState createState() => DiagnosisResultPageState();
}

class DiagnosisResultPageState extends BaseState<DiagnosisResultPage> {
  // final HttpService httpService = HttpService();

  int height_min = 83;
  int height_max = 110;
  int weight_min = 30;
  int weight_max = 48;
  double sleep_min = 0;
  double sleep_max = 0;

  int predict_height = 0;
  int year_old = 0;
  int height_percent = 0;
  int height_estimation = 0;

  int sleep_estimation = 0;
  double sleep_diff = 0;
  int sleep_time = 0;
  String sleep_hint = "";

  int weight_percent = 0;
  int weight_estimation = 0;
  String weight_hint = "";
  Color height_color = AppColor_Primary;
  Color weight_color = AppColor_Primary;

  @override
  void initState() {
    super.initState();
    predict();
  }

  void predict() {
    if (widget.data!.gender == 1)
      predict_height = ((widget.data!.dad_height! + widget.data!.mom_kidney! + 13) / 2).toInt();
    else
      predict_height = ((widget.data!.dad_height! + widget.data!.mom_kidney! - 13) / 2).toInt();

    int year = DateTime.now().year;
    year_old = year - int.parse(widget.data!.birth_date!.split("-")[0]);
    height_percent = ((widget.data!.child_height! - height_min) / (height_max - height_min) * 100).toInt();
    height_percent = height_percent < 1 ? 1 : height_percent;
    height_percent = height_percent > 100 ? 100 : height_percent;
    if (height_percent < 3)
      height_estimation = 2;
    else if (height_percent < 25)
      height_estimation = 1;
    else if (height_percent < 75)
      height_estimation = 3;
    else
      height_estimation = 4;
    if (height_estimation == 4)
      height_color = getValueColor(1);
    else
      height_color = getValueColor(height_estimation);

    double t1 = widget.data!.child_weight! - weight_min;
    if (t1 < 0) {
      t1 = -t1;
      weight_hint = "-";
      weight_hint += t1.toString();
      weight_hint += " kg";
    }
    double t2 = widget.data!.child_weight! - weight_max;
    if (t2 > 0) {
      weight_hint = "+";
      weight_hint += t2.toString();
      weight_hint += " kg";
    }
    weight_percent = ((widget.data!.child_weight! - weight_min) / (weight_max - weight_min) * 100).toInt();
    weight_percent = weight_percent < 1 ? 1 : weight_percent;
    weight_percent = weight_percent > 100 ? 100 : weight_percent;
    if (year_old < 2) {
      if (weight_percent < 5)
        weight_estimation = 1;
      else if (weight_percent < 25)
        weight_estimation = 2;
      else if (weight_percent < 75)
        weight_estimation = 3;
      else if (weight_percent < 95)
        weight_estimation = 4;
      else
        weight_estimation = 5;
    } else {
      if (weight_percent < 5)
        weight_estimation = 1;
      else if (weight_percent < 25)
        weight_estimation = 2;
      else if (weight_percent < 85)
        weight_estimation = 3;
      else if (weight_percent < 95)
        weight_estimation = 6;
      else
        weight_estimation = 7;
    }
    if (weight_estimation == 1 || weight_estimation == 5 || weight_estimation == 6 || weight_estimation == 7)
      weight_color = getValueColor(2);
    else if (weight_estimation == 2 || weight_estimation == 4)
      weight_color = getValueColor(1);
    else
      weight_color = getValueColor(3);

    sleep_time = widget.data!.sleep_night! + widget.data!.sleep_launch!;
    int diffDays = 0;
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String curDate = dateFormat.format(now);

    DateTime date1 = dateFormat.parse(widget.data!.birth_date!);
    DateTime date2 = dateFormat.parse(curDate);
    diffDays = date2.difference(date1).inDays;
    int diffMonths = (diffDays / 30).toInt();
    int diffYears = (diffMonths / 12).toInt();
    if (diffMonths <= 12) {
      sleep_min = 14;
      sleep_max = 15;
    } else if (diffMonths <= 36) {
      sleep_min = 12;
      sleep_max = 14;
    } else if (diffYears <= 6) {
      sleep_min = 11;
      sleep_max = 13;
    } else if (diffYears <= 12) {
      sleep_min = 10;
      sleep_max = 11;
    } else if (diffYears <= 18) {
      sleep_min = 8.5;
      sleep_max = 9.5;
    } else {
      sleep_min = 7.5;
      sleep_max = 7.5;
    }
    sleep_estimation = 2;
    if (sleep_min > sleep_time) {
      sleep_estimation = 1;
      sleep_diff = sleep_time.toDouble() - sleep_min;
    } else if (sleep_max < sleep_time) sleep_diff = sleep_time.toDouble() - sleep_max;
    if (sleep_diff > 0) {
      sleep_hint = "+";
      sleep_hint += sleep_diff.toInt().toString();
      sleep_hint += "hour";
    } else if (sleep_diff < 0) {
      sleep_hint = "-";
      sleep_hint += (-sleep_diff).toInt().toString();
      sleep_hint += "hour";
    }
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
    Navigator.push(context, SlideRightTransRoute(builder: (context) => FirstPage()));
    // if (isChildren) {
    //   SignupInfo info = SignupInfo(id, pwd, name, birth, gender, hosiptalId, phone, date, address1, address2, address3, widget.alarm!, widget.type!);
    //   Navigator.push(context, SlideRightTransRoute(builder: (context) => AddChildrenpPage(info: info)));
    // } else {
    //   reqSignup();
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
                      children: [
                        const SizedBox(width: 30),
                        InkWell(
                          onTap: () {
                            onBackPressed();
                          },
                          child: Image.asset(
                            'assets/path_12225.png',
                            width: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: H18(
                                text: LanguageService.trans("1_minute_free_diagnostic_results"),
                                weight: FW.medium,
                                height: 1.2,
                                color: AppColor_BlackText,
                                maxLine: 2,
                              ),
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
                            H24B(
                              text: LanguageService.trans("diagnosis_result_title"),
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              H24B(
                                text: LanguageService.trans("diagnosis_result_title1"),
                              ),
                              const SizedBox(width: 3),
                              Image.asset('assets/ic_daily_monitoring.png', width: 25),
                            ]),
                            const SizedBox(height: 50),
                            H20(
                              text: LanguageService.trans("height"),
                            ),
                            const SizedBox(height: 20),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              H18(
                                text: LanguageService.trans("my_child_future_prediction_key"),
                                weight: FW.regular,
                              ),
                              const SizedBox(width: 3),
                              Image.asset('assets/question_mark_black_24dp.png', width: 24),
                            ]),
                            const SizedBox(height: 6),
                            Center(child: H40B(text: sprintf("%d %s", [predict_height, "cm"]), color: AppColor_Primary)),
                            const SizedBox(height: 35),
                            Divider(height: 1, color: AppColor_BlackText.withOpacity(0.2)),
                            const SizedBox(height: 30),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              H18(
                                text: year_old.toString() + LanguageService.trans("age_under_percent"),
                                weight: FW.regular,
                              ),
                              const SizedBox(width: 10),
                              Image.asset('assets/question_mark_black_24dp.png', width: 24),
                            ]),
                            RangeShow(start: height_min.toString(), end: height_max.toString(), rate: 50, unit: "cm", cur_value: widget.data!.child_height!.toDouble(), color: height_color),
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
                                      H18(text: LanguageService.trans("medical_short_stature")),
                                      const SizedBox(height: 20),
                                      height_estimation == 2
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
                                      height_estimation == 1 || height_estimation == 4
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
                                      height_estimation == 3
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
                                      height_estimation == 2 ? H16(text: LanguageService.trans("minute_height_comment1"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      height_estimation == 1 ? H16(text: LanguageService.trans("minute_height_comment2"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      height_estimation == 4 ? H16(text: LanguageService.trans("minute_height_comment4"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                      height_estimation == 3 ? H16(text: LanguageService.trans("minute_height_comment3"), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6) : const SizedBox(),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 55),
                            H20(
                              text: LanguageService.trans("weight"),
                            ),
                            const SizedBox(height: 25),
                            weight_estimation == 1 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 0, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            weight_estimation == 2 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 1, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString())) : const SizedBox(),
                            weight_estimation == 3 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 2, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString())) : const SizedBox(),
                            weight_estimation == 4 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 3, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString())) : const SizedBox(),
                            weight_estimation == 5 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 4, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            weight_estimation == 6 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 4, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            weight_estimation == 7 ? BMIBar(type: 1, weight: widget.data!.child_weight!, res: 4, color: weight_color, text: LanguageService.trans("minute_weight_category" + weight_estimation.toString()), subtext: weight_hint) : const SizedBox(),
                            const SizedBox(height: 30),
                            Divider(height: 1, color: AppColor_BlackText.withOpacity(0.2)),
                            const SizedBox(height: 30),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              H18(
                                text: year_old.toString() + LanguageService.trans("age_under_percent"),
                                weight: FW.regular,
                              ),
                              const SizedBox(width: 10),
                              Image.asset('assets/question_mark_black_24dp.png', width: 24),
                            ]),
                            RangeShow(start: weight_min.toString(), end: weight_max.toString(), rate: 50, unit: "kg", cur_value: widget.data!.child_weight!.toInt().toDouble(), color: weight_color),
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
                                      H18(text: LanguageService.trans("minute_weight_title" + height_estimation.toString())),
                                      const SizedBox(height: 20),
                                      weight_estimation == 1 || weight_estimation == 5 || weight_estimation == 6 || weight_estimation == 7
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
                                      weight_estimation == 2 || weight_estimation == 4
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
                                      weight_estimation == 3
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
                                      H16(text: LanguageService.trans("minute_weight_comment" + weight_estimation.toString()), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6)
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 60),
                            H20(
                              text: LanguageService.trans("sleep"),
                            ),
                            const SizedBox(height: 25),
                            sleep_diff < 0
                                ? BMIBar(
                                    type: 2,
                                    weight: sleep_time.toDouble(),
                                    color: getValueColor(2),
                                    res: 0,
                                    text: LanguageService.trans("lack"),
                                    subtext: sleep_hint,
                                  )
                                : BMIBar(type: 2, weight: sleep_time.toDouble(), color: getValueColor(3), res: 1, text: LanguageService.trans("enough"), subtext: sleep_hint),
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
                                      H18(text: LanguageService.trans("minute_sleep_title" + sleep_estimation.toString())),
                                      const SizedBox(height: 20),
                                      sleep_estimation == 1
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset('assets/icon4.png', width: 60),
                                                const SizedBox(width: 10),
                                                Image.asset('assets/icon3.png', width: 60),
                                              ],
                                            )
                                          : const SizedBox(),
                                      sleep_estimation == 2
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
                                      H16(text: LanguageService.trans("minute_sleep_comment" + sleep_estimation.toString()), weight: FW.regular, height: 1.6, color: AppColor_Result_Text, maxLine: 6)
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 30),
                            Center(
                              child: MainTextButton(
                                text: LanguageService.trans("sign_up"),
                                backgroundColor: AppColor_Primary,
                                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                                width: MediaQuery.of(context).size.width - 60,
                                //disable: !isValid,
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.width * 1170) / 1218,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/bg_result.png',
                              width: MediaQuery.of(context).size.width,
                              height: (MediaQuery.of(context).size.width * 1170) / 1218,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 60.0, left: 32.0, right: 32.0, bottom: 60.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H22(
                                    text: LanguageService.trans("monitorint_result1"),
                                    color: AppColor_White,
                                    maxLine: 2,
                                    height: 1.4,
                                    align: TextAlign.left,
                                    weight: FW.bold,
                                  ),
                                  const SizedBox(height: 12),
                                  H18(
                                    text: LanguageService.trans("monitorint_result2"),
                                    color: AppColor_White,
                                    maxLine: 2,
                                    align: TextAlign.left,
                                    weight: FW.semi_bold,
                                  ),
                                  Expanded(child: Container()),
                                  H16(
                                    text: LanguageService.trans("monitorint_result3"),
                                    color: AppColor_White,
                                    maxLine: 3,
                                    height: 1.4,
                                    align: TextAlign.left,
                                    weight: FW.medium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 133,
                        color: AppColor_BlackText.withOpacity(0.8),
                        padding: const EdgeInsets.only(left: 32.0, right: 28.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    H16(
                                      text: LanguageService.trans("monitorint_result4"),
                                      color: AppColor_White,
                                      maxLine: 1,
                                      align: TextAlign.left,
                                      weight: FW.bold,
                                    ),
                                    const SizedBox(height: 5),
                                    H16(
                                      text: LanguageService.trans("monitorint_result5"),
                                      color: AppColor_White,
                                      maxLine: 1,
                                      align: TextAlign.left,
                                      weight: FW.regular,
                                    ),
                                    const SizedBox(height: 13),
                                    H12(
                                      text: LanguageService.trans("monitorint_result6"),
                                      color: AppColor_White,
                                      maxLine: 2,
                                      height: 1.4,
                                      align: TextAlign.left,
                                      weight: FW.regular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/ic_ad.png',
                              width: 89,
                              height: 89,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            )));
  }
}
