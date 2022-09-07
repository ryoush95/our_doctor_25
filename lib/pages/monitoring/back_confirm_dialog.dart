import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/monitor_write_res_model.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../tab_main.dart';

class BackConfirmDialog extends StatefulWidget {
  const BackConfirmDialog({Key? key}) : super(key: key);

  @override
  BackConfirmDialogState createState() => BackConfirmDialogState();
}

class BackConfirmDialogState extends State<BackConfirmDialog> {
  String month = DateTime.now().month.toString();
  String day = DateTime.now().day.toString();
  String noon = DateTime.now().hour > 12 ? LanguageService.trans("afternoon") : LanguageService.trans("morning");

  String msg = "";
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    msg = sprintf(LanguageService.trans("complete_warning"), [DateTime.now().hour > 12 ? "5" : "11", DateTime.now().hour > 12 ? "PM" : "AM", noon]);
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  // Network functions
  //////////////////////////////////
  //모니터 쓰기
  Future<void> reqMonitorWrite() async {
    Navigator.pop(context);
    Navigator.push(context, SlideRightTransRoute(builder: (context) => TabMainPage()));
    return;
    // setState(() {
    //   isLoading = true;
    // });

    String datetime = dicWriteDto!.regDate + " " + dicWriteDto!.regTime;
    Future<MonitorWriteResModel> info = httpService.monitorWrite(datetime, dicWriteDto!.uid, dicWriteDto!.temperature, dicWriteDto!.oxygen, dicWriteDto!.heartCnt, dicWriteDto!.symptom, dicWriteDto!.pillUrl, dicWriteDto!.speciality);
    info.then((MonitorWriteResModel value) async {
      // setState(() {
      //   isLoading = false;
      // });
      if (value.result == 0) {
        dicWriteDto = null;
        showToast(LanguageService.trans('monitoring_save_success'));
        Navigator.pop(context);
        Navigator.push(context, SlideRightTransRoute(builder: (context) => TabMainPage()));
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colors.white),
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.25),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Expanded(
                        child: SubstringHighlight(
                          text: msg,
                          term: sprintf("%sM %sd", [month, day]),
                          textStyle: AppTextStyle.PD(AppColor_BlackText, 18, weight: FW.medium, height: 1.5),
                          textStyleHighlight: AppTextStyle.PD(AppColor_BlackText, 18, weight: FW.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: onBackPressed,
                              child: Center(
                                child: H16(
                                  text: LanguageService.trans("continue"),
                                  color: AppColor_Primary,
                                  weight: FW.medium,
                                ),
                              ),
                            )),
                            Expanded(
                                child: InkWell(
                              onTap: reqMonitorWrite,
                              child: Center(
                                child: H16(
                                  text: LanguageService.trans("save_exit"),
                                  weight: FW.medium,
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ))
            ],
          ),
          onWillPop: onBackPressed);
    });
  }
}
