import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h13.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';
import 'package:ourdoctor/pages/home/inoculation_info2.dart';

class InoculationInfo1Page extends StatefulWidget {
  @override
  InoculationInfo1PageState createState() => InoculationInfo1PageState();
}

class InoculationInfo1PageState extends BaseState<InoculationInfo1Page> {
  bool valid = false;

  String name = "";
  String birth = "";
  String phone = "";
  int index = 0;

  var nameInputController = TextEditingController();
  var birthdayInputController = TextEditingController();
  var phoneInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    checkValid();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  Future<void> showBirthdayDlg() async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 0));
    if (_result != null && _result != "") {
      birth = _result;
      birthdayInputController.text = birth;
      checkValid();
    }
  }

  void checkValid() {
    if (phone.isEmpty || name.isEmpty || birth.isEmpty || phone.length != 11) {
      setState(() {
        valid = false;
      });
    } else {
      setState(() {
        valid = true;
      });
    }
  }

  void goNext() {
    if (!valid) {
      return;
    }
    Navigator.push(context, SlideRightTransRoute(builder: (context) => InoculationInfo2Page()));
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: "접종 정보 업데이트",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(right: 32, left: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      H18(
                        text: "간편 실명인증 후",
                        weight: FW.medium,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          H18(
                            text: "아이의 접종 정보",
                            weight: FW.bold,
                            color: const Color(0xFF4B9EFF),
                          ),
                          H18(
                            text: "를 한번에 모아",
                            weight: FW.medium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      H18(
                        text: "관리할 수 있어요.",
                        weight: FW.medium,
                      ),
                      const SizedBox(height: 48),
                      H18(text: "간편 인증서 선택"),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              index = 0;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/ic_kakaotalk1.png', width: 60, height: 60),
                                  const SizedBox(height: 10),
                                  H13(
                                    text: "카카오톡",
                                    weight: FW.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  Image.asset(index == 0 ? 'assets/ic_option_on.png' : 'assets/ic_option_off.png', width: 24, height: 24),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width - 64 - 240) / 3),
                          InkWell(
                            onTap: () {
                              index = 1;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/ic_pass.png', width: 60, height: 60),
                                  const SizedBox(height: 10),
                                  H13(
                                    text: "통신사패스",
                                    weight: FW.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  Image.asset(index == 1 ? 'assets/ic_option_on.png' : 'assets/ic_option_off.png', width: 24, height: 24),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width - 64 - 240) / 3),
                          InkWell(
                            onTap: () {
                              index = 2;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/ic_samsung_pass.png', width: 60, height: 60),
                                  const SizedBox(height: 10),
                                  H13(
                                    text: "삼성패스",
                                    weight: FW.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  Image.asset(index == 2 ? 'assets/ic_option_on.png' : 'assets/ic_option_off.png', width: 24, height: 24),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width - 64 - 240) / 3),
                          InkWell(
                            onTap: () {
                              index = 3;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/ic_kb_mobile.png', width: 60, height: 60),
                                  const SizedBox(height: 10),
                                  H13(
                                    text: "KB 모바일",
                                    weight: FW.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  Image.asset(index == 3 ? 'assets/ic_option_on.png' : 'assets/ic_option_off.png', width: 24, height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              index = 4;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/ic_payco.png', width: 60, height: 60),
                                  const SizedBox(height: 10),
                                  H13(
                                    text: "페이코",
                                    weight: FW.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  Image.asset(index == 4 ? 'assets/ic_option_on.png' : 'assets/ic_option_off.png', width: 24, height: 24),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width - 64 - 240) / 3),
                          InkWell(
                            onTap: () {
                              index = 5;
                              setState(() {});
                            },
                            child: SizedBox(
                              width: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/ic_green_naver.png', width: 60, height: 60),
                                  const SizedBox(height: 10),
                                  H13(
                                    text: "네이버",
                                    weight: FW.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  Image.asset(index == 5 ? 'assets/ic_option_on.png' : 'assets/ic_option_off.png', width: 24, height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      H14(
                        text: "건강보험공단 로그인을 위해 본인(자녀)의 정보를 입력해주세요.",
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.4),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: H16(
                                text: "이름",
                                weight: FW.semi_bold,
                                align: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF4F5F7),
                                ),
                                child: TextField(
                                  style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                                  controller: nameInputController,
                                  onEditingComplete: () => node.nextFocus(),
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: "",
                                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) {
                                    name = text;
                                    checkValid();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: H16(
                                text: "생년월일",
                                weight: FW.semi_bold,
                                align: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF4F5F7),
                                ),
                                child: TextField(
                                  style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                                  controller: birthdayInputController,
                                  onEditingComplete: () => node.nextFocus(),
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.start,
                                  enableInteractiveSelection: false,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () {
                                    showBirthdayDlg();
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: "",
                                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: H16(
                                text: "휴대폰 번호",
                                weight: FW.semi_bold,
                                align: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF4F5F7),
                                ),
                                child: TextField(
                                  style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                                  controller: phoneInputController,
                                  onEditingComplete: () => node.nextFocus(),
                                  keyboardType: TextInputType.number,
                                  maxLength: 11,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: "",
                                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) {
                                    phone = text;
                                    checkValid();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        child: MainTextButton(
                          text: "인증요청",
                          backgroundColor: AppColor_Primary,
                          style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                          disable: !valid,
                          disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
                          onPressed: () {
                            goNext();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
