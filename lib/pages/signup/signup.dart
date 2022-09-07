import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/hosiptal_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/signup/agree.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);
  // String? snsid;
  // String? type;
  // String? alarm;

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends BaseState<SignUpPage> {
  // final HttpService httpService = HttpService();

  bool isValid = false;
  bool isGrowth = false;
  bool isHome = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }



  void goNext() {
    //Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
    Navigator.push(context, SlideRightTransRoute(builder: (context) => AgreePage(snsid: "", type: 'normal')));
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                    height: 55,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            onBackPressed();
                          },
                          child: Image.asset(
                            'assets/path_12225.png',
                            width: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: H18(
                                text: LanguageService.trans("sign_up"),
                                weight: FW.medium,
                                height: 1.5,
                                color: AppColor_BlackText,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        H24B(
                          text: LanguageService.trans("necessary_home_care_features_please_select_all"),
                          color: AppColor_BlackText,
                          maxLine: 2,
                          align: TextAlign.left,
                          height: 1.5
                        ),
                        const SizedBox(height: 90),
                        InkWell(
                          onTap: () {
                            isGrowth = !isGrowth;
                            if (isGrowth && isHome) {
                              isValid = true;
                            } else {
                              isValid = false;
                            }
                            setState(() {});
                          },
                          child: Container(
                            width: screenSize.width-60,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              // color: AppColor_BlackText,
                              borderRadius: const BorderRadius.all(Radius.circular(14)),
                              border: Border.all(color: isGrowth ? AppColor_Primary : AppColor_BlackText.withOpacity(0.05), width: 1.0)
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  isGrowth ? 'assets/ic_check_on.png' : 'assets/ic_check_off.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(height: 15),
                                H14(
                                  text: LanguageService.trans("growth_and_development"),
                                  weight: FW.bold,
                                  color: isGrowth ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                ),
                              ],
                            )
                          )
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                            onTap: () {
                              isHome = !isHome;
                              if (isGrowth && isHome) {
                                isValid = true;
                              } else {
                                isValid = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                                width: screenSize.width-60,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  // color: AppColor_BlackText,
                                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                                    border: Border.all(color: isHome ? AppColor_Primary : AppColor_BlackText.withOpacity(0.05), width: 1.0)
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      isHome ? 'assets/ic_check_on.png' : 'assets/ic_check_off.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(height: 15),
                                    H14(
                                      text: LanguageService.trans("home_treatment"),
                                      weight: FW.bold,
                                      color: isHome ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                    ),
                                  ],
                                )
                            )
                        ),
                        const SizedBox(height: 160),
                        Center(
                          child: MainTextButton(
                            text: LanguageService.trans("next"),
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            width: MediaQuery.of(context).size.width - 60,
                            disable: !isValid,
                            disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                            onPressed: () {
                              if (!isValid) {
                                return;
                              }
                              goNext();
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
