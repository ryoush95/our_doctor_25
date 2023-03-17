import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/duplicate_res_model.dart';
import 'package:ourdoctor/models/hosiptal_list_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/option_sheet.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/notification_alert_widget.dart';
import 'package:ourdoctor/pages/signup/address.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  ProfileEditPageState createState() => ProfileEditPageState();
}

class ProfileEditPageState extends BaseState<ProfileEditPage> {
  final HttpService httpService = HttpService();
  UserInfoDto? userInfo;
  String id = "";
  String pwd = "";
  String rePwd = "";
  String name = "";
  String nickname = "";
  String birth = "";
  String phone = "";
  String postcode = "";
  String address1 = "";
  String address2 = "";
  bool _pwdRegexValid = false;

  bool valid = true;
  var idController = TextEditingController();
  var pwdController = TextEditingController();
  TextEditingController _rePwdController = TextEditingController();
  var nameController = TextEditingController();
  var nicknameController = TextEditingController();
  var birthController = TextEditingController();
  var phoneController = TextEditingController();
  var codeController = TextEditingController();
  var address1Controller = TextEditingController();
  var address2Controller = TextEditingController();
  var dadheightController = TextEditingController();
  var dadweightController = TextEditingController();
  var momheightController = TextEditingController();
  var momweightController = TextEditingController();

  String mCity = "";
  String mDistrict = "";
  String mHospital = "";
  List<String> districtList = [];
  List<String> hospitalList = [];
  List<HospitalDto> arrHospitalList = [];

  String relationship = "";
  String number_child = "";
  List<String> relationshipList = []; //= ["father", "mother", "grandfather","grandmother","direct input"];
  List<String> childnumberList = ["1", "2", "3", "4", "5", "6"];

  String dad_height = "";
  String dad_weight = "";
  String mom_height = "";
  String mom_weight = "";

  FocusNode? detailAddrFocusNode;

  String relationship_direct = "";
  var relationshipInputController = TextEditingController();
  bool onAlarm = true;
  bool onAlarm2 = true;
  String alarmYn = "y";
  String alarmYn2 = "y";

  int nDuplicatedNickname = 0;
  String mValidNickname = ""; //중복 확인한 닉네임
  @override
  void initState() {
    super.initState();
    detailAddrFocusNode = FocusNode();

    userInfo = gUserInfo;
    id = userInfo!.loginId!;
    // pwd = userInfo!.password!;
    name = userInfo!.name!;
    birth = userInfo!.birth!;
    phone = userInfo!.phone!;
    nickname = userInfo!.nickname!;
    postcode = userInfo!.postcode!;
    address1 = userInfo!.address!;
    address2 = userInfo!.addressDetail!;
    relationship = userInfo!.relationship!;
    number_child = userInfo!.childCount.toString();
    dad_height = userInfo!.dadHeight!; //+ " cm";
    // dad_weight = userInfo!.dadWeight!; //+ " kg";
    mom_height = userInfo!.momHeight!; //+ " cm";
    // mom_weight = userInfo!.momWeight!; //+ " kg";

    idController.text = id;
    pwdController.text = pwd;
    nameController.text = name;
    birthController.text = birth;
    phoneController.text = phone;
    nicknameController.text = nickname;
    codeController.text = postcode;
    address1Controller.text = address1;
    address2Controller.text = address2;

    dadheightController.text = dad_height;
    dadweightController.text = "";
    momheightController.text = mom_height;
    momweightController.text = "";

    setState(() {
      alarmYn = gUserInfo!.alarmYn!;
      alarmYn2 = gUserInfo!.systemAlarmYn!;
      if (alarmYn != 'y') onAlarm = false;
      if (alarmYn2 != 'y') onAlarm2 = false;
    });

    for (int i = 0; i < gRelationList!.length; i++) {
      relationshipList.add(gRelationList![i].relationship!);
    }
    relationshipList.add("기타 입력");

    checkValid();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    detailAddrFocusNode!.dispose();

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
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      birth = _result;
      birthController.text = birth;
      checkValid();
    }
  }

  void onSave() {
    if (!valid) {
      return;
    }
    reqParentEdit();
  }

  void checkValid() {
  if(userInfo!.signupType == "normal") {
      if (relationship == "기타 입력") {
        if (id.isEmpty ||
            // pwd.isEmpty ||
            // rePwd.isEmpty ||
            name.isEmpty ||
            birth.isEmpty ||
            phone.isEmpty ||
            nickname.isEmpty ||
            dad_height.isEmpty ||
            // dad_weight.isEmpty ||
            mom_height.isEmpty ||
            // mom_weight.isEmpty ||
            address1.isEmpty ||
            postcode.isEmpty ||
            relationship_direct.isEmpty ||
            number_child.isEmpty) {
          //address1.isEmpty || address2.isEmpty || relationship.isEmpty || number_child.isEmpty
          setState(() {
            valid = false;
          });
      } else {
        if(pwd == rePwd) {
          setState(() {
            valid = true;
          });
        } else {
          setState(() {
            valid = false;
          });
        }
      }
    } else {
        if (id.isEmpty ||
            // pwd.isEmpty ||
            // rePwd.isEmpty ||
            name.isEmpty ||
            birth.isEmpty ||
            phone.isEmpty ||
            nickname.isEmpty ||
            dad_height.isEmpty ||
            // dad_weight.isEmpty ||
            mom_height.isEmpty ||
            // mom_weight.isEmpty ||
            address1.isEmpty ||
            postcode.isEmpty ||
            relationship.isEmpty ||
            number_child.isEmpty) {
          //address1.isEmpty || address2.isEmpty || relationship.isEmpty || number_child.isEmpty
        setState(() {
          valid = false;
        });
      } else {
         if(pwd == rePwd) {
          setState(() {
            valid = true;
          });
        } else {
          setState(() {
            valid = false;
          });
        }

      }
    }
  } else {
      if (relationship == "기타 입력") {
        if (id.isEmpty ||
            // pwd.isEmpty ||
            // rePwd.isEmpty ||
            name.isEmpty ||
            birth.isEmpty ||
            phone.isEmpty ||
            nickname.isEmpty ||
            dad_height.isEmpty ||
            // dad_weight.isEmpty ||
            mom_height.isEmpty ||
            // mom_weight.isEmpty ||
            address1.isEmpty ||
            postcode.isEmpty ||
            relationship_direct.isEmpty ||
            number_child.isEmpty) {
          //address1.isEmpty || address2.isEmpty || relationship.isEmpty || number_child.isEmpty
          setState(() {
            valid = false;
          });
      } else {
        if(pwd == rePwd) {
          setState(() {
            valid = true;
          });
        } else {
          setState(() {
            valid = false;
          });
        }
      }
    } else {
        if (id.isEmpty ||
            name.isEmpty ||
            birth.isEmpty ||
            phone.isEmpty ||
            nickname.isEmpty ||
            dad_height.isEmpty ||
            // dad_weight.isEmpty ||
            mom_height.isEmpty ||
            // mom_weight.isEmpty ||
            address1.isEmpty ||
            postcode.isEmpty ||
            relationship.isEmpty ||
            number_child.isEmpty) {
          //address1.isEmpty || address2.isEmpty || relationship.isEmpty || number_child.isEmpty
          setState(() {
            valid = false;
        });
      } else {
          setState(() {
            valid = true;
          });
        }

      }
  }
  
  }

  // Network functions
  //////////////////////////////////
  //정보수정하기
  Future<void> reqParentEdit() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo = httpService.changeParentProfile(
        pwd,
        name,
        birth,
        phone,
        postcode,
        address1,
        address2,
        dad_height,
        dad_weight,
        mom_height,
        mom_weight,
        relationship != "기타 입력" ? relationship : relationship_direct,
        nickname,
        alarmYn,
        alarmYn2);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('update_user_success'));
        eventBus.fire(UpdateUserEvent());
        onBackPressed();
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
      //showToast(onError);
    });
  }

  //닉네임 중복 체크
  void reqCheckNickname() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (nickname.isEmpty) {
      showToast("닉네임을 입력해 주세요.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future<DuplicateResModel> info = httpService.checkNickname(nickname);
    info.then((DuplicateResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (value.data!.isDuplicated!) {
          nDuplicatedNickname = 1; //중복된 닉네임
        } else {
          nDuplicatedNickname = 2;
          mValidNickname = nickname;
        }
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

  void selectRelationship() {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return OptionSheet(
              list: relationshipList,
              title: LanguageService.trans('choose_relationship'),
              selectedItem: relationship,
              onPop: (selectedIndex) {
                if (selectedIndex != -1) {
                  setState(() {
                    relationship = relationshipList[selectedIndex];
                  });
                  checkValid();
                } else {
                  setState(() {
                    relationship = '';
                  });
                  checkValid();
                }
              });
        });
  }

  void selectChilds() {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return OptionSheet(
              list: childnumberList,
              title: LanguageService.trans('choose_child_number'),
              selectedItem: number_child,
              onPop: (selectedIndex) {
                if (selectedIndex != -1) {
                  setState(() {
                    number_child = childnumberList[selectedIndex];
                  });
                  checkValid();
                } else {
                  setState(() {
                    number_child = '';
                  });
                  checkValid();
                }
              });
        });
  }

  bool checkPwdRegex() => RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W).{8,16}$").hasMatch(pwdController.text);

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("edit_your_info"),
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
                    Visibility(
                      visible: gUserInfo!.signupType == "normal",
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: H14(
                              text: LanguageService.trans("id"),
                              weight: FW.medium,
                              align: TextAlign.start,
                              color: AppColor_BlackText.withOpacity(0.5),
                            ),
                          ),
                          UnderlineInput(
                            height: 50,
                            controller: idController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            placeholder: LanguageService.trans("enter_id"),
                            readOnly: true,
                            onChanged: (text) => {id = text, checkValid()},
                          ),
                          const SizedBox(height: 30),
                          pwdInput(),
                        ],
                      ),
                    ),
                    H14(
                      text: LanguageService.trans("name"),
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    UnderlineInput(
                      height: 50,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => node.nextFocus(),
                      placeholder: LanguageService.trans("enter_your_name"),
                      onChanged: (text) => {name = text, checkValid()},
                    ),
                    const SizedBox(height: 30),
                    H14(
                      text: "닉네임",
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: UnderlineInput(
                            height: 50,
                            controller: nicknameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            placeholder: "닉네임 입력",
                            onChanged: (text) => {nickname = text, checkValid()},
                          ),
                        ),
                        const SizedBox(width: 10),
                        MainTextButton(
                          text: "중복확인",
                          backgroundColor: const Color(0xFFF4F9FF),
                          style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                          width: 76,
                          height: 36,
                          onPressed: () {
                            reqCheckNickname();
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 9),
                      child: H12(
                        text: nDuplicatedNickname == 0 ? " " : (nDuplicatedNickname == 1 ? "중복 닉네임은 사용할 수 없습니다" : "사용가능한 닉네임입니다"),
                        weight: FW.medium,
                        color: nDuplicatedNickname == 1 ? AppColor_Red : AppColor_Primary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    H14(
                      text: LanguageService.trans("birth_date"),
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                        controller: birthController,
                        onEditingComplete: () => node.nextFocus(),
                        maxLines: 1,
                        maxLength: -1,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.next,
                        enableInteractiveSelection: false,
                        focusNode: AlwaysDisabledFocusNode(),
                        onTap: () {
                          showBirthdayDlg();
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor_Selector_Border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor_BlackText),
                          ),
                          hintText: "YYMMDD",
                          hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    H14(
                      text: LanguageService.trans("phone"),
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    UnderlineInput(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => node.nextFocus(),
                      placeholder: LanguageService.trans("enter_only_numbers"),
                      onChanged: (text) => {phone = text, checkValid()},
                    ),
                    const SizedBox(height: 30),
                    H14(
                      text: LanguageService.trans("address"),
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  UnderlineInput1(
                                    height: MediaQuery.of(context).size.height,
                                    controller: codeController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () => node.nextFocus(),
                                    placeholder: LanguageService.trans("post_num"),
                                    onChanged: (text) => {address1 = text, checkValid()},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          MainTextButton(
                            text: "검색",
                            backgroundColor: const Color(0xFFF4F9FF),
                            style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                            width: 76,
                            height: 36,
                            onPressed: () async {
                              Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => AddressSearchPage()));
                              detailAddrFocusNode!.requestFocus();
                              postcode = received["postcode"];
                              address1 = received["addr"];
                              checkValid();
                              codeController.text = postcode;
                              address1Controller.text = address1;
                              //getHospitalFromAddress();
                            },
                          ),
                          // MainTextButton(
                          //   text: LanguageService.trans("search"),
                          //   backgroundColor: AppColor_Primary,
                          //   style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                          //   width: 90,
                          //   disable: true,
                          //   disableBackground: AppColor_BlackText,
                          //   onPressed: () async {
                          //     Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => AddressSearchPage()));
                          //     detailAddrFocusNode!.requestFocus();
                          //     postcode = received["postcode"];
                          //     address1 = received["addr"];
                          //     checkValid();
                          //     codeController.text = postcode;
                          //     address1Controller.text = address1;
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: UnderlineInput1(
                        controller: address1Controller,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () => node.nextFocus(),
                        placeholder: LanguageService.trans("address1"),
                        onChanged: (text) => {address1 = text, checkValid()},
                      ),
                    ),
                    SizedBox(
                        height: 50,
                        child: Center(
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                            maxLength: -1,
                            controller: address2Controller,
                            onEditingComplete: () => node.nextFocus(),
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.done,
                            focusNode: detailAddrFocusNode,
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColor_Selector_Border),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColor_BlackText),
                              ),
                              hintText: LanguageService.trans("address2"),
                              hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) => {address2 = text, checkValid()},
                          ),
                        )),
                    const SizedBox(height: 30),
                    H14(
                      text: LanguageService.trans("relationship_with_children"),
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    const SizedBox(height: 15),
                    // UnderlineSelector(
                    //     selectedCategory: relationship,
                    //     categoryList: relationshipList,
                    //     onSelect: (selectedCategory) {
                    //       setState(() {
                    //         relationship = selectedCategory!;
                    //         //getDistrictList();
                    //       });
                    //     },
                    //     hint: LanguageService.trans("please_select_a_relationship")),
                    InkWell(
                      child: Column(children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(relationship == '' ? LanguageService.trans('please_select_a_relationship') : relationship, style: relationship == '' ? AppTextStyle.PD(AppColor_BlackText.withOpacity(0.4), 16, weight: FW.medium) : AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium)),
                            Expanded(child: Container()),
                            Image.asset('assets/polygon_7.png', width: 12),
                            const SizedBox(width: 20)
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Divider(thickness: 1, color: AppColor_Selector_Border)
                      ]),
                      onTap: selectRelationship,
                    ),
                    Visibility(
                      visible: relationship == "기타 입력",
                      child: UnderlineInput(
                        controller: relationshipInputController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        onEditingComplete: () => node.nextFocus(),
                        placeholder: LanguageService.trans("enter_relationship"),
                        onChanged: (text) => {relationship_direct = text, checkValid()},
                      ),
                    ),
                    const SizedBox(height: 30),
                    H14(
                      text: LanguageService.trans("number_of_children"),
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.5),
                    ),
                    // UnderlineSelector(
                    //   selectedCategory: "3",
                    //   categoryList: childnumberList,
                    //   onSelect: (selectedCategory) {
                    //     setState(() {
                    //       number_child = selectedCategory!;
                    //       //getDistrictList();
                    //     });
                    //   },
                    //   hint: LanguageService.trans("please_select_the_number_of_children")),
                    const SizedBox(height: 15),
                    InkWell(
                      child: Column(children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(number_child == '' ? LanguageService.trans('please_select_the_number_of_children') : number_child, style: number_child == '' ? AppTextStyle.PD(AppColor_BlackText.withOpacity(0.4), 16, weight: FW.medium) : AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium)),
                            Expanded(child: Container()),
                            Image.asset('assets/polygon_7.png', width: 12),
                            const SizedBox(width: 20)
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Divider(thickness: 1, color: AppColor_Selector_Border)
                      ]),
                      onTap: selectChilds,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: (screenSize.width - 70) / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H16(text: LanguageService.trans("dad_height"), weight: FW.medium, color: AppColor_BlackText),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: screenSize.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: OutlineNumInput(
                                        controller: dadheightController,
                                        keyboardType: const TextInputType.numberWithOptions(
                                          decimal: true,
                                          signed: true,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => node.nextFocus(),
                                        placeholder: "",
                                        onChanged: (text) => {dad_height = text, checkValid()},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    H17(
                                      text: LanguageService.trans("cm"),
                                      weight: FW.medium,
                                      color: AppColor_BlackText,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                    //     SizedBox(
                    //       width: (screenSize.width - 70) / 2,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           H16(text: LanguageService.trans("dad_weight"), weight: FW.medium, color: AppColor_BlackText),
                    //           const SizedBox(height: 10),
                    //           SizedBox(
                    //             width: screenSize.width,
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Expanded(
                    //                   child: OutlineNumInput(
                    //                     controller: dadweightController,
                    //                     keyboardType: const TextInputType.numberWithOptions(
                    //                       decimal: true,
                    //                       signed: true,
                    //                     ),
                    //                     textInputAction: TextInputAction.next,
                    //                     onEditingComplete: () => node.nextFocus(),
                    //                     placeholder: "",
                    //                     onChanged: (text) => {dad_weight = text, checkValid()},
                    //                   ),
                    //                 ),
                    //                 const SizedBox(width: 10),
                    //                 H17(
                    //                   text: LanguageService.trans("kg"),
                    //                   weight: FW.medium,
                    //                   color: AppColor_BlackText,
                    //                 ),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: (screenSize.width - 70) / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H16(text: LanguageService.trans("mom_kidney"), weight: FW.medium, color: AppColor_BlackText),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: screenSize.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: OutlineNumInput(
                                        controller: momheightController,
                                        keyboardType: const TextInputType.numberWithOptions(
                                          decimal: true,
                                          signed: true,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => node.nextFocus(),
                                        placeholder: "",
                                        onChanged: (text) => {mom_height = text, checkValid()},
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    H17(
                                      text: LanguageService.trans("cm"),
                                      weight: FW.medium,
                                      color: AppColor_BlackText,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // SizedBox(
                        //   width: (screenSize.width - 70) / 2,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       H16(text: LanguageService.trans("mom_weight"), weight: FW.medium, color: AppColor_BlackText),
                        //       const SizedBox(height: 10),
                        //       SizedBox(
                        //         width: screenSize.width,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Expanded(
                        //               child: OutlineNumInput(
                        //                 controller: momweightController,
                        //                 keyboardType: const TextInputType.numberWithOptions(
                        //                   decimal: true,
                        //                   signed: true,
                        //                 ),
                        //                 textInputAction: TextInputAction.done,
                        //                 placeholder: "",
                        //                 onChanged: (text) => {mom_weight = text, checkValid()},
                        //               ),
                        //             ),
                        //             const SizedBox(width: 10),
                        //             H17(
                        //               text: LanguageService.trans("kg"),
                        //               weight: FW.medium,
                        //               color: AppColor_BlackText,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          H16(
                            text: '시스템 알림',
                            weight: FW.medium,
                            color: AppColor_BlackText,
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: AppColor_Primary,
                              value: onAlarm2,
                              onChanged: (bool value) {
                                setState(() {
                                  onAlarm2 = value;
                                  onAlarm2 ? alarmYn2 = 'y' : alarmYn2 = 'n';
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          H16(
                            text: '광고/마케팅 알림',
                            weight: FW.medium,
                            color: AppColor_BlackText,
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: AppColor_Primary,
                              value: onAlarm,
                              onChanged: (bool value) async {
                                onAlarm = value;
                                onAlarm ? alarmYn = 'y' : alarmYn = 'n';
                                String content =
                                """
전송자 : 우아닥터
일시 : ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일
내용 : ${value ? "수신 동의 완료" : "수신거부 처리 완료"}

광고성 정보 수신 동의는 마이페이지>내 정보>정보 수정하기에서 변경 가능합니다.""";
                                await notificationShowDialogb1(context,"광고성 정보 수신 동의 처리 결과",content);
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    MainTextButton(
                      text: LanguageService.trans("save"),
                      backgroundColor: AppColor_Primary,
                      style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                      disable: !valid,
                      disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
                      onPressed: () {
                        if ((gUserInfo!.nickname != nickname) && (nDuplicatedNickname != 2 || (nDuplicatedNickname == 2 && mValidNickname != nickname))) {
                          showToast("닉네임 중복확인 해주세요.");
                          return;
                        }
                        onSave();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )),
            ),
          ],
        ));
  }

  pwdInput() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
      width: MediaQuery.of(context).size.width,
      child: H14(
        text: LanguageService.trans("password"),
        weight: FW.medium,
        align: TextAlign.start,
        color: AppColor_BlackText.withOpacity(0.5),
      ),
    ),
    UnderlineInput(
      height: 50,
      controller: pwdController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      isSecure: true,
      placeholder: LanguageService.trans("enter_password"),
      onChanged: (text) {
        pwd = text; 
        setState(() {});
        checkPwdRegex();
        checkValid();
      },
    ),
    pwdController.text.isNotEmpty
      ? Container(
        margin: const EdgeInsets.only(top: 9),
        child: H12(
          text: checkPwdRegex()
            ? ""
            : "비밀번호는 8-16자 사이의 영문 대소문자, 숫자, 특수기호를 각 1개 이상 포함해야 합니다",
          weight: FW.medium,
          align: TextAlign.start,
          color: AppColor_Red,
        ),
      )
      : const SizedBox(),
      const SizedBox(height: 13),
      H14(
        text: "비밀번호 확인",
        weight: FW.medium,
        color: AppColor_BlackText.withOpacity(0.5),
      ),
      UnderlineInput(
        controller: _rePwdController,
        keyboardType: TextInputType.text,
        isSecure: true,
        textInputAction: TextInputAction.done,
        placeholder: "비밀번호 재입력",
        onChanged: (text) {
          rePwd = text;
          setState(() {});
          checkValid();
        },
      ),
      _rePwdController.text.isNotEmpty
      ? Container(
        margin: const EdgeInsets.only(top: 9),
        child: H12(
          text: pwd == rePwd
            ? ""
            : "비밀번호가 일치하지 않습니다",
          // text: ((pwd.isEmpty && pwd1.isEmpty) || (pwd == pwd1)) ? " " : "비밀번호가 일치하지 않습니다",
          weight: FW.medium,
          color: AppColor_Red,
        ),
      )
      : const SizedBox(),
      const SizedBox(height: 30),
    ]
  );
}
