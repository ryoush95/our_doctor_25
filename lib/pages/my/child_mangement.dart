import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/header_text.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/dialog/dlg_title_two_btn.dart';
import 'package:ourdoctor/pages/home/add_children1.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/edit_family_history.dart';
import 'package:sprintf/sprintf.dart';

import 'edit_child.dart';

class ChildManagementPage extends StatefulWidget {
  @override
  ChildManagementPageState createState() => ChildManagementPageState();
}

class ChildManagementPageState extends BaseState<ChildManagementPage> {
  final HttpService httpService = HttpService();
  UserInfoDto? userInfo;

  late ScrollController _listController;

  bool valid = false;
  String profileImage = "";
  int child = 0;

  @override
  void initState() {
    super.initState();
    getUserInfo();

    eventBus.on<AddChildrenEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });

    eventBus.on<UpdateUserEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });
    _listController = ScrollController();
    userInfo = gUserInfo;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _listController.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  Future<void> onDelete() async {
    //print(gUserInfo!.childList![child].id);

    String _uid = gUserInfo!.childList![child].id!;
    if (_uid == gSelChildInfo!.id) {
      showToast("현재 선택된 자녀는 삭제하실 수 없습니다.");
      return;
    }
    var _result = await showDialog(context: context, builder: (_) => TwoBtnTitleDialog(title: "알 림", content: "아이를 삭제하시겠습니까?", btn1: "아니요", btn2: "네"));
    if (_result != null && _result == "100") {
      reqDelChild(gUserInfo!.childList![child].id!);
    }
  }

  String getSymptomName() {
    String result = "";

    List<MedicalHistory> lists = userInfo!.childList![child].medicalHistory!;
    if (lists.isEmpty) {
      return result;
    }

    for (int i = 0; i < userInfo!.childList![child].medicalHistory!.length; i++) {
      String content = userInfo!.childList![child].medicalHistory!.elementAt(i).name!;
      String direct = userInfo!.childList![child].medicalHistory!.elementAt(i).detail!;
      if (result == "") {
        result = content == "직접입력" ? direct : content;
      } else {
        result = result + "," + (content == "직접입력" ? direct : content);
      }
    }

    return result;
  }

  String getFamilyHistory(String name) {
    String content = "";
    if (userInfo == null) {
      return content;
    }
    for (int i = 0; i < userInfo!.familyHistory!.length; i++) {
      FamilyHistory info = userInfo!.familyHistory!.elementAt(i);
      if (info.name == name) {
        if (content == "") {
          content = info.detail!;
        } else {
          content = content + "," + info.detail!;
        }
      }
    }
    return content;
  }

  List<FamilyHistory> getOtherFamilyHistoryCnt() {
    List<FamilyHistory> list = [];
    if (userInfo == null) {
      return list;
    }
    List<String> commonSymptoms = ["고혈압", "당뇨", "심/뇌혈관 질환", "천식", "암"];
    for (int i = 0; i < userInfo!.familyHistory!.length; i++) {
      FamilyHistory info = userInfo!.familyHistory!.elementAt(i);
      if (!commonSymptoms.contains(info.name)) {
        if (!isExistFamilyHistory(list, info.name!)) {
          list.add(info);
        }
      }
    }
    return list;
  }

  bool isExistFamilyHistory(List<FamilyHistory> list, String anme) {
    for (int i = 0; i < list.length; i++) {
      FamilyHistory info = list.elementAt(i);
      if (anme == info.name) {
        return true;
      }
    }
    return false;
  }

  // Network functions
  //////////////////////////////////
  //아이삭제
  Future<void> reqDelChild(String uid) async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.delchild(uid);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        getUserInfo();
        child = 1;
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
        userInfo = gUserInfo;
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
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: "가족력, 아이 관리",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    HeaderText(text: "가족력", color: AppColor_BlackText),
                    const SizedBox(height: 10),
                    //고혈압
                    Visibility(
                      visible: getFamilyHistory("고혈압").isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor_Light_Gray,
                            ),
                            child: Row(
                              children: [
                                Container(width: 20),
                                H16(
                                  text: "고혈압",
                                  weight: FW.semi_bold,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Expanded(child: Container()),
                                H16(
                                  text: getFamilyHistory("고혈압"),
                                  weight: FW.regular,
                                  align: TextAlign.right,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Container(width: 20),
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    //당뇨
                    Visibility(
                      visible: getFamilyHistory("당뇨").isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor_Light_Gray,
                            ),
                            child: Row(
                              children: [
                                Container(width: 20),
                                H16(
                                  text: "당뇨",
                                  weight: FW.semi_bold,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Expanded(child: Container()),
                                H16(
                                  text: getFamilyHistory("당뇨"),
                                  weight: FW.regular,
                                  align: TextAlign.right,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Container(width: 20),
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    //심/뇌혈관 질환
                    Visibility(
                      visible: getFamilyHistory("심/뇌혈관 질환").isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor_Light_Gray,
                            ),
                            child: Row(
                              children: [
                                Container(width: 20),
                                H16(
                                  text: "심/뇌혈관 질환",
                                  weight: FW.semi_bold,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Expanded(child: Container()),
                                H16(
                                  text: getFamilyHistory("심/뇌혈관 질환"),
                                  weight: FW.regular,
                                  align: TextAlign.right,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Container(width: 20),
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    //천식
                    Visibility(
                      visible: getFamilyHistory("천식").isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor_Light_Gray,
                            ),
                            child: Row(
                              children: [
                                Container(width: 20),
                                H16(
                                  text: "천식",
                                  weight: FW.semi_bold,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Expanded(child: Container()),
                                H16(
                                  text: getFamilyHistory("천식"),
                                  weight: FW.regular,
                                  align: TextAlign.right,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Container(width: 20),
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    //암
                    Visibility(
                      visible: getFamilyHistory("암").isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor_Light_Gray,
                            ),
                            child: Row(
                              children: [
                                Container(width: 20),
                                H16(
                                  text: "암",
                                  weight: FW.semi_bold,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Expanded(child: Container()),
                                H16(
                                  text: getFamilyHistory("암"),
                                  weight: FW.regular,
                                  align: TextAlign.right,
                                  color: AppColor_BlackText.withOpacity(0.8),
                                ),
                                Container(width: 20),
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: _getTiles,
                      itemCount: getOtherFamilyHistoryCnt().length,
                    ),
                    const SizedBox(height: 20),
                    MainTextButton(
                      text: "가족력 수정하기",
                      backgroundColor: AppColor_Primary,
                      style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                      disableBackground: AppColor_Primary_Disable,
                      onPressed: () {
                        Navigator.push(context, SlideRightTransRoute(builder: (context) => EditFamilyHisPage(usrInfo: userInfo)));
                      },
                    ),
                    const SizedBox(height: 60),
                    HeaderText(text: "아이 관리", color: AppColor_BlackText),
                    const SizedBox(height: 10),
                    Container(
                        height: 125,
                        width: screenSize.width - 60,
                        decoration: BoxDecoration(color: AppColor_Light_Gray, borderRadius: BorderRadius.circular(30)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: _itemBuilder,
                          itemCount: userInfo!.childCount! + 1,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        )),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 3,
                      child: Container(
                        width: screenSize.width - 60,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                padding: EdgeInsets.all(profileImage.isEmpty ? 5 : 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: AppColor_Light_Gray,
                                ),
                                child: Stack(
                                  children: [
                                    // Visibility(
                                    //     visible: profileImage.isEmpty,
                                    //     child: Center(
                                    //       child: Image.asset(
                                    //        "assets/group_19977.png",
                                    //         fit: BoxFit.cover,
                                    //       ),
                                    //     )),
                                    // Visibility(
                                    //   visible: profileImage.isNotEmpty,
                                    //   child: ExtendedImage.network(
                                    //     userInfo!.childList![child].profileImgUrl!,
                                    //     width: 100,
                                    //     height: 100,
                                    //     fit: BoxFit.cover,
                                    //     cache: true,
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    // ),
                                    Visibility(
                                      visible: userInfo!.childList![child].profileImgUrl!.isNotEmpty && !userInfo!.childList![child].profileImgUrl!.contains("img_photo_default"),
                                      child: ExtendedImage.network(
                                        userInfo!.childList![child].profileImgUrl!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        cache: true,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Visibility(
                                        visible: userInfo!.childList![child].profileImgUrl!.isEmpty || userInfo!.childList![child].profileImgUrl!.contains("img_photo_default"),
                                        child: Center(
                                          child: Image.asset(
                                            userInfo!.childList![child].gender == 1 ? "assets/ic_default_male.png" : "assets/ic_default_female.png",
                                            width: 100,
                                            height: 100,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    H14(text: LanguageService.trans("name"), weight: FW.bold, color: AppColor_BlackText.withOpacity(0.8)),
                                    const SizedBox(height: 10),
                                    H16(text: userInfo!.childList![child].name!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.6)),
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Image.asset(userInfo!.childList![child].gender == 1 ? "assets/ic_male.png" : "assets/ic_female.png", width: 20)
                              ],
                            ),
                            const SizedBox(height: 35),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: LanguageService.trans("child_height_weight"), weight: FW.bold, color: AppColor_BlackText.withOpacity(0.8)),
                                const SizedBox(height: 10),
                                H16(text: sprintf("%s cm / %s kg", [userInfo!.childList![child].height, userInfo!.childList![child].weight]), weight: FW.medium, color: AppColor_BlackText.withOpacity(0.6)),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: LanguageService.trans("child_birthday"), weight: FW.bold, color: AppColor_BlackText.withOpacity(0.8)),
                                const SizedBox(height: 10),
                                H16(text: userInfo!.childList![child].birth!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.6)),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: LanguageService.trans("child_past_medical_history"), weight: FW.bold, color: AppColor_BlackText.withOpacity(0.8)),
                                const SizedBox(height: 10),
                                H16(text: getSymptomName(), weight: FW.medium, color: AppColor_BlackText.withOpacity(0.6)),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainTextButton(
                                  text: LanguageService.trans("changing_information"),
                                  width: (screenSize.width - 120) / 2,
                                  style: const TextStyle(color: AppColor_White, fontWeight: FontWeight.w500, fontSize: 17),
                                  onPressed: () {
                                    Navigator.push(context, SlideRightTransRoute(builder: (context) => EditChildPage(child_id: child)));
                                  },
                                ),
                                const SizedBox(width: 10),
                                MainTextButton(
                                  text: LanguageService.trans("delete"),
                                  width: (screenSize.width - 120) / 2,
                                  backgroundColor: AppColor_White,
                                  borderColor: AppColor_Primary,
                                  showBorder: true,
                                  style: const TextStyle(color: AppColor_Primary, fontWeight: FontWeight.w500, fontSize: 17),
                                  onPressed: () {
                                    onDelete();
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              )),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          if (index < userInfo!.childCount!) {
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
                  visible: index < userInfo!.childCount!,
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
                            visible: index < userInfo!.childCount! && (userInfo!.childList![index].profileImgUrl!.isEmpty || userInfo!.childList![index].profileImgUrl!.contains("img_photo_default")),
                            child: Center(
                              child: Image.asset(
                                index > userInfo!.childCount! - 1 ? getRandomImg() : (userInfo!.childList![index].gender == 1 ? "assets/ic_default_male.png" : "assets/ic_default_female.png"), //getRandomImg(),
                                fit: BoxFit.cover,
                              ),
                            )),
                        Visibility(
                          visible: index < userInfo!.childCount! && userInfo!.childList![index].profileImgUrl!.isNotEmpty && !userInfo!.childList![index].profileImgUrl!.contains("img_photo_default"),
                          child: ExtendedImage.network(
                            index < userInfo!.childCount! ? userInfo!.childList![index].profileImgUrl! : "",
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
                Visibility(visible: index == userInfo!.childCount!, child: Image.asset("assets/btn_child_add.png", width: 55, height: 55)),
                const SizedBox(height: 10),
                Visibility(
                    visible: index < userInfo!.childCount!,
                    child: Row(
                      children: [
                        Image.asset(index < userInfo!.childCount! ? (userInfo!.childList![index].gender == 1 ? "assets/ic_male.png" : "assets/ic_female.png") : "", width: 15),
                        const SizedBox(width: 5),
                        H14(text: index < userInfo!.childCount! ? userInfo!.childList![index].name! : "", weight: FW.regular)
                      ],
                    )),
                Visibility(visible: index == userInfo!.childCount!, child: H14(text: LanguageService.trans("add_child"), weight: FW.regular)),
              ],
            )));
  }

  Widget _getTiles(BuildContext context, int index) {
    FamilyHistory info = getOtherFamilyHistoryCnt().elementAt(index);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColor_Light_Gray,
          ),
          child: Row(
            children: [
              Container(width: 20),
              H16(
                text: info.name!,
                weight: FW.semi_bold,
                color: AppColor_BlackText.withOpacity(0.8),
              ),
              Expanded(child: Container()),
              H16(
                text: getFamilyHistory(info.name!),
                weight: FW.regular,
                align: TextAlign.right,
                color: AppColor_BlackText.withOpacity(0.8),
              ),
              Container(width: 20),
            ],
          ),
        ),
        Container(
          height: 8,
        ),
      ],
    );
  }
}
