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

class CircularProgress2 extends StatefulWidget {
  int? type;
  int? subType;

  CircularProgress2({Key? key, this.type = 0, this.subType = 0}) : super(key: key);

  @override
  CircularProgress2State createState() => CircularProgress2State();
}

class CircularProgress2State extends BaseState<CircularProgress2> {
  final tooltip = GlobalKey();
  HomeMonitorDto? dicHomeDataInfo;
  final HttpService httpService = HttpService();
  String content = "";
  double fWidth = 0;
  double fHeight = 0;

  double showScore() {
    double result = 0;

    if (dicHomeDataInfo == null) {
      return result;
    }

    if (widget.type == 0) {
      result = dicHomeDataInfo!.totalScore!;
    } else {
      if (widget.subType == 0) {
        result = dicHomeDataInfo!.bodyScore!;
      } else {
        result = dicHomeDataInfo!.brainScore!;
      }
    }

    return result > 100 ? 100 : result;
  }

  Color changeColor(double p) {
    if (p < 80) {
      return AppColor_Red;
    } else if (p < 90) {
      return AppColor_Oxygen;
    } else {
      return AppColor_Primary;
    }
  }

  @override
  void initState() {
    super.initState();
    getMonitor2HomeDataInfo();

    eventBus.on<SubTabEvent>().listen((event) {
      if (mounted) {
        widget.subType = event.type;
        setState(() {});
      }
    });

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getMonitor2HomeDataInfo();
      }
    });
  }

  String convertScore(String score) {
    double hrs = fromJsonDouble(score);
    if (hrs - hrs.toInt() == 0.0) {
      return sprintf("%d", [hrs.toInt()]);
    }
    return sprintf("%.1f", [hrs]);
  }

  // Network functions|
  //////////////////////////////////
  //홈 발달 리포트 얻기
  Future<void> getMonitor2HomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeMonitorResModel> info = httpService.homeMonitorInfo();
    info.then((HomeMonitorResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeDataInfo = value.data!;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
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
          width: MediaQuery.of(context).size.width / 4,
          height: 112,
          child: Stack(
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 90,
                  lineWidth: 6.0,
                  animation: true,
                  percent: dicHomeDataInfo == null ? 0 : showScore() / 100,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          (dicHomeDataInfo == null || showScore() == 0)
                              ? "??"
                              : convertScore(showScore().toString()),
                          // weight: FW.regular,
                        style: TextStyle(
                            color: changeColor(showScore()),
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
                  progressColor: changeColor(showScore()),
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
