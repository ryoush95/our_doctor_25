import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/intro/intro2.dart';

class IntroHomePage extends StatefulWidget {
  @override
  IntroHomePageState createState() => IntroHomePageState();
}

class IntroHomePageState extends BaseState<IntroHomePage> {
  late Map statuses;
  int backButtonTimestamp = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - backButtonTimestamp < 2000) {
      exit(0);
    } else {
      showToast(LanguageService.trans('press_twice_to_exit'));
    }
    backButtonTimestamp = now;
    return false;
  }

  void onNext() {
    Navigator.push(context, SlideRightTransRoute(builder: (context) => IntroGrowthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset('assets/ic_guide_logo.png', width: 82, height: 90),
                ),
                const SizedBox(height: 60),
                H24B(
                  text: LanguageService.trans("home_treatment_home_care_mode"),
                  maxLine: 2,
                ),
                // const SizedBox(height: 10),
                H18(text: "우리 아이 키울 땐!", weight: FW.regular, maxLine: 2, height: 1.7),
                const SizedBox(height: 33),
                H14(
                  text: "+ 소아 · 청소년과 전문병원 의료진이 직접 만든 앱\n+ 서울대 의과대학 협력 및 감수\n+ 전국의 100여 개 아동 병원 - 아동병원협회의 공식 인증 앱",
                  weight: FW.medium,
                  color: AppColor_Intro_Description,
                  maxLine: 4,
                  height: 1.5,
                ),
                const SizedBox(height: 30),
                Expanded(child: Container()),
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: 8,
                //   width: 8,
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColor_Step),
                // ),
                // const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: 22,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor_Primary),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColor_Step),
                ),
              ],
            ),
            const SizedBox(height: 25),
            InkWell(
                onTap: onNext,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: H18(text: LanguageService.trans("to_the_next"), weight: FW.bold),
                )),
            const SizedBox(height: 40)
          ],
        ));
  }
}
