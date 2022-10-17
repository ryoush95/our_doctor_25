import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/result_area.dart';
import 'package:ourdoctor/pages/home/bmi_bar.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/home/weight_line_chart.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class WeightReport extends StatefulWidget {
  WeightReport({Key? key, required this.data, this.result = 0}) : super(key: key);

  final HomeGraphWeightDto data;
  final int result;

  @override
  WeightReportState createState() => WeightReportState();
}

class WeightReportState extends BaseState<WeightReport> {
  DateTime now = DateTime.now();

  final tooltip = GlobalKey();
  final tooltip1 = GlobalKey();

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"), textStyle: AppTextStyle.PD(AppColor_BlackText, 12), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(10.0), onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
  }

  void showMoreText1() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: "보건복지부 및 대한소아과학회\n소아청소년 성장도표 기준", textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2), height: 60, width: 210, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), borderRadius: BorderRadius.circular(5.0), onDismiss: () {});
    popup.show(
      widgetKey: tooltip1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            WeightLineChart(data: widget.data),
            const SizedBox(height: 30),
            BMIBar(
              type: 1,
              text: widget.data.monitoring!.diagnose!.result!,
              subtext: widget.data.monitoring!.diagnose!.result!.contains("정상") ? "" : ((widget.data.monitoring!.diff! > 0 ? "+" : "") + convertScore(widget.data.monitoring!.diff!.toStringAsFixed(1)) + "kg"),
              weight: widget.data.monitoring!.value!,
              tiptext: "BMI는 체질량 지수를의미합니다. (kg/m2)",
              res: widget.data.monitoring!.diagnose!.result!.contains("부모마음") ? getResFromString("") :
              getResFromString(widget.data.monitoring!.diagnose!.color!),
              color: widget.data.monitoring!.diagnose!.result!.contains("부모마음") ? getColorFromString(""):
              getColorFromString(widget.data.monitoring!.diagnose!.color!),
            ),
            const SizedBox(height: 30),
            const Divider(color: AppColor_Light_Gray, thickness: 3),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H18(text: gSelChildInfo == null ? '' : "${getAge(gSelChildInfo!.birth!)}세 ${gSelChildInfo!.gender! == 1 ? '남' : '여'}아 백분위", weight: FW.regular),
                  const SizedBox(width: 5),
                  InkWell(
                    key: const Key('show_more_ink_well'),
                    child: Container(
                      key: tooltip1,
                      child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                    ),
                    onTap: showMoreText1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            RangeShow(
                start: widget.data.monitoring!.diagnose!.min!,
                end: widget.data.monitoring!.diagnose!.max!,
                rate: widget.data.monitoring!.value! > double.parse(widget.data.monitoring!.diagnose!.max!)
                    ? 100
                    : (widget.data.monitoring!.value! < double.parse(widget.data.monitoring!.diagnose!.min!)
                        ? 0
                        : (((widget.data.monitoring!.value! - double.parse(widget.data.monitoring!.diagnose!.min!))) / ((double.parse(widget.data.monitoring!.diagnose!.max!) - double.parse(widget.data.monitoring!.diagnose!.min!))) * 100)),
                unit: "kg",
                color: getColorFromString(widget.data.monitoring!.diagnose!.color!),
                cur_value: widget.data.monitoring!.value!),
            widget.result == 1 ? const SizedBox(height: 40) : const SizedBox(),
            widget.result == 1 ? ResultArea(type: 1, result: 2, diagnose: widget.data.monitoring!.diagnose!) : const SizedBox(),
          ],
        ));
  }

  int getWeight() {
    return 25;

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
