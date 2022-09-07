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
import 'package:ourdoctor/models/monitor_day_res_model.dart';
import 'package:ourdoctor/models/monitoring_all_res_model.dart';
import 'package:ourdoctor/models/monitoring_result_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_start.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:ourdoctor/pages/tab_main.dart';
import 'package:substring_highlight/substring_highlight.dart';

// class RecordItem {
//   late int type;
//   late String amDateTime;
//   late String amValue;
//   late String amImage;
//   late int amResult;
//   late String unit;
//   late double sleep1;
//   late double sleep2;
//   late double nutrition1;
//   late double nutrition2;
//   late double nutrition3;
//   late double nutrition4;
//
//   RecordItem({required this.type, required this.amDateTime, required this.amValue, required this.amImage, required this.amResult, required this.unit, this.sleep1 = 1.0, this.sleep2 = 1.0, this.nutrition1 = 1.0, this.nutrition2 = 1.0, this.nutrition3 = 1.0, this.nutrition4 = 1.0});
// }
//
// class RecordItem1 {
//   late int type;
//   late String DateTime;
//   late double height;
//   late double weight;
//   double sleep1;
//   double sleep2;
//   late double nutrition1;
//   late double nutrition2;
//   late double nutrition3;
//   late double nutrition4;
//   late List<String> disease;
//
//   RecordItem1({
//     required this.type,
//     required this.DateTime,
//     required this.height,
//     required this.weight,
//     required this.sleep1,
//     required this.sleep2,
//     required this.nutrition1,
//     required this.nutrition2,
//     required this.nutrition3,
//     required this.nutrition4,
//     required this.disease,
//   });
// }

class MonitoringResultPage extends StatefulWidget {
  @override
  MonitoringResultPageState createState() => MonitoringResultPageState();
}

class MonitoringResultPageState extends BaseState<MonitoringResultPage> {
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
  int month = DateTime.now().month;
  String day = DateTime.now().day.toString();
  String noon = DateTime.now().hour > 12 ? LanguageService.trans("afternoon") : LanguageService.trans("morning");
  String dateStr = "";

  int curCategory = 0;
  int showRecord = -1;
  MonitorResultDto? dicInfo = MonitorResultDto();
  MonitoringResultPageState() {
    dateStr = days[weekday] + ", " + months[month] + " " + day + "\n";
    print(dateStr);
  }

  // RecordItem1 records = RecordItem1(type: 0, DateTime: DateTime.now().toString(), height: 103.1, weight: 23, sleep1: 0, sleep2: 2, nutrition1: 700, nutrition2: 700, nutrition3: 700, nutrition4: 700, disease: []);
  //
  // RecordItem height = RecordItem(type: 0, amDateTime: "2021.12.11", amValue: "36.5", amImage: "", amResult: 0, sleep1: 0, unit: "cm");
  // RecordItem weight = RecordItem(type: 1, amDateTime: "2022.03.18", amValue: "23", amImage: "", amResult: 1, sleep1: 0, unit: "kg");
  // RecordItem sleep = RecordItem(type: 2, amDateTime: "2022.03.18", amValue: "23", amImage: "", amResult: 0, unit: "hour", sleep1: 2, sleep2: 6);
  // RecordItem nutrition = RecordItem(type: 3, amDateTime: "2022.03.18", amValue: "700", amImage: "", amResult: 2, sleep1: 0, unit: "Kcal");
  // RecordItem disease = RecordItem(type: 4, amDateTime: "2022.03.18", amValue: "none", amImage: "", amResult: 1, sleep1: 0, unit: "");
  // List<RecordItem> heightItemList = [];
  // List<RecordItem> weightItemList = [];
  // List<RecordItem> sleepItemList = [];
  // List<RecordItem> nutritionItemList = [];
  // List<RecordItem> diseaseItemList = [];

  int nPage = 0;
  bool isLast = false;
  List<MonitoringAlldto> arrMonitoringList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(loadMore);
    getMonitoringList();
  }

  void loadMore() {
    if (!isLoading) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getMonitoringList();
      }
    }
  }

  void onChooseCategory(int index) {
    setState(() {
      curCategory = index;
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  String getTitle(MonitoringAlldto info) {
    String result = "";
    String monitorTime = info.monitoringTime!;
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(monitorTime);
    var weekday = tempDate.weekday - 1;
    int month = tempDate.month;
    String day = tempDate.day.toString();
    result = month.toString() + "월 " + day + "일 " + days[weekday] + "\n일일 모니터링 결과";

    return result;
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

  void goMonitoringEditPage(MonitoringAlldto info) {
    monitoringData = null;
    monitoringData = MonitoringDayDto();

    monitoringData!.height = info.height;
    monitoringData!.weight = info.weight;
    monitoringData!.sleep_at_night = info.sleepAtNight;
    monitoringData!.sleep_at_lunch = info.sleepAtLunch;
    //아침,점심,간식,저녁
    String? nutrition = "";
    nutrition = info.breakfastKcal!.isEmpty ? "0" : info.breakfastKcal;
    nutrition = nutrition! + "," + (info.launchKcal!.isEmpty ? "0" : info.breakfastKcal)!;
    nutrition = nutrition + "," + (info.snackKcal!.isEmpty ? "0" : info.snackKcal)!;
    nutrition = nutrition + "," + (info.dinnerKcal!.isEmpty ? "0" : info.dinnerKcal)!;
    monitoringData!.nutrition = nutrition;

    // monitoringData!.language = "";
    // monitoringData!.sociability = "";
    // monitoringData!.work_out = "";
    monitoringData!.symptom_list = [];
    if (dicInfo != null && dicInfo!.sYMPTOM!.data != null && dicInfo!.sYMPTOM!.data!.isNotEmpty) {
      monitoringData!.symptom_list!.clear();
      for (int i = 0; i < dicInfo!.sYMPTOM!.data!.length; i++) {
        SymptomDto item = dicInfo!.sYMPTOM!.data!.elementAt(i);

        MonitoringSymptomDto info = MonitoringSymptomDto();
        info.category = item.category;
        info.symptom = item.symptom;
        info.record_time = item.recordTime;
        info.surgey_name = item.surgeryName;
        info.surgey_time = item.surgeryTime;
        info.medication = item.medicationUrl;
        monitoringData!.symptom_list!.add(info);
      }
    }
    Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage(uid: info.id)));
  }

  // Network functions
  //////////////////////////////////
  //모니터링 리스트 얻기
  Future<void> getMonitoringList() async {
    setState(() {
      isLoading = true;
    });

    Future<MonitoringAllResModel> info = httpService.monitoringAllList(nPage);
    info.then((MonitoringAllResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && arrMonitoringList.isNotEmpty) {
          arrMonitoringList.clear();
        }
        isLast = value.data!.isLast!;
        arrMonitoringList.addAll(value.data!.list!);
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
      showToast(onError.toString());
    });
  }

  // 모니터링 일일결과 얻기
  void getMonitoringResult(String date, int index) {
    String curDate = date.substring(0, 10);

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
        showRecord = index;
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

  void onEdit() {}

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
                  title: LanguageService.trans('monitoring_result'),
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: SingleChildScrollView(
                        child: Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: arrMonitoringList.length,
                        shrinkWrap: true,
                        itemBuilder: ItemBuilder,
                      ),
                    )),
                  ),
                ),
              ],
            )));
  }

  Widget ItemBuilder(BuildContext context, int index) {
    MonitoringAlldto info = arrMonitoringList.elementAt(index);
    return Container(
        child: Column(
      children: [
        Container(width: double.infinity, height: 10, decoration: BoxDecoration(color: AppColor_Divider)),
        const SizedBox(height: 30),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      if (showRecord == index) {
                        showRecord = -1;
                        setState(() {});
                      } else {
                        String monitorDate = info.monitoringTime!;
                        getMonitoringResult(monitorDate, index);
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [H22(text: getTitle(info), maxLine: 2, align: TextAlign.start, height: 1.2), const SizedBox(width: 5), Image.asset('assets/ic_daily_monitoring.png', width: 20)],
                        ),
                        showRecord == index ? Image.asset('assets/group_20046.png', width: 30) : Image.asset('assets/group_20047.png', width: 30),
                      ],
                    )),
                Visibility(
                  visible: showRecord == index,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
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
                          Visibility(
                            visible: isToday(info),
                            child: InkWell(
                              onTap: () {
                                goMonitoringEditPage(info);
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
                          ),
                          Visibility(
                              visible: isToday(info),
                              child: const SizedBox(
                                width: 6,
                              )),
                          InkWell(
                            onTap: () {
                              // log(curCategory.toString());
                              Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => TabMainPage(pageIdx: 2, infoTabIdx: curCategory)));
                            },
                            child: Container(
                              width: isToday(info) ? (MediaQuery.of(context).size.width - 66) / 2 : MediaQuery.of(context).size.width - 60,
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
                ),
              ],
            )),
        const SizedBox(height: 30),
      ],
    ));
  }

  bool isToday(MonitoringAlldto info) {
    String monitorTime = info.monitoringTime!.substring(0, 10);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return monitorTime == today;
  }
}
