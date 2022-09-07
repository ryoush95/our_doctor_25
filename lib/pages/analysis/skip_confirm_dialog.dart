import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class SkipConfirmDialog extends StatefulWidget {
  const SkipConfirmDialog({Key? key}) : super(key: key);

  @override
  SkipConfirmDialogState createState() => SkipConfirmDialogState();
}

class SkipConfirmDialogState extends State<SkipConfirmDialog> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

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
                      const SizedBox(height: 52),
                      H20(text: LanguageService.trans("diagnosis_stop_title"), color: AppColor_BlackText, maxLine: 2, height: 1.3),
                      // const SizedBox(height: 10),
                      // H16(
                      //   text: LanguageService.trans("diagnosis_stop_description"),
                      //   color: AppColor_BlackText,
                      //   weight: FW.regular,
                      // ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          H16(
                            text: LanguageService.trans("diagnosis_stop_description"),
                            color: AppColor_BlackText,
                            weight: FW.regular,
                          ),
                          const SizedBox(width: 5),
                          Image.asset('assets/ic_smile.png', width: 25),
                        ],
                      ),
                      const SizedBox(height: 33),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (screenSize.width - 80) / 2,
                            child: MainTextButton(
                              text: LanguageService.trans("continue1"),
                              backgroundColor: AppColor_Primary,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
                              height: 58,
                              radius: 16,
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
                              text: LanguageService.trans("getting_started"),
                              backgroundColor: AppColor_Green,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
                              height: 58,
                              radius: 16,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context); //페지없애고 삭제
                                Navigator.push(context, SlideRightTransRoute(builder: (context) => FirstPage()));
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
