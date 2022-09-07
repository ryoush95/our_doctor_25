import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/analysis/diagnosis_main.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends BaseState<StartPage> {
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

  void onStart() {
    LocalService.setGuide("1");
    // Navigator.push(context, SlideRightTransRoute(builder: (context) => LoginPage()));
    Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Image.asset('assets/ic_guide_logo.png', width: 82, height: 90),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H24B(text: LanguageService.trans("start_title"), maxLine: 3, height: 1.3),
                const SizedBox(height: 5),
                H18(
                  text: LanguageService.trans("start_description"),
                  weight: FW.regular,
                  height: 1.5,
                ),
              ],
            )),
            Container(
              margin: const EdgeInsets.only(left: 32, right: 32),
              child: Image.asset(
                'assets/bg_1_minute.png',
                width: MediaQuery.of(context).size.width - 64,
                fit: BoxFit.fitWidth,
              ),
            ),
            MainTextButton(
              text: LanguageService.trans("start_diagnostics"),
              backgroundColor: AppColor_Primary,
              style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
              width: MediaQuery.of(context).size.width - 64,
              height: 58,
              onPressed: () {
                Navigator.push(context, SlideRightTransRoute(builder: (context) => DiagnosisMainPage()));
              },
            ),
            const SizedBox(height: 10),
            MainTextButton(
              text: LanguageService.trans("skip"),
              backgroundColor: AppColor_Green,
              style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
              width: MediaQuery.of(context).size.width - 64,
              height: 58,
              onPressed: () {
                onStart();
              },
            ),
            const SizedBox(height: 50)
          ],
        ));
  }
}
