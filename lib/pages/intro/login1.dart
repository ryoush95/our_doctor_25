// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/signup/agree.dart';
import 'package:ourdoctor/pages/signup/find_info.dart';
import 'package:ourdoctor/pages/tab_main.dart';

class Login1Page extends StatefulWidget {
  Login1Page({Key? key, this.dadHeight = "", this.momHeight = "", this.childHeight = "", this.childWeight = ""}) : super(key: key);
  String? dadHeight;
  String? momHeight;
  String? childHeight;
  String? childWeight;
  @override
  Login1PageState createState() => Login1PageState();
}

class Login1PageState extends BaseState<Login1Page> {
  final HttpService httpService = HttpService();
  var idInputController = TextEditingController();
  var pwdInputController = TextEditingController();
  String id = "";
  String pwd = "";
  bool isValid = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void checkValid() {
    if (id.isEmpty || pwd.isEmpty) {
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }
  }

  // Network functions
  //////////////////////////////////
  //로그인
  Future<void> reqLogin() async {
    String token = await LocalService.getToken();

    setState(() {
      isLoading = true;
    });

    Future<LoginResModel> offerInfo = httpService.login3(id, pwd, "normal", token);
    offerInfo.then((LoginResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        LocalService.setUserID(id);
        LocalService.setUserPwd(pwd);
        LocalService.setUserType("normal");
        gUserInfo = value.data;
        // FirebaseMessaging messaging = FirebaseMessaging.instance;
        // messaging.subscribeToTopic("udoctor");
        print("GETCHILDINFO START ----- ");
        getChildInfo();
        print("GETCHILDINFO END ----- ");
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout(
        isLoading: isLoading,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 55,
                  child: InkWell(
                    onTap: () {
                      onBackPressed();
                    },
                    child: Image.asset(
                      'assets/path_12225.png',
                      width: 10,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                H24B(
                  text: LanguageService.trans("login"),
                  color: AppColor_Primary,
                ),
                const SizedBox(height: 40),
                H14(
                  text: LanguageService.trans("id"),
                  weight: FW.medium,
                  color: AppColor_BlackText.withOpacity(0.5),
                ),
                UnderlineInput(
                  controller: idInputController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  placeholder: LanguageService.trans("id_hint"),
                  onChanged: (text) => {id = text, checkValid()},
                ),
                const SizedBox(height: 30),
                H14(
                  text: LanguageService.trans("password"),
                  weight: FW.medium,
                  color: AppColor_BlackText.withOpacity(0.5),
                ),
                UnderlineInput(
                  controller: pwdInputController,
                  keyboardType: TextInputType.text,
                  isSecure: true,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => {
                    FocusManager.instance.primaryFocus?.unfocus()
                  },
                  placeholder: LanguageService.trans("pass_hint"),
                  onChanged: (text) => {pwd = text, checkValid()},
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // node.nextFocus();
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => FindInfoPage(type: 1)));
                        },
                        child: H14(
                          text: LanguageService.trans("find_id"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 18,
                        color: AppColor_BlackText.withOpacity(0.5),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          // node.nextFocus();
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => FindInfoPage(type: 2)));
                        },
                        child: H14(
                          text: LanguageService.trans("find_password"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: MainTextButton(
                    text: LanguageService.trans("login"),
                    backgroundColor: AppColor_Primary,
                    style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
                    width: MediaQuery.of(context).size.width - 60,
                    disable: !isValid,
                    height: 58,
                    radius: 16,
                    disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                    onPressed: () {
                      if (!isValid) {
                        return;
                      }
                      reqLogin();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    node.nextFocus();
                    Navigator.push(context, SlideRightTransRoute(builder: (context) => AgreePage(snsid: "", type: 'normal', dadHeight: widget.dadHeight, momHeight: widget.momHeight, childHeight: widget.childHeight, childWeight: widget.childWeight)));
                  },
                  child: Container(
                    height: 58,
                    decoration: const BoxDecoration(
                        color: AppColor_Green,
                        // border: Border.all(
                        //   width: 1.0,
                        //   color: const Color(0xFF111112).withOpacity(0.3),
                        // ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        )),
                    child: Center(
                      child: H18(
                        text: LanguageService.trans("signup"),
                        weight: FW.semi_bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ));
  }
}
