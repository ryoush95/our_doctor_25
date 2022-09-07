import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/childinfo_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/intro/login1.dart';
import 'package:ourdoctor/pages/signup/agree.dart';
import 'package:ourdoctor/pages/tab_main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key? key, this.dadHeight = "", this.momHeight = "", this.childHeight = "", this.childWeight = ""}) : super(key: key);

  String? dadHeight;
  String? momHeight;
  String? childHeight;
  String? childWeight;
  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends BaseState<FirstPage> {
  int backButtonTimestamp = 0;
  final HttpService httpService = HttpService();

  static final FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();
  String signupType = 'normal';
  late String id = "";
  late String password = "";
  late GoogleSignIn googleSignIn;

  @override
  void initState() {
    super.initState();
    googleSignIn = GoogleSignIn();
    load();
  }

  void onSnsLogin(String type) {
    setState(() {
      signupType = type;
    });

    onAuth();
  }

  Future<void> onAuth() async {
    if (signupType == "apple") {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.userIdentifier == "") {
        showToast("애플 로그인 실패되었습니다.");
        return;
      }
      id = credential.userIdentifier!;
      password = credential.userIdentifier!;
      reqLogin();
    } else if (signupType == "naver") {
      NaverLoginResult res = await FlutterNaverLogin.logIn();


      setState(() {
        if (res.account.id == "") {
          showToast("네이버 로그인 실패되었습니다.");
          return;
        }
        id = res.account.id;
        password = res.account.id;

        FlutterNaverLogin.logOut();
        reqLogin();
      });
    } else if (signupType == "kakao") {
      try {
        final result = await kakaoSignIn.logIn();

        final result1 = await kakaoSignIn.getUserMe();
        final KakaoAccountResult? account = result1.account;

        if (account != null) {
          if (account.userID == "") {
            showToast("카카오 로그인 실패되었습니다.");
            return;
          }
          id = account.userID!;
          password = account.userID!;
          kakaoSignIn.logOut();
          reqLogin();
        }
      } on PlatformException catch (e) {
        print("${e.code} ${e.message}");
      }
    } else if (signupType == "google") {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      GoogleSignInAuthentication authentication = await account!.authentication;

      // showToast("Google ID =" + account.id);
      if (account.id == "") {
        showToast("구글 로그인 실패되었습니다.");
        return;
      }
      id = account.id;
      password = account.id;
      reqLogin();
    }
  }

  void load() async {
    // Kakao SDK Init (Set NATIVE_APP_KEY)
    await kakaoSignIn.init('66bed5a0bb50d14d57e723a72ec24ce8');
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

  // Network functions
  //////////////////////////////////

  //로그인
  Future<void> reqLogin() async {
    String token = await LocalService.getToken();

    setState(() {
      isLoading = true;
    });

    Future<LoginResModel> offerInfo = httpService.login3(id, password, signupType, token);
    offerInfo.then((LoginResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        LocalService.setUserID(id);
        LocalService.setUserPwd(password);
        LocalService.setUserType(signupType);
        gUserInfo = value.data;
        // FirebaseMessaging messaging = FirebaseMessaging.instance;
        // messaging.subscribeToTopic("udoctor");

        getChildInfo();
      } else {
        Navigator.push(context, SlideRightTransRoute(builder: (context) => AgreePage(snsid: id, type: signupType)));
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //현재 선택된 자식 정보 얻기
  Future<void> getChildInfo() async {
    setState(() {
      isLoading = true;
    });
    String childUid = "";
    if (gUserInfo!.selectedChildUid == null || gUserInfo!.selectedChildUid == "") {
      gUserInfo!.selectedChildUid = gUserInfo!.id;
      childUid = gUserInfo!.id!;
    } else {
      childUid = gUserInfo!.selectedChildUid!;
    }

    Future<ChildInfoResModel> info = httpService.childInfo2(childUid);
    info.then((ChildInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gSelChildInfo = value.data;
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => TabMainPage()));
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

  //////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset('assets/ic_login_logo.png', width: 90, height: 90),
                ),
                const SizedBox(height: 37),
                Center(
                  child: H20(text: LanguageService.trans("intro2_title"), weight: FW.bold, maxLine: 1, height: 1.3),
                ),
                const SizedBox(height: 10),
                Center(
                  child: H20(
                    text: LanguageService.trans("our_children_hospital1"),
                    weight: FW.regular,
                    maxLine: 10,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: () {
                    onSnsLogin('kakao');
                  },
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 58,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          decoration: const BoxDecoration(color: Color(0xFFFFEC00), borderRadius: BorderRadius.all(Radius.circular(16))),
                          child: Stack(
                            children: [
                              Center(
                                child: H18(
                                  text: LanguageService.trans("kakao_login"),
                                  weight: FW.medium,
                                  height: 1.5,
                                  color: const Color(0xFF401C1D),
                                ),
                              ),
                              Positioned(
                                child: Image.asset('assets/ic_kakaotalk.png', width: 26, height: 24),
                                left: 24,
                                top: 17,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    onSnsLogin('naver');
                  },
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 58,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          decoration: const BoxDecoration(color: Color(0xFF5ECB6A), borderRadius: BorderRadius.all(Radius.circular(16))),
                          child: Stack(
                            children: [
                              Center(
                                child: H18(
                                  text: LanguageService.trans("naver_login"),
                                  weight: FW.medium,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                child: Image.asset('assets/ic_naver.png', width: 24, height: 24),
                                left: 24,
                                top: 17,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: const SizedBox(height: 10),
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: InkWell(
                    onTap: () {
                      onSnsLogin('apple');
                    },
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 58,
                            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: const BoxDecoration(
                                color: AppColor_BlackText,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                )),
                            child: Stack(
                              children: [
                                Center(
                                  child: H18(
                                    text: LanguageService.trans("apple_login"),
                                    weight: FW.medium,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  child: Image.asset('assets/ic_apple.png', width: 24, height: 29),
                                  left: 24,
                                  top: 17,
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    onSnsLogin('google');
                  },
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 58,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              border: Border.all(
                                color: AppColor_BlackText.withOpacity(0.2),
                                width: 1,
                              )),
                          child: Stack(
                            children: [
                              Center(
                                child: H18(
                                  text: LanguageService.trans("google_login"),
                                  weight: FW.semi_bold,
                                  height: 1.5,
                                  color: AppColor_BlackText,
                                ),
                              ),
                              Positioned(
                                child: Image.asset('assets/ic_google.png', width: 24, height: 24),
                                left: 24,
                                top: 17,
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(context, SlideRightTransRoute(builder: (context) => Login1Page(dadHeight: widget.dadHeight, momHeight: widget.momHeight, childHeight: widget.childHeight, childWeight: widget.childWeight)));
                  },
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 58,
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          decoration: const BoxDecoration(color: Color(0xFF4B9EFF), borderRadius: BorderRadius.all(Radius.circular(16))),
                          child: Center(
                            child: H18(
                              text: LanguageService.trans("getting_started_another_way"),
                              weight: FW.medium,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ));
  }
}
