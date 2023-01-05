import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/line_chart.dart';
import 'package:ourdoctor/pages/components/line_chart_test_3.dart';
import 'package:ourdoctor/pages/components/price_point.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:sprintf/sprintf.dart';

class LifestyleLineChart2 extends StatefulWidget {
  LifestyleLineChart2({Key? key, required this.data}) : super(key: key);

  final HomeGraphLifeStyleDto data;

  @override
  LifestyleLineChart2State createState() => LifestyleLineChart2State();
}

class LifestyleLineChart2State extends BaseState<LifestyleLineChart2> {
  DateTime now = DateTime.now();

  Widget _diagnoseContainer({
    required String fText,
    required bool isNormal,
    String? calories,
    required String sText,
}) => Column(
    crossAxisAlignment: CrossAxisAlignment.center, children: [
    H16(text: fText),
    const SizedBox(height: 6),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isNormal 
        ? H16(text: '섭취하고 있어요.', color: AppColor_BlackText)
        : H16(
          text: "${roundOff(calories!)}kcal", 
          color: AppColor_BlackText,
        ),
        isNormal 
        ? const SizedBox()
        : Row(
          children: [
            const SizedBox(width: 5),
            H16(text: sText, color: getColorFromString2(sText),),
            H16(text: '해요. ', color: AppColor_BlackText),
          ],
        ),
        Image.asset("assets/ic_icon2.png", width: 20),
      ],
    ),
  ],
);

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
        height: 260,
        radius: 30,
        bgColor: AppColor_Light_Gray,
        child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Image.asset('assets/home_temp.png', height: 24,width: 24,),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '체온 기록',
                                    style: AppTextStyle.PD(
                                      AppColor_BlackText,
                                      16,
                                    )),
                              ]),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        H18(text: sprintf("%.0f", [36.6]) + " °C", color: AppColor_BlackText, weight: FW.semi_bold),
                        const SizedBox(height: 5),
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
                    child: LineChartTemp(points: pricePoints, points2 : pricePoints2),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )));
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

  double lastKcal() {
    return fromJsonDouble(widget.data.monitoringFood!.data!.breakfastKcal) +
        fromJsonDouble(widget.data.monitoringFood!.data!.launchKcal) +
        fromJsonDouble(widget.data.monitoringFood!.data!.snackKcal) +
        fromJsonDouble(widget.data.monitoringFood!.data!.dinnerKcal);
  }

  String lastDay() {
    DateTime date = DateTime.parse(widget.data.monitoringFood!.data!.foodInputTime!.substring(0, 10));
    DateTime now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) {
      return '오늘 기준';
    } else if (difference == 1) {
      return '어제 기준';
    } else {
      return difference.toString() + "일전 기준";
    }
  }
}
