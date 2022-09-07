import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/profile_edit.dart';
import 'package:ourdoctor/pages/my/profile_item.dart';
import 'package:sprintf/sprintf.dart';

class ProfileViewPage extends StatefulWidget {
  @override
  ProfileViewPageState createState() => ProfileViewPageState();
}

class ProfileViewPageState extends BaseState<ProfileViewPage> {
  String profileImage = "";
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();

  String? chatNum = "";

  @override
  void initState() {
    super.initState();

    getUserInfo();

    eventBus.on<UpdateUserEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void onEdit() {
    Navigator.push(context, SlideRightTransRoute(builder: (context) => ProfileEditPage()));
  }

  void onUserExit() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                H18(text: "회원탈퇴", height: 1.5, weight: FW.bold),
                const SizedBox(height: 15),
                H16(text: "정말 회원탈퇴 하시겠습니까?", height: 1.5, weight: FW.regular),
                const SizedBox(height: 5),
                H12(
                  text: "(회원가입 탈퇴시 기존 이용내역(모니터링 기록, 포인트 내역 등)은\n모두 삭제됩니다. 탈퇴 후 재가입이 가능합니다.)",
                  height: 1.5,
                  weight: FW.regular,
                  maxLine: 5,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: H16(text: LanguageService.trans('confirm'), color: AppColor_Red, weight: FW.medium),
                        onTap: reqUserExit,
                      ),
                      InkWell(
                        child: H16(text: LanguageService.trans('cancel'), weight: FW.medium),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  // Network functions
  //////////////////////////////////
  //회원탈퇴
  Future<void> reqUserExit() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.userExit();
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast("회원탈퇴 되었습니다.");
        LocalService.setUserID("");
        LocalService.setUserPwd("");
        LocalService.setUserType("");
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
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
      print(onError.toString());
      showToast(onError.toString());
    });
  }

  //회원정보 얻기
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
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("my_info"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Visibility(
                      visible: gUserInfo!.signupType == "normal",
                      child: Observer(
                        builder: (_) => ProfileItem(title: LanguageService.trans("id"), content: gUserInfo!.loginId!, type: 0),
                      ),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("name"), content: gUserInfo!.name!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: "닉네임", content: gUserInfo!.nickname!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("birth_date"), content: gUserInfo!.birth!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("phone"), content: gUserInfo!.phone!, type: 0),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          H14(
                            text: LanguageService.trans("address"),
                            weight: FW.bold,
                            color: AppColor_BlackText.withOpacity(0.8),
                          ),
                          const SizedBox(height: 7),
                          H16(
                            text: "(" + gUserInfo!.postcode! + ") " + gUserInfo!.address! + (gUserInfo!.addressDetail! == "" ? "" : "\n" + gUserInfo!.addressDetail!),
                            weight: FW.medium,
                            color: AppColor_BlackText.withOpacity(0.6),
                            maxLine: 10,
                            height: 1.3,
                            align: TextAlign.left,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("relationship_with_children"), content: gUserInfo!.relationship!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("number_of_children"), content: gUserInfo!.childCount.toString(), type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("dad_height_weight"), content: sprintf("%s cm / %s kg", [gUserInfo!.dadHeight!, gUserInfo!.dadWeight!]), type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("mom_height_weight"), content: sprintf("%s cm / %s kg", [gUserInfo!.momHeight!, gUserInfo!.momWeight!]), type: 0),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MainTextButton(
                        text: LanguageService.trans("edit_your_info"),
                        backgroundColor: AppColor_Primary,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        height: 58,
                        onPressed: () {
                          onEdit();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          onUserExit();
                        },
                        child: Center(
                          child: H16(text: LanguageService.trans("withdrawal"), weight: FW.regular, color: AppColor_GrayText),
                        )),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
