import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends BaseState<SettingPage> {
  String profileImage = "";
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();

  String? chatNum = "";

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  // Network functions
  //////////////////////////////////
  //설정
  Future<void> updateSetting() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.setting(gUserInfo!.alarmYn == "y" ? "n" : "y");
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gUserInfo!.alarmYn = gUserInfo!.alarmYn == "y" ? "n" : "y";
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("setting"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: 67,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H16(
                                  text: LanguageService.trans("ourdoctor_alarm"),
                                  weight: FW.medium,
                                  color: AppColor_BlackText,
                                ),
                                const SizedBox(height: 7),
                                H12(
                                  text: LanguageService.trans("ourdoctor_alarm_desc"),
                                  weight: FW.medium,
                                  color: AppColor_BlackText.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 50),
                          InkWell(
                            onTap: () {
                              updateSetting();
                            },
                            child: Image.asset(
                              gUserInfo!.alarmYn == "y" ? 'assets/ic_switch_on.png' : 'assets/ic_switch_off.png',
                              width: 55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
