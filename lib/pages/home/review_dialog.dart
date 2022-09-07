import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/home/write_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({Key? key}) : super(key: key);

  @override
  ReviewDialogState createState() => ReviewDialogState();
}

class ReviewDialogState extends State<ReviewDialog> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void onLeaveMessage() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const WriteDialog();
        });
  }

  void onLeaveReview() {
    Navigator.pop(context);
    if (Platform.isAndroid) {
      if (isOneStore) {
        //_launchURL(ONESOTRE_URL);
        launch(ONESOTRE_URL);
      } else {
        _launchURL(MARKET_URL);
      }
    } else {
      _launchURL(APPSTORE_URL);
    }
  }

  _launchURL(String _url) async {
     try {
      await launch(_url);
    } catch (err) {
      showToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: onBackPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Image.asset(
                    "assets/clear_black_24dp.png",
                    width: 20,
                  ),
                ),
              )),
          H22(
            text: LanguageService.trans("treatment_complete"),
          ),
          const SizedBox(height: 20),
          Center(
            child: H18(
              text: LanguageService.trans("review_guide"),
              weight: FW.medium,
              height: 1.5,
              maxLine: 3,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset("assets/ic_icon5.png", width: 300),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: H16(
                  text: LanguageService.trans("review_hint"),
                  weight: FW.regular,
                  color: AppColor_Input_Title,
                  maxLine: 3,
                  height: 1.5,
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          MainTextButton(
            text: LanguageService.trans("leave_msg"),
            backgroundColor: gUserInfo!.message!.isEmpty ? AppColor_Primary : Colors.white,
            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
            width: 350,
            onPressed: () {
              if (gUserInfo!.message!.isEmpty) {
                onLeaveMessage();
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MainTextButton(
            text: LanguageService.trans("leave_review"),
            backgroundColor: AppColor_Green,
            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
            width: 350,
            onPressed: () {
              onLeaveReview();
            },
          ),
          const SizedBox(height: 40)
        ]),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
    );
  }
}
