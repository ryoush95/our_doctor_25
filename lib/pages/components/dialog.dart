import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';

import 'H16.dart';
import 'main_text_button.dart';

class AppDialog {
  static showAlertDialog(BuildContext context, ResultStatus status, String text,
      bool isShowConfirm, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 250,
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                      status == ResultStatus.success
                          ? "assets/group-234.png"
                          : "assets/x-circle.png",
                      height: 65),
                  const SizedBox(height: 30),
                  H16(
                    text: text,
                    color: AppColor_BlackText,
                  ),
                  Visibility(
                    visible: isShowConfirm,
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: MainTextButton(
                        text: LanguageService.trans("confirm"),
                        height: 30,
                        width: 70,
                        style: AppTextStyle.PD(Colors.white, 18),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        );
      },
    );
  }

  static showConfirmDialog(BuildContext context, String text, bool isShowImage,
      Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            const SizedBox(height: 10),
            Visibility(
              visible: isShowImage,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Image.asset("assets/x-circle.png", height: 65),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: H16(
                text: text,
                color: AppColor_BlackText,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MainTextButton(
                  text: LanguageService.trans("cancel"),
                  backgroundColor: Colors.white,
                  style: AppTextStyle.PD(AppColor_BlackText, 15),
                  width: 70,
                  height: 30,
                  showBorder: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20),
                MainTextButton(
                  text: LanguageService.trans("confirm"),
                  style: AppTextStyle.PD(Colors.white, 15),
                  width: 70,
                  height: 30,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        );
      },
    );
  }

  static showLogoutDialog(BuildContext context, String text, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            const SizedBox(height: 10),
            Align(
              alignment:Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset("assets/android-close.png", height: 20),
                )
              )
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: H16(
                  text: text,
                  color: AppColor_BlackText,
                ),
              )
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MainTextButton(
                  text: LanguageService.trans("cancel"),
                  backgroundColor: Colors.white,
                  style: AppTextStyle.PD(AppColor_BlackText, 15),
                  width: 70,
                  height: 30,
                  showBorder: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20),
                MainTextButton(
                  text: LanguageService.trans("confirm"),
                  style: AppTextStyle.PD(Colors.white, 15),
                  width: 70,
                  height: 30,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        );
      },
    );
  }

  static showCEORegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(15),
          child: Container(
            height: 530,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 90),
                Image.asset("assets/logo.png", width: 60),
                const SizedBox(height: 100),
                H16(text: LanguageService.trans("register_ceo")),
                const SizedBox(height: 140),
                MainTextButton(
                  text: LanguageService.trans("confirm"),
                  style: AppTextStyle.PD(Colors.white, 15),
                  width: 125,
                  height: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 15),
                InkWell(
                  child: H16(
                    text: LanguageService.trans("go_register_ceo"),
                    color: AppColor_Primary,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     SlideRightTransRoute(
                    //         builder: (context) => BossRegisterPage()));
                  },
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        );
      },
    );
  }
}
