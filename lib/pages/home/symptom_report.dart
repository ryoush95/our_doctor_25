import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_disease_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h10.dart';
import 'package:ourdoctor/pages/components/h11.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_container.dart';

class SymptomReport extends StatefulWidget {
  SymptomReport({Key? key, required this.data}) : super(key: key);
  final HOmeSymptomGraphDto data;

  @override
  SymptomReportState createState() => SymptomReportState();
}

class SymptomReportState extends BaseState<SymptomReport> {
  String symtom = "sneeze etec 1";
  DateTime now = DateTime.now();
  List<DateTime> dateList = [];
  DateTime selectedDate = DateTime.now();
  var days = [
    LanguageService.trans('sun'),
    LanguageService.trans('mon'),
    LanguageService.trans('tue'),
    LanguageService.trans('wed'),
    LanguageService.trans('thu'),
    LanguageService.trans('fri'),
    LanguageService.trans('sat'),
  ];

  void changeDate(DateTime date) {
    // if (!getPossibleDate(date)) {
    //   showToast("회원가입 이전 날짜는 선택하실 수 없습니다.");
    //   return;
    // }
    setState(() {
      selectedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDate = now;
    dateList = [now.subtract(const Duration(days: 6)), now.subtract(const Duration(days: 5)), now.subtract(const Duration(days: 4)), now.subtract(const Duration(days: 3)), now.subtract(const Duration(days: 2)), now.subtract(const Duration(days: 1))];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 2),
            Image.asset('assets/content_paste_black_24dp.png', width: 24),
            const SizedBox(width: 5),
            H14(text: LanguageService.trans('symptom')),
            Expanded(child: Container()),
            Column(
              children: [
                H14(text: getTodayContent(), color: AppColor_Primary),
                Visibility(
                  visible: true,
                  //child: H11(text: '(' + getCurTime() + ')', color: const Color(0xFF9c9c9d)),
                  child: H11(text: '(오늘)', color: const Color(0xFF9c9c9d)),
                )
              ],
            ),
            const SizedBox(width: 4),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[dateList[0].weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[dateList[1].weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[dateList[2].weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[dateList[3].weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[dateList[4].weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[dateList[5].weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      child: Center(
                        child: H10(text: days[now.weekday % 7], color: AppColor_GrayText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == dateList[0] ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: dateList[0].day.toString(), color: selectedDate == dateList[0] ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(dateList[0]);
                      },
                    ),
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == dateList[1] ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: dateList[1].day.toString(), color: selectedDate == dateList[1] ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(dateList[1]);
                      },
                    ),
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == dateList[2] ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: dateList[2].day.toString(), color: selectedDate == dateList[2] ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(dateList[2]);
                      },
                    ),
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == dateList[3] ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: dateList[3].day.toString(), color: selectedDate == dateList[3] ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(dateList[3]);
                      },
                    ),
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == dateList[4] ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: dateList[4].day.toString(), color: selectedDate == dateList[4] ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(dateList[4]);
                      },
                    ),
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == dateList[5] ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: dateList[5].day.toString(), color: selectedDate == dateList[5] ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(dateList[5]);
                      },
                    ),
                    InkWell(
                      child: RoundContainer(
                        width: 26,
                        height: 26,
                        radius: 13,
                        bgColor: selectedDate == now ? AppColor_Primary : Colors.white,
                        child: Center(
                          child: H10(text: now.day.toString(), color: selectedDate == now ? Colors.white : AppColor_BlackText),
                        ),
                      ),
                      onTap: () {
                        changeDate(now);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: AppColor_Selector_Border,
                ),
                const SizedBox(height: 15),
                // H12(
                //   text: selectedDate.month.toString() + LanguageService.trans('month') + ' ' + selectedDate.day.toString() + LanguageService.trans('day'),
                //   weight: FW.medium,
                //   color: AppColor_GrayText,
                // ),
                // Expanded(child: Container()),
                const SizedBox(height: 20),
                Visibility(
                  //visible: getAmTime() != "",
                  visible: true,
                  child: Row(
                    children: [
                      RoundContainer(
                        width: 10,
                        height: 10,
                        radius: 5,
                        bgColor: getContentStatusColor(),
                      ),
                      const SizedBox(width: 10),
                      H14(text: getContent(), weight: FW.medium),
                      // const SizedBox(width: 20),
                      // H14(text: getAmData(), weight: FW.medium),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Visibility(
                //   visible: getPmTime() != "",
                //   child: Row(
                //     children: [
                //       RoundContainer(
                //         width: 10,
                //         height: 10,
                //         radius: 5,
                //         bgColor: AppColor_Primary,
                //       ),
                //       const SizedBox(width: 10),
                //       H14(text: getPmTime(), weight: FW.medium),
                //       const SizedBox(width: 20),
                //       H14(text: getPmData(), weight: FW.medium),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // String getTodayData() {
  //   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  //   for (int i = 0; i < widget.data.length; i++) {
  //     String date = dateFormat.format(now);
  //     int hour = now.hour;
  //     if (hour >= 12) {
  //       if (widget.data.elementAt(i).pm_time.contains(date)) {
  //         String data = widget.data.elementAt(i).afternoon_symptom;
  //         if (data == "") {
  //           return "미측정";
  //         } else {
  //           var arr = data.split(",");
  //           if (arr.length == 1) {
  //             if (arr[0] == "-1") {
  //               return "없음";
  //             } else {
  //               return arr[0];
  //             }
  //           } else {
  //             return arr[0] + " 외" + (arr.length - 1).toString() + "개";
  //           }
  //         }
  //       }
  //     } else {
  //       if (widget.data.elementAt(i).am_time.contains(date)) {
  //         String data = widget.data.elementAt(i).morning_symptom;
  //         if (data == "") {
  //           return "미측정";
  //         } else {
  //           var arr = data.split(",");
  //           if (arr.length == 1) {
  //             if (arr[0] == "-1") {
  //               return "없음";
  //             } else {
  //               return arr[0];
  //             }
  //           } else {
  //             return arr[0] + " 외" + (arr.length - 1).toString() + "개";
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return "미측정";
  // }
  /*
  String getCurTime() {
    int hour = now.hour;
    if (hour < 12) {
      return "오늘 오전";
    } else {
      return "오늘 오후";
    }
  }

  String getAmTime() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (int i = 0; i < widget.data.length; i++) {
      String date = dateFormat.format(selectedDate);
      if (widget.data.elementAt(i).am_time.contains(date)) {
        String time = widget.data.elementAt(i).am_time.substring(11, 13);
        int ntime = int.parse(time);
        if (ntime < 12) {
          return "오전 " + widget.data.elementAt(i).am_time.substring(11, 16);
        }
      }
    }
    return "";
  }

  String getAmData() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (int i = 0; i < widget.data.length; i++) {
      String date = dateFormat.format(selectedDate);
      if (widget.data.elementAt(i).am_time.contains(date)) {
        String data = widget.data.elementAt(i).morning_symptom;
        if (data == "") {
          return "미측정";
        } else {
          var arr = data.split(",");
          if (arr.length == 1) {
            if (arr[0] == "-1") {
              return "없음";
            } else {
              return arr[0];
            }
          } else {
            return arr[0] + " 외" + (arr.length - 1).toString() + "개";
          }
        }
      }
    }
    return "";
  }

  String getPmTime() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (int i = 0; i < widget.data.length; i++) {
      String date = dateFormat.format(selectedDate);
      if (widget.data.elementAt(i).pm_time.contains(date)) {
        String time = widget.data.elementAt(i).pm_time.substring(11, 13);
        int ntime = int.parse(time);
        if (ntime >= 12) {
          return "오후 " + widget.data.elementAt(i).pm_time.substring(11, 16);
        }
      }
    }
    return "";
  }

  String getPmData() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    for (int i = 0; i < widget.data.length; i++) {
      String date = dateFormat.format(selectedDate);
      if (widget.data.elementAt(i).pm_time.contains(date)) {
        String data = widget.data.elementAt(i).afternoon_symptom;
        if (data == "") {
          return "미측정";
        } else {
          var arr = data.split(",");
          if (arr.length == 1) {
            if (arr[0] == "-1") {
              return "없음";
            } else {
              return arr[0];
            }
          } else {
            return arr[0] + " 외" + (arr.length - 1).toString() + "개";
          }
        }
      }
    }
    return "";
  }
   */
  String getContent() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String date = dateFormat.format(selectedDate);
    String result = "";
    for (int i = 0; i < widget.data.graph!.length; i++) {
      if (widget.data.graph!.elementAt(i).date == date) {
        return widget.data.graph!.elementAt(i).symptom!;
      }
    }

    return result;
  }

  Color getContentStatusColor() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String date = dateFormat.format(selectedDate);
    String result = "";
    for (int i = 0; i < widget.data.graph!.length; i++) {
      if (widget.data.graph!.elementAt(i).date == date) {
        String symptom = widget.data.graph!.elementAt(i).symptom!;
        if (symptom.isNotEmpty) {
          String status = widget.data.graph!.elementAt(i).symptomStatus!;
          if (status == "doing") {
            return AppColor_Red;
          } else {
            return AppColor_BlackText.withOpacity(0.2);
          }
        }
      }
    }

    return Colors.white;
  }

  String getTodayContent() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String date = dateFormat.format(DateTime.now());
    String result = "미측정";
    for (int i = 0; i < widget.data.graph!.length; i++) {
      Graph info = widget.data.graph!.elementAt(i);
      if (info.date == date) {
        String content = info.symptom!;
        if (content != "") {
          return content;
        } else {
          return result;
        }
      }
    }
    return result;
  }
}
