import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h11.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/line_chart.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_start.dart';

class PrevMonitoring extends StatefulWidget {
  PrevMonitoring({Key? key}) : super(key: key);

  // final List<ReportDto> data;

  @override
  PrevMonitoringState createState() => PrevMonitoringState();
}

class PrevMonitoringState extends BaseState<PrevMonitoring> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 10),
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.transparent),
              child: H16(text: LanguageService.trans('meet_customized_growth'), maxLine: 3, color: AppColor_Tab_Unselected, weight: FW.medium,)
          ),
          const SizedBox(height: 20),
          Center(
            child: MainTextButton(
              text: LanguageService.trans('start_monitoring'),
              style: AppTextStyle.PD(Colors.white, 14, weight: FW.medium),
              width: 160,
              height: 36,
              radius: 14,
              onPressed: () {
                Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
              },
            ),
          ),
        ]
    );
  }

}
