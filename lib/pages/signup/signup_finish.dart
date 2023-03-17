// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:extended_image/extended_image.dart';
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
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/home/add_children1.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/notification_alert_widget.dart';
import 'package:ourdoctor/pages/signup/signup3.dart';
import 'package:ourdoctor/pages/tab_main.dart';

class SignupFinishPage extends StatefulWidget {
  SignupFinishPage({Key? key, required this.parentInfo}) : super(key: key);
  // String? id;
  // String? pwd;
  // String? type;
  SignupParentInfo parentInfo;
  @override
  SignupFinishPageState createState() => SignupFinishPageState();
}

class SignupFinishPageState extends BaseState<SignupFinishPage> {
  // final HttpService httpService = HttpService();
  final HttpService httpService = HttpService();
  int child = -1;
  String profileImage = "";

  @override
  void initState() {
    super.initState();

    reqLogin();
    eventBus.on<UpdateUserEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });
  }

  Future<bool> onBackPressed() async {
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

    Future<LoginResModel> offerInfo = httpService.login3(widget.parentInfo.id, widget.parentInfo.pwd, widget.parentInfo.type, token);
    offerInfo.then((LoginResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        LocalService.setUserID(widget.parentInfo.id);
        LocalService.setUserPwd(widget.parentInfo.pwd);
        LocalService.setUserType(widget.parentInfo.type);
        gUserInfo = value.data;
        setState(() {});
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

  //유저자식 선택
  Future<void> reqSelChild() async {
    if (child == -1) {
      return;
    }

    String? uid = gUserInfo!.childList!.elementAt(child).id;
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.selchild(uid!);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        getChildInfo(uid);
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

  //현재 선택된 자식 정보 얻기
  Future<void> getChildInfo(String uid) async {
    setState(() {
      isLoading = true;
    });

    await updateSetting();

    Future<ChildInfoResModel> info = httpService.childInfo2(uid);
    info.then((ChildInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gSelChildInfo = value.data;
        gUserInfo!.selectedChildUid = uid;
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

  Future<void> updateSetting() async {
    String content =
    """
해당 기기로 댓글 알림 등
서비스 이용에 필요한 안내 사항을 
푸시 알림으로 전송하려고 합니다.

앱 푸시에 수신 동의하시겠습니까?""";
    bool? agree = await notificationShowDialogb2(context, "우아닥터에서 시스템 알림을 보내고자 합니다.", content);
    gUserInfo!.systemAlarmYn = "n";
    if (agree) {
      gUserInfo!.systemAlarmYn = "y";
    }

    Future<DefaultResModel> info = httpService.setting(gUserInfo!.alarmYn!, gUserInfo!.systemAlarmYn!);
    info.then((DefaultResModel value) async {
      if (value.result == 0) {
        gUserInfo!.alarmYn = gUserInfo!.alarmYn == "y" ? "n" : "y";
        setState(() {});
      } else {
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      showToast(onError);
    });
  }

  Future<void> getUserInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<UserInfoResModel> info = httpService.userInfo2();
    info.then((UserInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gUserInfo = value.data;
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
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            const SizedBox(height: 45),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: H24B(
                                text: LanguageService.trans("welcome_dot"),
                                color: AppColor_BlackText,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: H22(
                                text: LanguageService.trans("ourdoctor_lower"),
                              ),
                            ),
                            //const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: H18(text: LanguageService.trans("signup_finish_description"), weight: FW.regular, maxLine: 2, align: TextAlign.left, height: 1.6),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              // margin: const EdgeInsets.only(left: 32, right: 32),
                              child: Image.asset(
                                'assets/bg_1_minute.png',
                                width: screenSize.width - 60,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            const SizedBox(height: 50),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: H24B(
                                text: LanguageService.trans("choose_your_child"),
                                color: AppColor_BlackText,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: H16(
                                text: LanguageService.trans("you_can_change_or_add_target_children_in_the_menu"), 
                                weight: FW.regular, 
                                maxLine: 2, 
                                align: TextAlign.left, 
                                height: 1.6, 
                                color: AppColor_BlackText.withOpacity(0.5)
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                                height: 115,
                                width: screenSize.width - 60,
                                decoration: BoxDecoration(color: AppColor_Light_Gray, borderRadius: BorderRadius.circular(30)),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: _itemBuilder,
                                  itemCount: (gUserInfo == null || gUserInfo!.childList == null) ? 0 : (gUserInfo!.childList!.length + 1),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                )),
                            const SizedBox(height: 25),
                            Center(
                              child: MainTextButton(
                                text: LanguageService.trans("getting_started"),
                                backgroundColor: AppColor_Primary,
                                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                                width: MediaQuery.of(context).size.width - 60,
                                height: 58,
                                disable: child == -1,
                                disableBackground: child == -1 ? AppColor_Primary_Disable : Colors.transparent,
                                onPressed: () {
                                  reqSelChild();
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    ChildList info = ChildList();
    if (index < gUserInfo!.childList!.length) {
      info = gUserInfo!.childList!.elementAt(index);
    } else {
      info.name = "";
      info.profileImgUrl = "";
    }

    return InkWell(
        onTap: () {
          if (index < gUserInfo!.childList!.length) {
            child = index;
            setState(() {});
          } else {
            Navigator.push(context, SlideRightTransRoute(builder: (context) => AddChildren1Page()));
          }
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: index < gUserInfo!.childList!.length,
                  child: Container(
                    width: 55,
                    height: 55,
                    padding: EdgeInsets.all(profileImage.isEmpty ? 10 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: child == index ? AppColor_Primary : AppColor_White,
                    ),
                    child: Stack(
                      children: [
                        Visibility(
                            visible: info.profileImgUrl!.isEmpty,
                            child: Center(
                              child: Image.asset(
                                info.gender == 1 ? "assets/ic_default_male.png" : "assets/ic_default_female.png",
                                width: 55,
                                height: 55,
                              ),
                            )),
                        Visibility(
                          visible: info.profileImgUrl!.isNotEmpty,
                          child: ExtendedImage.network(
                            info.profileImgUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            cache: true,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: index == gUserInfo!.childList!.length,
                  child: Image.asset("assets/btn_child_add.png", width: 55, height: 55),
                ),
                const SizedBox(height: 10),
                Visibility(
                    visible: index < gUserInfo!.childList!.length,
                    child: Row(
                      children: [
                        Image.asset(info.gender == 1 ? "assets/ic_male.png" : "assets/ic_female.png", width: 15),
                        const SizedBox(width: 5),
                        H14(text: info.name!, weight: FW.regular),
                      ],
                    )),
                Visibility(
                  visible: index == gUserInfo!.childList!.length,
                  child: H14(text: LanguageService.trans("add_child"), weight: FW.regular),
                ),
              ],
            )));
  }
}
