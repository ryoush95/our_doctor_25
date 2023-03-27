import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h11.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/h32_b.dart';
import 'package:ourdoctor/pages/components/line_chart_3.dart';
import 'package:sprintf/sprintf.dart';
import 'package:ourdoctor/pages/home/lifestyle_line_chart.dart';
import 'package:ourdoctor/pages/home/sleep_chart_night.dart';
import 'package:ourdoctor/pages/home/sleep_chart_launch.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/home/bmi_bar.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:ourdoctor/pages/components/result_area.dart';

import 'lifestyle_line_chart2.dart';


class LifestyleReport extends StatefulWidget {
  LifestyleReport({Key? key, required this.data, this.result = 0}) : super(key: key);

  final HomeGraphLifeStyleDto data;
  final int result;

  @override
  LifestyleReportState createState() => LifestyleReportState();
}

class LifestyleReportState extends BaseState<LifestyleReport> {
  DateTime now = DateTime.now();

  final tooltip = GlobalKey();
  final tooltip1 = GlobalKey();
  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"), textStyle: AppTextStyle.PD(AppColor_BlackText, 12), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(10.0), onDismiss: () {
        });
    popup.show(
      widgetKey: tooltip,
    );
  }
  void showMoreText1() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"), textStyle: AppTextStyle.PD(AppColor_BlackText, 12), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(10.0), onDismiss: () {
        });
    popup.show(
      widgetKey: tooltip1,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          // LifestyleLineChart(data: widget.data),
          const SizedBox(height: 20),
          // SleepChart(data: widget.data),
          // LaunchChart(data: widget.data),
          // widget.result == 1 ? const SizedBox(height: 40): const SizedBox(),
          // widget.result == 1 ? ResultArea(type: 2, result: 2): const SizedBox(),
          const SizedBox(height: 50),
        ],
      )
    );
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
