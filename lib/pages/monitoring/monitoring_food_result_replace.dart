import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/radar_chart.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_habit.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test2.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonitoringFoodResultReplace extends StatefulWidget {
  final int dif;
  const MonitoringFoodResultReplace({Key? key, required this.dif}) : super(key: key);

  @override
  State<MonitoringFoodResultReplace> createState() => _MonitoringFoodResultReplaceState();
}

class _MonitoringFoodResultReplaceState extends State<MonitoringFoodResultReplace> {
  final p = getIt.get<FoodResultProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    p.changeGraphIndex(-1);
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return PageLayout(
      onBack: onBackPressed,
      child: Column(
        children: [
          SimpleHeader(title:"영양모니터링",onBackPressed: onBackPressed,),

          Expanded(

            child: Center(
              child: widget.dif>180?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H18(
                    text: "7개월~1년",
                    maxLine: 2,
                    align: TextAlign.start,
                  ),
                  H18(
                    text: "체크리스트 대판",
                    maxLine: 2,
                    align: TextAlign.start,
                  ),
                ],
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H18(
                    text: "0개월~6개월",
                    maxLine: 2,
                    align: TextAlign.start,
                  ),
                  H18(
                    text: "체크리스트 대판",
                    maxLine: 2,
                    align: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
