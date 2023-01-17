import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:mobx/mobx.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/find_id_res_model.dart';
import 'package:ourdoctor/models/pass_set_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:provider/provider.dart';

class FindInfoPage extends StatefulWidget {
  int type;

  FindInfoPage({Key? key, required this.type}) : super(key: key);

  @override
  FindInfoPageState createState() => FindInfoPageState();
}

class FindInfoPageState extends BaseState<FindInfoPage> {
  int pageType = 1;
  final HttpService httpService = HttpService();
  late Timer timer;
  int stimer = 30;
  bool timerBt = true;

  //아이디 찾기 관련
  String idName = "";
  String idPhone = "";
  String idCode = "";
  String findid1 = "";
  String findid2 = "";
  String findid3 = "";
  int nIdStep = 0;
  bool isIdValid = false;
  var nameInputController = TextEditingController();
  var phoneInputController = TextEditingController();
  var codeInputController = TextEditingController();

  //비밀번호 찾기 관련
  String passId = "";
  String passName = "";
  String passPhone = "";
  String passCode = "";
  String newPass = "";
  String token = "";
  int nPassStep = 0;
  bool isPassValid = false;
  var passIdInputController = TextEditingController();
  var passNameInputController = TextEditingController();
  var passPhoneInputController = TextEditingController();
  var passCodeInputController = TextEditingController();
  var newPassInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageType = widget.type;
    setState(() {});
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void checkIdValid() {
    if (nIdStep == 0) {
      if (idName.isEmpty || idPhone.isEmpty) {
        setState(() {
          isIdValid = false;
        });
      } else {
        setState(() {
          isIdValid = true;
        });
      }
    } else if (nIdStep == 1) {
      if (idName.isEmpty || idPhone.isEmpty || idCode.isEmpty) {
        setState(() {
          isIdValid = false;
        });
      } else {
        setState(() {
          isIdValid = true;
        });
      }
    } else {
      isIdValid = true;
      setState(() {});
    }
  }

  String getIdButtonName() {
    if (nIdStep == 0) {
      return LanguageService.trans("send_code");
    } else if (nIdStep == 1) {
      return LanguageService.trans("find_id");
    } else {
      return LanguageService.trans("login1");
    }
  }

  void checkPassValid() {
    if (nPassStep == 0) {
      if (passId.isEmpty || passName.isEmpty || passPhone.isEmpty) {
        setState(() {
          isPassValid = false;
        });
      } else {
        setState(() {
          isPassValid = true;
        });
      }
    } else if (nPassStep == 1) {
      if (passId.isEmpty ||
          passName.isEmpty ||
          passPhone.isEmpty ||
          passCode.isEmpty) {
        setState(() {
          isPassValid = false;
        });
      } else {
        setState(() {
          isPassValid = true;
        });
      }
    } else if (nPassStep == 2) {
      if (newPass.isEmpty) {
        setState(() {
          isPassValid = false;
        });
      } else {
        setState(() {
          isPassValid = true;
        });
      }
    } else {
      isPassValid = true;
      setState(() {});
    }
  }

  String getPassButtonName() {
    if (nPassStep == 0) {
      return LanguageService.trans("send_code");
    } else if (nPassStep == 1) {
      return LanguageService.trans("find_password");
    } else if (nPassStep == 2) {
      return LanguageService.trans("password_reset");
    } else {
      return LanguageService.trans("login1");
    }
  }

  void startTimer() {
    var count = const Duration(seconds: 1);
    timer = Timer.periodic(count, (timer) {
      if (stimer == 0) {
        setState(() {
          timer.cancel();
          stimer = 60;
          timerBt = true;
        });
      } else {
        setState(() {
          stimer--;
        });
      }
    });
  }

  Widget FindIdPage() {
    final node = FocusScope.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Visibility(
            visible: nIdStep == 2,
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  H16(
                    text: findid1,
                    weight: FW.medium,
                    color: AppColor_BlackText,
                  ),
                  H16(
                    text: findid2,
                    weight: FW.bold,
                    color: AppColor_Primary,
                  ),
                  H16(
                    text: findid3,
                    weight: FW.medium,
                    color: AppColor_BlackText,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: nIdStep == 0 || nIdStep == 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  H14(
                    text: LanguageService.trans("name"),
                    weight: FW.medium,
                    color: AppColor_BlackText.withOpacity(0.5),
                  ),
                  UnderlineInput(
                    controller: nameInputController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    placeholder: LanguageService.trans("nmae_hint"),
                    onChanged: (text) => {
                      idName = text,
                      checkIdValid(),
                    },
                  ),
                  const SizedBox(height: 30),
                  H14(
                    text: LanguageService.trans("phone"),
                    weight: FW.medium,
                    color: AppColor_BlackText.withOpacity(0.5),
                  ),
                  UnderlineInput(
                    controller: phoneInputController,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.nextFocus(),
                    placeholder: LanguageService.trans("phone_hint1"),
                    onChanged: (text) => {
                      idPhone = text,
                      checkIdValid(),
                    },
                  ),
                  Visibility(
                    visible: nIdStep == 1,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: H14(
                            text: LanguageService.trans("input_code"),
                            weight: FW.medium,
                            color: AppColor_BlackText.withOpacity(0.5),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 160,
                                child: UnderlineInput(
                                  controller: codeInputController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () => node.nextFocus(),
                                  placeholder:
                                      LanguageService.trans("input_code_hint"),
                                  onChanged: (text) => {
                                    idCode = text,
                                    checkIdValid(),
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            SizedBox(
                              height: 50,
                              width: 80,
                              child: timerBt
                                  ? MainTextButton(
                                      onPressed: () {
                                        if (pageType == 1) {
                                          nIdStep = 0;
                                          reqSendCode();
                                          startTimer();
                                          timerBt = false;
                                        }
                                      },
                                      text: "인증번호\n 재전송",
                                      style: const TextStyle(
                                          color: AppColor_White, fontSize: 14),
                                    )
                                  : MainTextButton(
                                      backgroundColor: AppColor_Gray,
                                      text: stimer.toString(),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FindPassPage() {
    final node = FocusScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Visibility(
            visible: nPassStep == 3,
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  H16(
                    text: LanguageService.trans("password_reset_alert"),
                    weight: FW.medium,
                    color: AppColor_BlackText,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: nPassStep == 0 || nPassStep == 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  H14(
                    text: LanguageService.trans("id"),
                    weight: FW.medium,
                    color: AppColor_BlackText.withOpacity(0.5),
                  ),
                  UnderlineInput(
                    controller: passIdInputController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    placeholder: LanguageService.trans("signided_id"),
                    onChanged: (text) => {
                      passId = text,
                      checkPassValid(),
                    },
                  ),
                  const SizedBox(height: 40),
                  H14(
                    text: LanguageService.trans("name"),
                    weight: FW.medium,
                    color: AppColor_BlackText.withOpacity(0.5),
                  ),
                  UnderlineInput(
                    controller: passNameInputController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    placeholder: LanguageService.trans("nmae_hint"),
                    onChanged: (text) => {
                      passName = text,
                      checkPassValid(),
                    },
                  ),
                  const SizedBox(height: 30),
                  H14(
                    text: LanguageService.trans("phone"),
                    weight: FW.medium,
                    color: AppColor_BlackText.withOpacity(0.5),
                  ),
                  UnderlineInput(
                    controller: passPhoneInputController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.nextFocus(),
                    maxLength: 11,
                    placeholder: LanguageService.trans("phone_hint1"),
                    onChanged: (text) => {
                      passPhone = text,
                      checkPassValid(),
                    },
                  ),
                  Visibility(
                    visible: nPassStep == 1,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: H14(
                            text: LanguageService.trans("input_code"),
                            weight: FW.medium,
                            color: AppColor_BlackText.withOpacity(0.5),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 160,
                                child: UnderlineInput(
                                  controller: passCodeInputController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () => node.nextFocus(),
                                  placeholder: LanguageService.trans("input_code_hint"),
                                  onChanged: (text) => {
                                    passCode = text,
                                    checkPassValid(),
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            SizedBox(
                              height: 50,
                              width: 80,
                              child: timerBt
                                  ? MainTextButton(
                                      onPressed: () {
                                        if (pageType != 1) {
                                          nPassStep = 0;
                                          reqSendCode();
                                          startTimer();
                                          timerBt = false;
                                        }
                                      },
                                      text: "인증번호\n 재전송",
                                      style: const TextStyle(
                                          color: AppColor_White, fontSize: 14),
                                    )
                                  : MainTextButton(
                                      backgroundColor: AppColor_Gray,
                                      text: stimer.toString(),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Visibility(
            visible: nPassStep == 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  H14(
                    text: LanguageService.trans("new_password"),
                    weight: FW.medium,
                    color: AppColor_BlackText.withOpacity(0.5),
                  ),
                  UnderlineInput(
                    controller: newPassInputController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    isSecure: true,
                    onEditingComplete: () => node.nextFocus(),
                    placeholder: LanguageService.trans("new_password_hint"),
                    onChanged: (text) => {
                      newPass = text,
                      checkPassValid(),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Network functions
  //////////////////////////////////
  //인증번호 요청
  Future<void> reqSendCode() async {
    setState(() {
      isLoading = true;
    });

    String name = nameInputController.text;
    String phone = pageType == 1 ? idPhone : passPhone;

    Future<DefaultResModel> offerInfo = httpService.authKey(name,phone,"id","");
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('send_code_success'));
        if (pageType == 1) {
          nIdStep = nIdStep + 1;
          checkIdValid();
        } else {
          nPassStep = nPassStep + 1;
          checkPassValid();
        }
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //인증번호 요청
  Future<void> reqPwSendCode() async {
    setState(() {
      isLoading = true;
    });

    String name = pageType == 1 ? nameInputController.text : passNameInputController.text;
    String id = pageType == 1 ? "" : passIdInputController.text;
    String phone = pageType == 1 ? idPhone : passPhone;

    Future<DefaultResModel> offerInfo = httpService.authKey(name,phone,"pw",id);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('send_code_success'));
        if (pageType == 1) {
          nIdStep = nIdStep + 1;
          checkIdValid();
        } else {
          nPassStep = nPassStep + 1;
          checkPassValid();
        }
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //아이디 찾기
  Future<void> reqfindId() async {
    setState(() {
      isLoading = true;
    });

    Future<FindIdResModel> offerInfo =
        httpService.findId(idPhone, idName, idCode);
    offerInfo.then((FindIdResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        findid1 = "";
        findid2 = "";
        findid3 = "";
        if (value.data!.signupType == "normal") {
          findid1 = "가입하신 아이디는 ";
          findid2 = value.data!.id!;
          findid3 = " 입니다.";
        } else if (value.data!.signupType == "kakao") {
          findid1 = "카카오로 가입하셨습니다.";
        } else if (value.data!.signupType == "naver") {
          findid1 = "네이버로 가입하셨습니다.";
        }
        nIdStep = nIdStep + 1;
        checkIdValid();
        setState(() {});
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //비밀번호 찾기
  Future<void> reqFindPwd() async {
    setState(() {
      isLoading = true;
    });

    Future<PassSetResModel> offerInfo =
        httpService.findPwd(passPhone, passName, passId, passCode);
    offerInfo.then((PassSetResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        token = value.data!.accessToken!;
        nPassStep = nPassStep + 1;
        checkPassValid();
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //비밀번호 재설정
  Future<void> reqPwdReset() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo = httpService.passReset(token, newPass);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        nPassStep = nPassStep + 1;
        checkPassValid();
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //인증번호 보내기 버튼
  Widget bottomButton() {
    FocusScopeNode focusNode = FocusScope.of(context);
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          Visibility(
            visible: pageType == 1,
            child: Center(
              child: MainTextButton(
                text: getIdButtonName(),
                backgroundColor: AppColor_Primary,
                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                width: MediaQuery.of(context).size.width - 60,
                disable: !isIdValid,
                disableBackground:
                    !isIdValid ? AppColor_Primary_Disable : Colors.transparent,
                onPressed: () {
                  if (!isIdValid) {
                    showToast('정보를 확인해주세요.');
                  }
                  focusNode.unfocus();
                  if (nIdStep == 2) {
                    onBackPressed();
                  } else {
                    if (!isIdValid) {
                      return;
                    }
                    if (nIdStep == 0) {
                      reqSendCode();
                    } else if (nIdStep == 1) {
                      reqfindId();
                    }
                  }
                },
              ),
            ),
          ),
          Visibility(
            visible: pageType == 2,
            child: Center(
              child: MainTextButton(
                text: getPassButtonName(),
                backgroundColor: AppColor_Primary,
                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                width: MediaQuery.of(context).size.width - 60,
                disable: !isPassValid,
                disableBackground: !isPassValid
                    ? AppColor_Primary_Disable
                    : Colors.transparent,
                onPressed: () {
                  if (!isPassValid) {
                    showToast('정보를 확인해주세요.');
                  }
                  focusNode.unfocus();
                  if (nPassStep == 3) {
                    onBackPressed();
                  } else {
                    if (nPassStep == 0) {
                      reqPwSendCode();
                    } else if (nPassStep == 1) {
                      reqFindPwd();
                    } else if (nPassStep == 2) {
                      reqPwdReset();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size scsize = MediaQuery.of(context).size;
    return Scaffold(
      body: PageLayout(
          isLoading: isLoading,
          isAvoidResize: false,
          child: Stack(children: [
            SingleChildScrollView(
              child: SizedBox(
                height: scsize.height - 30,
                child: Column(
                  children: [
                    Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
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
                            Expanded(child: Container())
                          ],
                        )),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              pageType = 1;
                              setState(() {});
                            },
                            child: H24B(
                              text: LanguageService.trans("find_id"),
                              color: pageType == 1
                                  ? AppColor_Primary
                                  : AppColor_BlackText.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              pageType = 2;
                              setState(() {});
                            },
                            child: H24B(
                              text: LanguageService.trans("find_password"),
                              color: pageType == 2
                                  ? AppColor_Primary
                                  : AppColor_BlackText.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: pageType == 1,
                            child: FindIdPage(),
                          ),
                          Visibility(
                            visible: pageType == 2,
                            child: FindPassPage(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: scsize.height - 100,
                ),
                bottomButton(),
              ],
            )
          ])),
    );
  }
}
