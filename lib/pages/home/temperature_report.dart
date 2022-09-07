import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h11.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/line_chart.dart';

class TemperatureReport extends StatefulWidget {
  TemperatureReport({Key? key, required this.data}) : super(key: key);

  final List<ReportDto> data;

  @override
  TemperatureReportState createState() => TemperatureReportState();
}

class TemperatureReportState extends BaseState<TemperatureReport> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 2),
            Image.asset('assets/ic_temp.png', width: 24),
            const SizedBox(width: 5),
            H14(text: LanguageService.trans('temperature'), color: AppColor_BlackText),
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
            child: LineChartWidget(gradientColor: AppColor_Primary, data: widget.data, type: 'temperature'),
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
          String data = widget.data.elementAt(i).afternoon_temperature;
          if (data == "") {
            return "미측정";
          } else {
            return data + '℃';
          }
        }
      } else {
        if (widget.data.elementAt(i).am_time.contains(date)) {
          String data = widget.data.elementAt(i).morning_temperature;
          if (data == "") {
            return "미측정";
          } else {
            return data + '℃';
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
