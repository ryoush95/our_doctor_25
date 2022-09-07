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
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/intro/intro1.dart';

class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends BaseState<IntroPage> {
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
    Navigator.push(context, SlideRightTransRoute(builder: (context) => IntroHomePage()));
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
                  child: Image.asset('assets/ic_guide_logo.png', width: 120, height: 120),
                ),
                const SizedBox(height: 50),
                H24B(
                  text: LanguageService.trans("ourdoctor"),
                ),
                const SizedBox(height: 20),
                H18(
                  text: LanguageService.trans("intro1_title"),
                  weight: FW.regular,
                ),
                const SizedBox(height: 30),
                H18(
                  text: LanguageService.trans("intro1_description"),
                  weight: FW.medium,
                  color: AppColor_Intro_Description,
                  maxLine: 3,
                  height: 1.5,
                ),
                const SizedBox(height: 20),
                H18(
                  text: LanguageService.trans("intro1_type"),
                  weight: FW.medium,
                  color: AppColor_Primary,
                  maxLine: 3,
                  height: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(width: 5),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColor_Step),
                    ),
                  ],
                )
              ],
            )),
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
