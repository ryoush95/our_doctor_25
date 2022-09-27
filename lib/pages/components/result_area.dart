import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class ResultArea extends StatefulWidget {
  ResultArea({Key? key, this.type = 0, this.result = 0, this.diagnose}) : super(key: key);
  final type;
  final result;
  final Diagnose? diagnose;

  @override
  ResultAreaState createState() => ResultAreaState();
}

class ResultAreaState extends BaseState<ResultArea> {
  DateTime now = DateTime.now();

  final tooltip = GlobalKey();

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"), textStyle: AppTextStyle.PD(AppColor_BlackText, 12), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(10.0), onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.type == 0 ? H18(text: '자녀는 ${widget.diagnose!.result}이에요') : const SizedBox(),
                  widget.type == 1 ? H18(text: '자녀가 ${widget.diagnose!.result}이에요') : const SizedBox(),
                  widget.type == 2 ? H18(text: LanguageService.trans("monitoring_lifestyle_0")) : const SizedBox(),
                  widget.type == 3 ? H18(text: LanguageService.trans("monitoring_disease_0")) : const SizedBox(),
                  widget.type == 4 ? H18(text: LanguageService.trans("monitoring_language_0")) : const SizedBox(),
                  widget.type == 5 ? H18(text: LanguageService.trans("monitoring_sport_0")) : const SizedBox(),
                  widget.type == 6 ? H18(text: LanguageService.trans("monitoring_social_0")) : const SizedBox(),
                  widget.type == 7 ? H18(text: LanguageService.trans("monitoring_inspection_0")) : const SizedBox(),
                  const SizedBox(width: 10),
                  Image.asset('assets/ic_icon2.png', width: 20),
                ],
              ),
              const SizedBox(height: 20),
              widget.diagnose != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(widget.diagnose!.color! == 'R' ? 'assets/icon4.png' : 'assets/icon1.png', width: 60),
                        const SizedBox(width: 10),
                        Image.asset(widget.diagnose!.color! == 'Y' ? 'assets/icon5.png' : 'assets/icon2.png', width: 60),
                        const SizedBox(width: 10),
                        Image.asset(widget.diagnose!.color! == 'B' ? 'assets/icon6.png' : 'assets/icon3.png', width: 60),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              widget.diagnose != null ? GestureDetector(
                onTap: () {
                  log(widget.diagnose!.comment!);
                },
                child: H16(
                  text: '',
                  weight: FW.regular, 
                  height: 1.6, 
                  align: TextAlign.justify,
                  color: AppColor_Result_Text, 
                  maxLine: 100
                ),
              ) : const SizedBox(),
            ],
          ),
        ));
  }
}
