import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h11.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/line_chart.dart';

class OxygenReport extends StatefulWidget {
  OxygenReport({Key? key, required this.data}) : super(key: key);
  final List<ReportDto> data;

  @override
  OxygenReportState createState() => OxygenReportState();
}

class OxygenReportState extends BaseState<OxygenReport> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 2),
            Image.asset('assets/group_20051.png', width: 24),
            const SizedBox(width: 5),
            H14(text: LanguageService.trans('oxygen_saturation')),
            Expanded(child: Container()),
            Column(
              children: [
                H14(text: getTodayData(), color: AppColor_Primary),
                Visibility(
                  visible: true,
                  child: H11(text: '(' + getCurTime() + ')', color: const Color(0xFF9c9c9d)),
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
            child: LineChartWidget(gradientColor: AppColor_Oxygen, data: widget.data, type: 'saturation'),
          ),
        )
      ],
    );
  }

  String getTodayData() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String date = dateFormat.format(now);
    int hour = now.hour;
    for (int i = 0; i < widget.data.length; i++) {
      if (hour >= 12) {
        if (widget.data.elementAt(i).pm_time.contains(date)) {
          String data = widget.data.elementAt(i).pm_saturation;
          if (data == "") {
            return "미측정";
          } else if (data == "-1") {
            return "축정하지 않음";
          } else {
            return data + '%';
          }
        }
      } else {
        if (widget.data.elementAt(i).am_time.contains(date)) {
          String data = widget.data.elementAt(i).am_saturation;
          if (data == "") {
            return "미측정";
          } else if (data == "-1") {
            return "축정하지 않음";
          } else {
            return data + '%';
          }
        }
      }
    }
    return "미측정";
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
