import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/signup/signup1.dart';

class AgreePage extends StatefulWidget {
  AgreePage({Key? key, required this.snsid, required this.type, this.dadHeight = "", this.momHeight = "", this.childHeight = "", this.childWeight = ""}) : super(key: key);
  String? snsid;
  String? type;
  String? dadHeight;
  String? momHeight;
  String? childHeight;
  String? childWeight;

  @override
  AgreePageState createState() => AgreePageState();
}

class AgreePageState extends BaseState<AgreePage> {
  final HttpService httpService = HttpService();

  bool isAll = false;
  bool isItem1 = false;
  bool isItem2 = false;
  bool isItem3 = false;
  bool isItem4 = false;
  bool isItem5 = false;

  bool bDlgAgree = false;
  String? strAgreeTitle = "";
  String? strAgreeUrl = "";

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (bDlgAgree) {
      bDlgAgree = false;
      setState(() {});
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }

  void showAgreeDlg(int type) async {
    if (type == 1) {
      strAgreeTitle = "서비스 이용약관";
      //strAgreeUrl = API_BASE_URL + "api/common/term?type=term";
      strAgreeUrl = TERMS_URL;
    } else if (type == 2) {
      strAgreeTitle = "개인정보 처리방침";
      //strAgreeUrl = API_BASE_URL + "api/common/term?type=privacy";
      strAgreeUrl = POLICY_URL;
    } else if (type == 3) {
      strAgreeTitle = "고유식별정보 수집동의 및 처리방침";
      //strAgreeUrl = API_BASE_URL + "api/common/term?type=privacy1";
      strAgreeUrl = HEALTH_URL;
    } else if(type == 4){
      strAgreeTitle = "개인 민감(건강)정보 처리방침";
      //strAgreeUrl = API_BASE_URL + "api/common/term?type=privacy2";
      strAgreeUrl = AD_URL;
    } else if(type == 5) {
      strAgreeTitle = "마케팅 수신 동의 처리방침";
      strAgreeUrl = MAKETING_URL;
    }

    bDlgAgree = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Container(
                          height: 62,
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
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TODO: 마케팅 동의 선택
                              const SizedBox(height: 30),
                              H24B(text: LanguageService.trans("agree_description"), color: AppColor_BlackText, maxLine: 3, align: TextAlign.left, height: 1.5),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                   onTap: () {
                                        isAll = !isAll;
                                        if (isAll) {
                                          isItem1 = true;
                                          isItem2 = true;
                                          isItem3 = true;
                                          isItem4 = true;
                                          isItem5 = true;
                                        } else {
                                          isItem1 = false;
                                          isItem2 = false;
                                          isItem3 = false;
                                          isItem4 = false;
                                          isItem5 = false;
                                        }
                                        setState(() {});
                                      },
                                  child: Row(
                                    children: [
                                     Image.asset(
                                          isAll ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      const SizedBox(width: 16),
                                      H16(
                                        text: LanguageService.trans("agree_item_all"),
                                        weight: FW.regular,
                                        height: 1.8,
                                        maxLine: 2,
                                        align: TextAlign.left,
                                        color: isAll ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          isItem1 = !isItem1;
                                          if (isItem1 && isItem2 && isItem3 && isItem4) {
                                            isAll = true;
                                          } else {
                                            isAll = false;
                                          }
                                          setState(() {});
                                        },
                                        child: Image.asset(
                                          isItem1 ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      InkWell(
                                        onTap: () {
                                          showAgreeDlg(1);
                                        },
                                        child: H16(
                                            text: LanguageService.trans("agree_term_service"),
                                            weight: FW.regular,
                                            height: 1.3,
                                            color: isItem1 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        isItem2 = !isItem2;
                                        if (isItem1 && isItem2 && isItem3 && isItem4) {
                                          isAll = true;
                                        } else {
                                          isAll = false;
                                        }
                                        setState(() {});
                                      },
                                      child: Image.asset(
                                        isItem2 ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        showAgreeDlg(2);
                                      },
                                      child: H16(
                                        text: LanguageService.trans("agree_term_privacy"),
                                        weight: FW.regular,
                                        height: 1.3,
                                        color: isItem2 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        isItem3 = !isItem3;
                                        if (isItem1 && isItem2 && isItem3 && isItem4) {
                                          isAll = true;
                                        } else {
                                          isAll = false;
                                        }
                                        setState(() {});
                                      },
                                      child: Image.asset(
                                        isItem3 ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        showAgreeDlg(3);
                                      },
                                      child: H16(
                                        text: LanguageService.trans("agree_term_consent"),
                                        weight: FW.regular,
                                        height: 1.3,
                                        maxLine: 2,
                                        align: TextAlign.left,
                                        color: isItem3 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        isItem4 = !isItem4;
                                        if (isItem1 && isItem2 && isItem3 && isItem4) {
                                          isAll = true;
                                        } else {
                                          isAll = false;
                                        }
                                        setState(() {});
                                      },
                                      child: Image.asset(
                                        isItem4 ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        showAgreeDlg(4);
                                      },
                                      child: H16(
                                        text: LanguageService.trans("agree_term_sensitive"),
                                        weight: FW.regular,
                                        height: 1.8,
                                        maxLine: 2,
                                        color: isItem4 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        isItem5 = !isItem5;
                                        // if (isItem5) {
                                        //   Provider.of<GlobalProvider>(context, listen: false).changeSignupAlarm(isItem5);
                                        // } else {
                                        //   Provider.of<GlobalProvider>(context, listen: false).changeSignupAlarm(isItem5);
                                        // }
                                        setState(() {});
                                      },
                                      child: Image.asset(
                                        isItem5 ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        showAgreeDlg(5);
                                      },
                                      child: H16(
                                        text: LanguageService.trans("[선택] 마케팅 수신 동의"),
                                        weight: FW.regular,
                                        height: 1.8,
                                        maxLine: 2,
                                        color: isItem5 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Center(
                                child: MainTextButton(
                                  text: LanguageService.trans("next"),
                                  backgroundColor: AppColor_Primary,
                                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                                  width: MediaQuery.of(context).size.width - 60,
                                  disable: !isAll,
                                  height: 58,
                                  radius: 16,
                                  disableBackground: !isAll ? AppColor_Primary_Disable : Colors.transparent,
                                  onPressed: () {
                                    if (!isAll) {
                                      return;
                                    }
                                    Navigator.push(
                                        context,
                                        SlideRightTransRoute(
                                            builder: (context) => SignUpParentPage(
                                                  snsid: widget.snsid,
                                                  type: widget.type,
                                                  dadHeight: widget.dadHeight,
                                                  momHeight: widget.momHeight,
                                                  childHeight: widget.childHeight,
                                                  childWeight: widget.childWeight,
                                                  alarm: isItem5 ? "y" : "n",
                                                )),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 55),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: bDlgAgree,
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: H22(
                                          text: strAgreeTitle,
                                          height: 1.3,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          bDlgAgree = false;
                                          setState(() {});
                                        },
                                        child: H16(
                                          text: LanguageService.trans("close"),
                                          weight: FW.medium,
                                          height: 1.3,
                                          color: AppColor_Primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: InAppWebView(
                                    initialOptions: options,
                                    initialUrlRequest: URLRequest(url: Uri.parse(strAgreeUrl!)),
                                    onLoadStart: (controller, url) => {
                                      setState(() {
                                        isLoading = true;
                                      })
                                    },
                                    onLoadStop: (controller, url) => {
                                      setState(() {
                                        isLoading = false;
                                      })
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
