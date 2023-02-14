import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitoring/sleep_graph_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/line_chart.dart';
import 'package:ourdoctor/pages/components/line_chart2.dart';
import 'package:sprintf/sprintf.dart';

class SleepChart extends StatefulWidget {
  SleepChart({Key? key, required this.data}) : super(key: key);

  final SleepDataDto data;

  @override
  SleepChartState createState() => SleepChartState();
}

class SleepChartState extends BaseState<SleepChart> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 340,
        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: AppColor_Light_Gray),
        child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Image.asset('assets/nightlight_black_24dp.png', width: 24),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "밤잠 시간",
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
                                //TextSpan(text: LanguageService.trans('average') + ' ${getHourFromMinutes(widget.data.avgSleepNight!.toString())} ' + LanguageService.trans('hour'), style: AppTextStyle.PD(AppColor_GrayText, 14, weight: FW.regular)),
                                TextSpan(text: LanguageService.trans('average') + ' ${getHourFromMinutes1(widget.data.avgSleepNight!.toString())}', style: AppTextStyle.PD(AppColor_GrayText, 14, weight: FW.regular)),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //H18(text: getHourFromMinutes(widget.data.monitoringFood!.data!.sleepAtNight!) + " " + LanguageService.trans('hour'), color: AppColor_BlackText, weight: FW.semi_bold),
                        H18(text: getHourFromMinutes1((widget.data.avgSleepLaunch! + widget.data.avgSleepNight!).toString()), color: AppColor_BlackText, weight: FW.semi_bold),
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
                    child: LineChartWidget2(data1: widget.data, type: 'night'),
                  ),
                ),
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

    if (hour == 0 && minutes < 780) {
      return sprintf("%d분", [min]);
    } else if (hour != 0 && minutes < 780){
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

}
