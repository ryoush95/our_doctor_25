import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
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
                Center(
                  child: Image.asset('assets/ic_guide_logo.png', width: 82, height: 90),
                ),
                const SizedBox(height: 60),
                H24B(
                  text: LanguageService.trans("home_treatment_home_care_mode"),
                  maxLine: 2,
                ),
                // const SizedBox(height: 10),
                H18(text: "우리 아이 맞춤 성장 솔루션", weight: FW.regular, maxLine: 2, height: 1.7),
                const SizedBox(height: 33),
                H18(
                  text: LanguageService.trans("intro2_description"),
                  weight: FW.medium,
                  color: AppColor_Intro_Description,
                  maxLine: 4,
                  height: 1.5,
                ),
                const SizedBox(height: 30),
                H18(
                  text: "발달영역 케어",
                  weight: FW.bold,
                  color: AppColor_BlackText.withOpacity(0.45),
                  maxLine: 1,
                ),
                const SizedBox(height: 5),
                H18(
                  text: "대근육 / 소근육 / 인지/ 정서/ 발달 / 자조 / 신체",
                  weight: FW.medium,
                  color: AppColor_Intro_Description,
                  maxLine: 1,
                ),
                const SizedBox(height: 15),
                H18(
                  text: "생활습관 케어",
                  weight: FW.bold,
                  color: AppColor_BlackText.withOpacity(0.45),
                  maxLine: 1,
                ),
                const SizedBox(height: 5),
                H18(
                  text: "개인위생부터 사회성까지\n아이의 올바른 생활습관을 위한 맞춤 솔루션",
                  weight: FW.medium,
                  color: AppColor_Intro_Description,
                  maxLine: 2,
                ),
                const SizedBox(height: 15),
                H18(
                  text: "우리 아이 성장 기록",
                  weight: FW.bold,
                  color: AppColor_BlackText.withOpacity(0.45),
                  maxLine: 1,
                ),
                const SizedBox(height: 5),
                H18(
                  text: "영양 / 수면 / 체온 / 질병",
                  weight: FW.medium,
                  color: AppColor_Intro_Description,
                  maxLine: 2,
                ),
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
