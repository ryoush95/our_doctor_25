import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitoring/sleep_graph_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/line_chart.dart';
import 'package:ourdoctor/pages/components/line_chart2.dart';
import 'package:sprintf/sprintf.dart';

class LaunchSleepChart extends StatefulWidget {
  LaunchSleepChart({Key? key, required this.data}) : super(key: key);

  final SleepDataDto data;

  @override
  LaunchSleepChartState createState() => LaunchSleepChartState();
}

class LaunchSleepChartState extends BaseState<LaunchSleepChart> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 340,
        decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)), color: AppColor_Light_Gray),
        child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Row(children: [
                      Image.asset('assets/wb_sunny_black_24dp.png', width: 24),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            softWrap: true,
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "낮잠 시간",
                                  style: AppTextStyle.PD(
                                    AppColor_BlackText,
                                    16,
                                  )),
                            ]),
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            softWrap: true,
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(text: LanguageService.trans('average') + ' ${getHourFromMinutes1(widget.data.avgSleepLaunch!.toString())}', style: AppTextStyle.PD(AppColor_GrayText, 14, weight: FW.regular)),
                            ]),
                          ),
                        ],
                      ),
                    ]),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //H18(text: getHourFromMinutes(widget.data.monitoringFood!.data!.sleepAtLunch!) + " " + LanguageService.trans('hour'), color: AppColor_BlackText, weight: FW.semi_bold),
                        // H18(text: getHourFromMinutes1(widget.data.monitoringFood!.data!.sleepAtLunch!), color: AppColor_BlackText, weight: FW.semi_bold),
                        const SizedBox(height: 5),
                        // H14(text: "1", color: AppColor_GrayText, weight: FW.regular),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    color: Colors.white,
                    child: LineChartWidget2(data1: widget.data, type: 'launch'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // H16(text: "수면시간이 ", color: AppColor_BlackText),
                        // H16(text: " " + widget.data.monitoringSleep!.diagnose!.result!, color: getColorFromString(widget.data.monitoringSleep!.diagnose!.color!)),
                        // H16(text: "해요.", color: AppColor_BlackText),
                        // const SizedBox(width: 4),
                        // Image.asset("assets/ic_icon2.png", width: 20),
                      ],
                    )),
              ],
            )));
  }

  String getHourFromMinutes(String mins) {
    double hrs = fromJsonDouble(mins) / 60.0;
    if (hrs - hrs.toInt() == 0.0) {
      return sprintf("%d", [hrs.toInt()]);
    }
    return sprintf("%.1f", [hrs]);
  }

  String getHourFromMinutes1(String mins) {
    if (mins == "") {
      return "0분";
    }

    int minutes = fromJsonDouble(mins).toInt();
    int hour = fromJsonDouble(mins).toInt() ~/ 60;
    int min = (fromJsonDouble(mins)).toInt() % 60;
    
    if (hour == 0 && minutes < 420) {
      return sprintf("%d분", [min]);
    } else if (hour != 0 && minutes < 420) {
      return sprintf("%d시간 %d분", [hour, min]);
    } else {
      return sprintf("%d시간 이상", [hour]);
    }
  }


  int getWeight() {
    return 800;

    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    // String date = dateFormat.format(now);
    // int hour = now.hour;
    // for (int i = 0; i < widget.data.length; i++) {
    //   if (hour >= 12) {
    //     if (widget.data.elementAt(i).pm_time.contains(date)) {
    //       String data = widget.data.elementAt(i).afternoon_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   } else {
    //     if (widget.data.elementAt(i).am_time.contains(date)) {
    //       String data = widget.data.elementAt(i).morning_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   }
    // }
    // return "미측정";
  }

  String getCurTime() {
    int hour = now.hour;
    if (hour < 12) {
      return "오늘 오전";
    } else {
      return "오늘 오후";
    }
  }

  //FIXME: 수면시간에 맞게 설정 (변경된 api 참고)
  // String get getDiagnoseResult {
  //   final result = widget.data;
  //   switch(result) {
  //     case '정상':
  //       return '$result이에요';
  //     case '부족':
  //       return '$result해요';
  //     case '과다':
  //       return '$result예요';

  //     default: 
  //       return '$result입니다';
  //   }
  // }

  // String lastDay() {
  //   DateTime date = DateTime.parse(widget.data.monitoringFood!.data!.foodInputTime!.substring(0, 10));
  //   DateTime now = DateTime.now();
  //   final difference = now.difference(date).inDays + 1;
  //   if (difference == 1) {
  //     return '어제 기준';
  //   } else {
  //     return difference.toString() + "일전 기준";
  //   }
  // }
}
