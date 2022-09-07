import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/monitoring_result_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:ourdoctor/pages/tab_main.dart';
import 'package:substring_highlight/substring_highlight.dart';

class MonitoringResult1Page extends StatefulWidget {
  MonitoringResult1Page({Key? key, required this.uid}) : super(key: key);

  String? uid;
  @override
  MonitoringResult1PageState createState() => MonitoringResult1PageState();
}

class MonitoringResult1PageState extends BaseState<MonitoringResult1Page> {
  String userName = gSelChildInfo!.name!;
  final HttpService httpService = HttpService();

  var days = [
    LanguageService.trans('monday'),
    LanguageService.trans('tuesday'),
    LanguageService.trans('wednesday'),
    LanguageService.trans('thursday'),
    LanguageService.trans('friday'),
    LanguageService.trans('saturday'),
    LanguageService.trans('sunday'),
  ];
  var months = [
    LanguageService.trans('january'),
    LanguageService.trans('february'),
    LanguageService.trans('march'),
    LanguageService.trans('april'),
    LanguageService.trans('may'),
    LanguageService.trans('june'),
    LanguageService.trans('july'),
    LanguageService.trans('august'),
    LanguageService.trans('september'),
    LanguageService.trans('october'),
    LanguageService.trans('november'),
    LanguageService.trans('december'),
  ];
  var weekday = DateTime.now().weekday - 1;
  int month = DateTime.now().month - 1;
  String day = DateTime.now().day.toString();
  String noon = DateTime.now().hour > 12 ? LanguageService.trans("afternoon") : LanguageService.trans("morning");
  String dateStr = "";

  int curCategory = 0;
  int showRecord = -1;

  MonitorResultDto? dicInfo = MonitorResultDto();
  @override
  void initState() {
    super.initState();
    dateStr = months[month] + " " + day + "일 " + days[weekday] + "\n";
    getMonitoringResult();
    eventBus.fire(MonitoringFinishEvent());
  }

  void onChooseCategory(int index) {
    setState(() {
      curCategory = index;
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, widget.uid);
    return true;
  }

   String getLaunchTime(String time) {
    var temp = time.split(",")[0];
    if (temp == "") {
      return "낮잠 0시간";
    }
    int minute = int.parse(temp);
    int hour = minute ~/ 60;
    int min = minute % 60;

    if (min == 0 && minute < 420) {
      return "낮잠 " + hour.toString() + "시간";
    } else if(min != 0 && minute < 420){
      return "낮잠 " + hour.toString() + "시간 " + min.toString() + "분";
    } else {
      return "낮잠 " + hour.toString() + "시간 이상";
    }
  }

  String getNightTime(String time) {
    var temp = time.split(",")[1];
    if (temp == "") {
      return "밤잠 0시간";
    }
    int minute = int.parse(temp);
    int hour = minute ~/ 60;
    int min = minute % 60;

    if (min == 0 && minute < 780) {
      return "밤잠 " + hour.toString() + "시간";
    } else if(min != 0 && min < 780) {
      return "밤잠 " + hour.toString() + "시간 " + min.toString() + "분";
    } else {
      return "밤잠 " + hour.toString() + "시간 이상";
    }
  }

  String getKcalString(FoodDto info) {
    String result = "";
    if (info.breakfastKcal == "" || info.breakfastKcal == "0") {
      result = "아침";
    }

    if (info.launchKcal == "" || info.launchKcal == "0") {
      if (result == "") {
        result = "점심";
      } else {
        result = result + "," + "점심";
      }
    }

    if (info.snackKcal == "" || info.snackKcal == "0") {
      if (result == "") {
        result = "간식";
      } else {
        result = result + "," + "간식";
      }
    }

    if (info.dinnerKcal == "" || info.dinnerKcal == "0") {
      if (result == "") {
        result = "저녁";
      } else {
        result = result + "," + "저녁";
      }
    }

    if (result != "") {
      result = "(" + result + " " + "미입력)";
    }

    return result;
  }

  int getImgCnt() {
    if (dicInfo == null) {
      return 0;
    }
    //dicInfo!.sYMPTOM != null && dicInfo!.sYMPTOM!.data != null
    if (dicInfo!.sYMPTOM == null) {
      return 0;
    }

    if (dicInfo!.sYMPTOM!.data == null) {
      return 0;
    }

    int count = 0;
    for (int i = 0; i < dicInfo!.sYMPTOM!.data!.length; i++) {
      SymptomDto info = dicInfo!.sYMPTOM!.data!.elementAt(i);
      if (info.medicationUrl!.isNotEmpty) {
        count = count + 1;
      }
    }

    return count;
  }

  void goPhotoView() {
    if (getImgCnt() == 0) {
      return;
    }

    List<String> imgs = [];
    for (int i = 0; i < dicInfo!.sYMPTOM!.data!.length; i++) {
      SymptomDto info = dicInfo!.sYMPTOM!.data!.elementAt(i);
      if (info.medicationUrl!.isNotEmpty) {
        imgs.add(info.medicationUrl!);
      }
    }

    Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: imgs, type: 0)));
  }

  String showSymphtoName() {
    String result = "";
    if (dicInfo == null) {
      return result;
    }

    if (dicInfo!.sYMPTOM == null) {
      return result;
    }

    if (dicInfo!.sYMPTOM!.data == null) {
      return result;
    }

    List<String> names = [];
    for (int i = 0; i < dicInfo!.sYMPTOM!.data!.length; i++) {
      SymptomDto info = dicInfo!.sYMPTOM!.data!.elementAt(i);
      if (info.medicationUrl!.isNotEmpty) {
        names.add(info.symptom!);
      }
    }

    if (names.isNotEmpty) {
      if (names.length < 2) {
        result = names[0];
      } else {
        result = names[0] + " 외 " + (names.length - 1).toString();
      }
    }

    return result;
  }

  // Network functions
  //////////////////////////////////
  // 모니터링 일일결과 얻기
  void getMonitoringResult() {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String curDate = dateFormat.format(now);
    final HttpService httpService = HttpService();
    setState(() {
      isLoading = true;
    });
    Future<MonitoringResultResModel> info = httpService.monitoringResult(curDate);
    info.then((MonitoringResultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicInfo = value.data!;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
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
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleHeader(
                  title: "오늘의 진단",
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  H24B(
                                    text: dateStr + "일일 모니터링 결과",
                                    maxLine: 2,
                                    align: TextAlign.start,
                                    height: 1.2,
                                    color: AppColor_BlackText,
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                    'assets/ic_daily_monitoring.png',
                                    width: 20,
                                  )
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 31,
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H18(
                                  text: LanguageService.trans("check_out_result"),
                                  weight: FW.medium,
                                ),
                                Container(
                                    width: 130,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: AppColor_Table_Border),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            onChooseCategory(0);
                                          },
                                          child: Container(
                                              height: 25,
                                              width: 65,
                                              margin: const EdgeInsets.only(left: 0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(13),
                                                  boxShadow: [
                                                    curCategory == 0
                                                        ? const BoxShadow(
                                                            color: AppColor_Table_Border,
                                                            blurRadius: 4.0, // soften the shadow
                                                            spreadRadius: 2.0, //extend the shadow
                                                            offset: Offset(
                                                              3.0, // Move to right 10  horizontally
                                                              3.0, // Move to bottom 5 Vertically
                                                            ))
                                                        : const BoxShadow(
                                                            color: AppColor_Table_Border,
                                                            blurRadius: 0.0, // soften the shadow
                                                            spreadRadius: 0.0, //extend the shadow
                                                            offset: Offset(
                                                              0.0, // Move to right 10  horizontally
                                                              0.0, // Move to bottom 5 Vertically
                                                            ))
                                                  ],
                                                  color: curCategory == 0 ? Colors.white : AppColor_Table_Border),
                                              child: Center(
                                                child: H14(
                                                  text: LanguageService.trans("body"),
                                                  weight: FW.medium,
                                                  color: curCategory == 0 ? AppColor_Primary : AppColor_Table_DateTime,
                                                ),
                                              )),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            onChooseCategory(1);
                                          },
                                          child: Container(
                                              height: 25,
                                              width: 65,
                                              margin: const EdgeInsets.only(left: 0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(13),
                                                  boxShadow: [
                                                    curCategory == 1
                                                        ? const BoxShadow(
                                                            color: AppColor_Table_Border,
                                                            blurRadius: 4.0, // soften the shadow
                                                            spreadRadius: 2.0, //extend the shadow
                                                            offset: Offset(
                                                              3.0, // Move to right 10  horizontally
                                                              3.0, // Move to bottom 5 Vertically
                                                            ))
                                                        : const BoxShadow(
                                                            color: AppColor_Table_Border,
                                                            blurRadius: 0.0, // soften the shadow
                                                            spreadRadius: 0.0, //extend the shadow
                                                            offset: Offset(
                                                              0.0, // Move to right 10  horizontally
                                                              0.0, // Move to bottom 5 Vertically
                                                            ))
                                                  ],
                                                  color: curCategory == 1 ? Colors.white : AppColor_Table_Border),
                                              child: Center(
                                                child: H14(
                                                  text: LanguageService.trans("brains"),
                                                  weight: FW.medium,
                                                  color: curCategory == 1 ? AppColor_Primary : AppColor_Table_DateTime,
                                                ),
                                              )),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: SubstringHighlight(
                              text: userName + " 어린이 모니터링 결과",
                              term: userName,
                              textStyle: AppTextStyle.PD(AppColor_BlackText, 18, weight: FW.medium, height: 1.5),
                              textStyleHighlight: AppTextStyle.PD(AppColor_Primary, 18, weight: FW.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 3,
                            color: AppColor_BlackText,
                          ),
                          SizedBox(
                            height: 55,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 60) / 4,
                                  child: H14(
                                    text: "구분",
                                    color: AppColor_BlackText,
                                  ),
                                ),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                  child: H14(
                                    text: "기록",
                                    color: AppColor_BlackText,
                                  ),
                                ),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width - 60) / 4,
                                  child: H14(
                                    text: "결과",
                                    color: AppColor_BlackText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: AppColor_Selector_Border,
                          ),
                          Visibility(
                            visible: curCategory == 0,
                            child: Column(
                              children: [
                                //신장
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "신장",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  H14(
                                                    text: dicInfo!.hEIGHT == null ? "" : (dicInfo!.hEIGHT!.value.toString() + "cm"),
                                                    color: AppColor_BlackText,
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.hEIGHT != null && dicInfo!.hEIGHT!.difference != 0),
                                                    child: const SizedBox(
                                                      width: 4,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.hEIGHT != null && dicInfo!.hEIGHT!.difference != 0),
                                                    child: Image.asset(
                                                      dicInfo!.hEIGHT == null ? 'assets/ic_delete.png' : (dicInfo!.hEIGHT!.difference! > 0 ? 'assets/ic_blue_up.png' : 'assets/ic_red_down.png'),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.hEIGHT == null ? "" : convertDate(dicInfo!.hEIGHT!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.hEIGHT == null ? "" : dicInfo!.hEIGHT!.diagnose!.result!,
                                          maxLine: 2,
                                          color: dicInfo!.hEIGHT == null ? AppColor_BlackText : getColorFromString(dicInfo!.hEIGHT!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //체중
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "체중",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  H14(
                                                    text: dicInfo!.wEIGHT == null ? "" : (dicInfo!.wEIGHT!.value.toString() + "kg"),
                                                    color: AppColor_BlackText,
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.wEIGHT != null && dicInfo!.wEIGHT!.difference != 0),
                                                    child: const SizedBox(
                                                      width: 4,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.wEIGHT != null && dicInfo!.wEIGHT!.difference != 0),
                                                    child: Image.asset(
                                                      dicInfo!.wEIGHT == null ? 'assets/ic_delete.png' : (dicInfo!.wEIGHT!.difference! > 0 ? 'assets/ic_blue_up.png' : 'assets/ic_red_down.png'),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.wEIGHT == null ? "" : convertDate(dicInfo!.wEIGHT!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.wEIGHT == null ? "" : dicInfo!.wEIGHT!.diagnose!.result!,
                                          maxLine: 2,
                                          color: dicInfo!.wEIGHT == null ? AppColor_BlackText : getColorFromString(dicInfo!.wEIGHT!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //수면
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "수면",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  H14(
                                                    text: dicInfo!.sLEEP == null ? "" : getLaunchTime(dicInfo!.sLEEP!.value!),
                                                    color: AppColor_BlackText,
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.sLEEP != null && dicInfo!.sLEEP!.difference != 0),
                                                    child: const SizedBox(
                                                      width: 4,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.sLEEP != null && dicInfo!.sLEEP!.difference != 0),
                                                    child: Image.asset(
                                                      dicInfo!.sLEEP == null ? 'assets/ic_delete.png' : (dicInfo!.sLEEP!.difference! > 0 ? 'assets/ic_blue_up.png' : 'assets/ic_red_down.png'),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              H14(
                                                text: dicInfo!.sLEEP == null ? "" : getNightTime(dicInfo!.sLEEP!.value!),
                                                color: AppColor_BlackText,
                                              ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.sLEEP == null ? "" : convertDate(dicInfo!.sLEEP!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.sLEEP == null ? "" : dicInfo!.sLEEP!.diagnose!.result!,
                                          color: dicInfo!.sLEEP == null ? AppColor_BlackText : getColorFromString(dicInfo!.sLEEP!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //영양
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "영양",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  H14(
                                                    text: dicInfo!.fOOD == null ? "" : (dicInfo!.fOOD!.value.toString() + "Kcal"),
                                                    color: AppColor_BlackText,
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.fOOD != null && dicInfo!.fOOD!.difference != 0),
                                                    child: const SizedBox(
                                                      width: 4,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (dicInfo!.fOOD != null && dicInfo!.fOOD!.difference != 0),
                                                    child: Image.asset(
                                                      dicInfo!.fOOD == null ? 'assets/ic_delete.png' : (dicInfo!.fOOD!.difference! > 0 ? 'assets/ic_blue_up.png' : 'assets/ic_red_down.png'),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Visibility(
                                              //   visible: dicInfo!.fOOD != null,
                                              //   child: const SizedBox(height: 3),
                                              // ),
                                              // Visibility(
                                              //   visible: dicInfo!.fOOD != null,
                                              //   child: H14(
                                              //     text: dicInfo!.fOOD == null ? "" : getKcalString(dicInfo!.fOOD!.data!),
                                              //     color: AppColor_BlackText.withOpacity(0.3),
                                              //   ),
                                              // ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.fOOD == null ? "" : convertDate(dicInfo!.fOOD!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.fOOD == null ? "" : dicInfo!.fOOD!.diagnose!.result!,
                                          color: dicInfo!.fOOD == null ? AppColor_BlackText : getColorFromString(dicInfo!.fOOD!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //질병
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4,
                                          child: InkWell(
                                            onTap: () {
                                              goPhotoView();
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                H14(
                                                  text: "질병",
                                                  color: AppColor_BlackText,
                                                ),
                                                Visibility(
                                                  visible: getImgCnt() > 0,
                                                  child: Container(width: 5),
                                                ),
                                                Visibility(
                                                  visible: getImgCnt() > 0,
                                                  child: Image.asset(
                                                    'assets/ic_search.png',
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                        child: H14(
                                          text: dicInfo!.sYMPTOM == null ? "없음" : showSymphtoName(),
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.sYMPTOM == null ? "" : dicInfo!.sYMPTOM!.diagnose!.result!,
                                          color: dicInfo!.sYMPTOM == null ? AppColor_BlackText : getColorFromString(dicInfo!.sYMPTOM!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: curCategory == 1,
                            child: Column(
                              children: [
                                //언어
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "언어",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              H14(
                                                text: dicInfo!.lANGUAGE == null ? "" : dicInfo!.lANGUAGE!.value.toString(),
                                                color: AppColor_BlackText,
                                              ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.lANGUAGE == null ? "" : convertDate(dicInfo!.lANGUAGE!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.lANGUAGE == null ? "" : dicInfo!.lANGUAGE!.diagnose!.result!,
                                          color: dicInfo!.lANGUAGE == null ? AppColor_BlackText : getColorFromString(dicInfo!.lANGUAGE!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //사회성
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "사회성",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              H14(
                                                text: dicInfo!.sOCIAL == null ? "" : dicInfo!.sOCIAL!.value.toString(),
                                                color: AppColor_BlackText,
                                              ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.sOCIAL == null ? "" : convertDate(dicInfo!.sOCIAL!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.sOCIAL == null ? "" : dicInfo!.sOCIAL!.diagnose!.result!,
                                          color: dicInfo!.sOCIAL == null ? AppColor_BlackText : getColorFromString(dicInfo!.sOCIAL!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //운동
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: "운동",
                                          color: AppColor_BlackText,
                                        ),
                                      ),
                                      SizedBox(
                                          width: (MediaQuery.of(context).size.width - 60) / 4 * 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              H14(
                                                text: dicInfo!.wORKOUT == null ? "" : dicInfo!.wORKOUT!.value.toString(),
                                                color: AppColor_BlackText,
                                              ),
                                              const SizedBox(height: 3),
                                              H12(
                                                text: dicInfo!.wORKOUT == null ? "" : convertDate(dicInfo!.wORKOUT!.inputTime!),
                                                weight: FW.medium,
                                                color: AppColor_BlackText.withOpacity(0.3),
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width - 60) / 4,
                                        child: H14(
                                          text: dicInfo!.wORKOUT == null ? "" : dicInfo!.wORKOUT!.diagnose!.result!,
                                          color: dicInfo!.wORKOUT == null ? AppColor_BlackText : getColorFromString(dicInfo!.wORKOUT!.diagnose!.color!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 3,
                            color: AppColor_BlackText,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context, widget.uid);
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 66) / 2,
                                  height: 58,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: AppColor_f4f5f7),
                                  child: Center(
                                    child: H18(
                                      text: "재입력",
                                      color: AppColor_BlackText,
                                      weight: FW.semi_bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => TabMainPage(pageIdx: 2, infoTabIdx: curCategory)));
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 66) / 2,
                                  height: 58,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: AppColor_Primary.withOpacity(0.1)),
                                  child: Center(
                                    child: H18(
                                      text: "리포트 확인하기",
                                      color: AppColor_Primary,
                                      weight: FW.semi_bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            )));
  }
}
