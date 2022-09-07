import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/login1.dart';

class BackConfirmDialog extends StatefulWidget {
  const BackConfirmDialog({Key? key}) : super(key: key);

  @override
  BackConfirmDialogState createState() => BackConfirmDialogState();
}

class BackConfirmDialogState extends State<BackConfirmDialog> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  // Network functions
  //////////////////////////////////
  //모니터 쓰기

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: screenSize.width,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colors.white),
                  //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.25),
                  child: Column(
                    children: [
                      const SizedBox(height: 45),
                      H24B(text: LanguageService.trans("go_to_main_page_dialog_title"), color: AppColor_BlackText, maxLine: 2, height: 1.3),
                      const SizedBox(height: 10),
                      // H16(
                      //   text: LanguageService.trans("go_to_main_page_dialog_description"),
                      //   color: AppColor_BlackText,
                      //   weight: FW.medium,
                      // ),
                      // const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          H16(
                            text: LanguageService.trans("go_to_main_page_dialog_description"),
                            color: AppColor_BlackText,
                            weight: FW.medium,
                          ),
                          const SizedBox(width: 5),
                          Image.asset('assets/ic_smile.png', width: 25),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (screenSize.width - 80) / 2,
                            child: MainTextButton(
                              text: LanguageService.trans("continue"),
                              backgroundColor: AppColor_Primary,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                              onPressed: () {
                                Navigator.pop(context);
                                return true;
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: (screenSize.width - 80) / 2,
                            child: MainTextButton(
                              text: LanguageService.trans("go_to_main"),
                              backgroundColor: AppColor_Green,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(context, SlideRightTransRoute(builder: (context) => Login1Page()));
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 45)
                    ],
                  ))
            ],
          ),
          onWillPop: onBackPressed);
    });
  }
}
