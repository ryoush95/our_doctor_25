import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/line_chart_3.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:sprintf/sprintf.dart';

class HeightLineChart extends StatefulWidget {
  HeightLineChart({Key? key, required this.data}) : super(key: key);

  final HomeGraphTallDto data;

  @override
  HeightLineChartState createState() => HeightLineChartState();
}

class HeightLineChartState extends BaseState<HeightLineChart> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
        height: 340,
        radius: 30,
        bgColor: AppColor_Light_Gray,
        child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          softWrap: true,
                          textAlign: TextAlign.start,
                          text: TextSpan(children: [
                            TextSpan(
                                text: gSelChildInfo == null ? '' : gSelChildInfo!.name! + ' ',
                                style: AppTextStyle.PD(
                                  AppColor_BlackText,
                                  16,
                                  height: 1.2,
                                )),
                            TextSpan(text: LanguageService.trans('children_are'), style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular)),
                          ]),
                        ),
                        RichText(
                          softWrap: true,
                          textAlign: TextAlign.start,
                          text: TextSpan(children: [
                            TextSpan(text: widget.data.monitoring!.diagnose!.result!, 
                              style: AppTextStyle.PD(
                                getColorFromHeight(widget.data.monitoring!.diagnose!.result!),
                                16, 
                                height: 1.2
                              ),
                            ),
                            TextSpan(text: LanguageService.trans('it_is'), style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular))
                          ]),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        H20(text: sprintf("%.1fcm", [getHeight()]), color: AppColor_BlackText),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.white,
                    child: LineChart3Widget(
                        gradientColor: AppColor_Primary,
                        gradientColor1: AppColor_Green,
                        gradientColor2: AppColor_Breath,
                        data1: widget.data,
                        data2: null,
                        type: 'height',
                        gradientflag: false),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: AppColor_Primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          H12(
                            text: LanguageService.trans("child_kidney"),
                            weight: FW.medium,
                            height: 1.5,
                            color: AppColor_Input_Title,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: AppColor_Green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          H12(
                            text: LanguageService.trans("national_standard"),
                            weight: FW.medium,
                            height: 1.5,
                            color: AppColor_Input_Title,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: AppColor_Breath,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          H12(
                            text: LanguageService.trans("forecast"),
                            weight: FW.medium,
                            height: 1.5,
                            color: AppColor_Input_Title,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ],
            )));
  }

  double getHeight() {
    return widget.data.height!.toDouble();

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
