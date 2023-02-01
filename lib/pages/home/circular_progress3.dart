import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/h36_b.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:sprintf/sprintf.dart';

class CircularProgress3 extends StatefulWidget {
  String? status;
  int? score;

  CircularProgress3({Key? key, this.status = "B", this.score = 0}) : super(key: key);

  @override
  CircularProgress3State createState() => CircularProgress3State();
}

class CircularProgress3State extends BaseState<CircularProgress3> {
  final tooltip = GlobalKey();
  String content = "";
  double fWidth = 0;
  double fHeight = 0;

  Color changeColor(String p) {
    if (p == "R") {
      return AppColor_Red;
    } else if (p == "G") {
      return AppColor_Oxygen;
    } else {
      return AppColor_Primary;
    }
  }

  @override
  void initState() {
    super.initState();

  }

  String convertScore(String score) {
    double hrs = fromJsonDouble(score);
    if (hrs - hrs.toInt() == 0.0) {
      return sprintf("%d", [hrs.toInt()]);
    }
    return sprintf("%.1f", [hrs]);
  }

  final tip = GlobalKey();
  OverlayEntry? entry;

  @override
  void dispose() {
    // TODO: implement dispose
    entry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 85,
          height: 112,
          child: Stack(
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 85,
                  lineWidth: 6.0,
                  animation: true,
                  percent: widget.score! / 100,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.score! == 0
                              ? "??"
                              : convertScore(widget.score!.toString()),
                          // weight: FW.regular,
                        style: TextStyle(
                            color: changeColor(widget.status!),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12,),
                          H14(text: LanguageService.trans('jom'), weight: FW.regular),
                        ],
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: changeColor(widget.status!),
                  backgroundColor: AppColor_f4f5f7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
