import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/duplicate_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/option_sheet.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/components/underline_num_input.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/signup/address.dart';
import 'package:ourdoctor/pages/signup/signup2.dart';
import 'package:ourdoctor/pages/signup/signup3.dart';

import 'back_confirm_dialog.dart';

class SignUpParentPage extends StatefulWidget {
  SignUpParentPage({Key? key, required this.snsid, required this.type, this.dadHeight = "", this.momHeight = "", this.childHeight = "", this.childWeight = "", required this.alarm}) : super(key: key);
  String? snsid;
  String? type;
  String? dadHeight;
  String? momHeight;
  String? childHeight;
  String? childWeight;
  String? alarm;

  @override
  SignUpParentPageState createState() => SignUpParentPageState();
}

class SignUpParentPageState extends BaseState<SignUpParentPage> {
  final HttpService httpService = HttpService();
  var idInputController = TextEditingController();
  var pwdInputController = TextEditingController();
  var pwdInputController1 = TextEditingController();
  var nameInputController = TextEditingController();
  var nicknameInputController = TextEditingController();
  var phoneInputController = TextEditingController();
  var birthInputController = TextEditingController();
  var address1InputController = TextEditingController();
  var address2InputController = TextEditingController();
  var address3InputController = TextEditingController();
  var dadheightInputController = TextEditingController();
  // var dadweightInputController = TextEditingController();
  var momheightInputController = TextEditingController();
  // var momweightInputController = TextEditingController();
  var relationshipInputController = TextEditingController();

  String id = "";
  String pwd = "";
  String pwd1 = "";
  String name = "";
  String nickname = "";
  String birth = "";
  String phone = "";
  String address1 = ""; //우편번호
  String address2 = ""; //주소 1
  String address3 = ""; //주소 2

  String dad_height = "";
  // String dad_weight = "";
  String mom_height = "";
  // String mom_weight = "";

  String relationship = "";
  String relationship_direct = "";
  String number_child = "1";
  List<String> relationshipList = []; //["father","mother","grandfather","grandmother", "direct input"];
  List<String> childnumberList = [];

  bool isValid = false;
  bool isSame = false;
  bool _idRegexValid = false;
  bool _pwdRegexValid = false;

  int nDuplicatedId = 0;
  String mValidId = ""; //중복 확인한 아이디
  int nDuplicatedNickname = 0;
  String mValidNickname = ""; //중복 확인한 닉네임

  // FocusNode? detailAddrFocusNode;
  @override
  void initState() {
    super.initState();
    // detailAddrFocusNode = FocusNode();

    for (var i = 0; i < 20; i++) {
      childnumberList.add((i + 1).toString());
    }

    if (widget.snsid != "") {
      id = widget.snsid!;
      pwd = widget.snsid!;
      pwd1 = widget.snsid!;
    }

    for (int i = 0; i < gRelationList!.length; i++) {
      relationshipList.add(gRelationList![i].relationship!);
    }
    relationshipList.add("기타 입력");

    dad_height = widget.dadHeight!;
    mom_height = widget.momHeight!;
    dadheightInputController.text = widget.dadHeight!;
    momheightInputController.text = widget.momHeight!;

    checkValid();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    // detailAddrFocusNode!.dispose();

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return const BackConfirmDialog();
        });
    //Navigator.of(context).pop();
    return true;
  }

  bool checkRegex({required bool isId}) {
    if(isId) {
     return RegExp(r"^[a-z0-9_-]{5,20}$").hasMatch(
      idInputController.text
     );
    } else {
      // return true;
      return RegExp(r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W).{8,16}$").hasMatch(
        pwdInputController.text,
      );
    }
  }

  void checkValid() {
    if(widget.snsid != "" && widget.snsid != null) {
      if (id.isEmpty ||
        pwd.isEmpty ||
        pwd1.isEmpty ||
        pwd != pwd1 ||
        name.isEmpty ||
        nickname.isEmpty ||
        birth.isEmpty ||
        phone.isEmpty ||
        dad_height.isEmpty ||
        // dad_weight.isEmpty ||
        mom_height.isEmpty ||
        // mom_weight.isEmpty ||
        address1.isEmpty ||
        address2.isEmpty /*|| address3.isEmpty */ ||
        (relationship == "기타 입력" && relationship_direct.isEmpty) ||
        relationship.isEmpty ||
        pwd != pwd1 ||
        number_child.isEmpty
        ) {
      //address1.isEmpty || address2.isEmpty || relationship.isEmpty || number_child.isEmpty
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }
    } else {
      if (id.isEmpty ||
        pwd.isEmpty ||
        pwd1.isEmpty ||
        pwd != pwd1 ||
        name.isEmpty ||
        nickname.isEmpty ||
        birth.isEmpty ||
        phone.isEmpty ||
        dad_height.isEmpty ||
        // dad_weight.isEmpty ||
        mom_height.isEmpty ||
        // mom_weight.isEmpty ||
        address1.isEmpty ||
        address2.isEmpty /*|| address3.isEmpty */ ||
        (relationship == "기타 입력" && relationship_direct.isEmpty) ||
        relationship.isEmpty ||
        pwd != pwd1 ||
        number_child.isEmpty ||
        !_idRegexValid ||
        !_pwdRegexValid
        ) {
      //address1.isEmpty || address2.isEmpty || relationship.isEmpty || number_child.isEmpty
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }
    }
  }

  Future<void> showBirthdayDlg() async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      birth = _result;
      birthInputController.text = birth;
      checkValid();
    }
  }

  void goNext() {
    FocusScope.of(context).requestFocus(FocusNode());
    SignupParentInfo info = SignupParentInfo(id, pwd, name, birth, phone, address1, address2, address3, isSame, relationship != "기타 입력" ? relationship : relationship_direct, int.parse(number_child), dad_height, mom_height, widget.type!, nickname, widget.alarm!);
    Navigator.push(context, SlideRightTransRoute(builder: (context) => SignupFamilyPage(info: info, childHeight: widget.childHeight, childWeight: widget.childWeight)));
  }

  Future<void> selectRelationship() async {
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

    // Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => RelationshipPage(list: relationshipList, selectedItem: relationship)));
    // relationship = received["postcode"];
    // checkValid();
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

  // Network functions
  //////////////////////////////////
  //아이디 중복 체크
  void reqCheckLoginId() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (id.isEmpty) {
      showToast("아이디를 입력해 주세요.");
      return;
    }
    setState(() {
      isLoading = true;
    });

    Future<DuplicateResModel> info = httpService.checkLoginId(id);
    info.then((DuplicateResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (value.data!.isDuplicated!) {
          nDuplicatedId = 1; //중복된 아이디
        } else {
          nDuplicatedId = 2;
          mValidId = id;
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                    height: 55,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        H24B(
                          text: LanguageService.trans("parent_basic_information"),
                          color: AppColor_BlackText,
                        ),
                        const SizedBox(height: 40),
                        Visibility(
                          visible: widget.type == "normal",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H14(
                                text: LanguageService.trans("id"),
                                weight: FW.medium,
                                color: AppColor_BlackText.withOpacity(0.5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: UnderlineInput(
                                      controller: idInputController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => node.nextFocus(),
                                      placeholder: LanguageService.trans("enter_id"),
                                      onChanged: (text) {
                                        id = text;
                                        _idRegexValid = checkRegex(isId: true);
                                        setState(() {});
                                        checkValid();
                                      },
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
                                      if(_idRegexValid) {
                                        reqCheckLoginId();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              idInputController.text.length > 0 
                              ? Container(
                                margin: const EdgeInsets.only(top: 9),
                                child: H12(
                                  text: _idRegexValid
                                    ? nDuplicatedId == 0 
                                      ? " "
                                      : (nDuplicatedId == 1 ? "중복 아이디는 사용할 수 없습니다." : "사용가능한 아이디입니다.")
                                    : "아이디는 5-20자 사이의 영문 소문자, 숫자, 특수기호 ('_', '-') 만 사용 가능합니다.",
                                  weight: FW.medium,
                                  align: TextAlign.start,
                                  color: nDuplicatedId == 1 || !_idRegexValid ? AppColor_Red : AppColor_Primary,
                                ),
                              )
                              : const SizedBox(height: 9),
                              const SizedBox(height: 13),
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
                                onEditingComplete: () => node.nextFocus(),
                                placeholder: LanguageService.trans("enter_password"),
                                onChanged: (text) {
                                  pwd = text;
                                  _pwdRegexValid = checkRegex(isId: false);
                                  checkValid();
                                },
                              ),
                              pwdInputController.text.length > 0 
                              ? Container(
                                margin: const EdgeInsets.only(top: 9),
                                child: H12(
                                  text: _pwdRegexValid
                                    ? ""
                                    : "비밀번호는 8-16자 사이의 영문 대소문자, 숫자, 특수기호를 각 1개 이상 포함해야 합니다.",
                                  weight: FW.medium,
                                  align: TextAlign.start,
                                  color: AppColor_Red,
                                ),
                              )
                              : const SizedBox(height: 13),
                              const SizedBox(height: 13),
                              H14(
                                text: "비밀번호 확인",
                                weight: FW.medium,
                                color: AppColor_BlackText.withOpacity(0.5),
                              ),
                              UnderlineInput(
                                controller: pwdInputController1,
                                keyboardType: TextInputType.text,
                                isSecure: true,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () => node.nextFocus(),
                                placeholder: "비밀번호 재입력",
                                onChanged: (text) => {pwd1 = text, checkValid()},
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 9),
                                child: H12(
                                  text: ((pwd.isEmpty && pwd1.isEmpty) || (pwd == pwd1)) ? " " : "비밀번호가 일치하지 않습니다.",
                                  weight: FW.medium,
                                  color: AppColor_Red,
                                ),
                              ),
                              Visibility(
                                visible: widget.type == "normal",
                                child: const SizedBox(height: 13),
                              ),
                            ],
                          ),
                        ),
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
                                controller: nicknameInputController,
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
                            text: nDuplicatedNickname == 0 ? " " : (nDuplicatedNickname == 1 ? "중복 닉네임은 사용할 수 없습니다." : "사용가능한 닉네임입니다."),
                            weight: FW.medium,
                            color: nDuplicatedNickname == 1 ? AppColor_Red : AppColor_Primary,
                          ),
                        ),
                        const SizedBox(height: 13),
                        H14(
                          text: LanguageService.trans("birth_date"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                            controller: birthInputController,
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
                              hintText: "YYYY-MM-DD",
                              hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        H14(
                          text: LanguageService.trans("phone_number"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        UnderlineNumInput(
                          controller: phoneInputController,
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          textInputAction: TextInputAction.done,
                          placeholder: LanguageService.trans("enter_only_numbers"),
                          onChanged: (text) => {phone = text, checkValid()},
                        ),
                        const SizedBox(height: 30),
                        H14(
                          text: LanguageService.trans("address"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: Stack(
                                    children: [
                                      UnderlineInput1(
                                        height: MediaQuery.of(context).size.height,
                                        controller: address1InputController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () => node.nextFocus(),
                                        placeholder: LanguageService.trans("zip_code"),
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
                                  node.requestFocus();
                                  address1 = received["postcode"];
                                  address2 = received["addr"];
                                  checkValid();
                                  address1InputController.text = address1;
                                  address2InputController.text = address2;
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
                              //     node.requestFocus();
                              //     address1 = received["postcode"];
                              //     address2 = received["addr"];
                              //     checkValid();
                              //     address1InputController.text = address1;
                              //     address2InputController.text = address2;
                              //     //getHospitalFromAddress();
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        UnderlineInput1(
                          controller: address2InputController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => node.nextFocus(),
                          placeholder: LanguageService.trans("address1"),
                          onChanged: (text) => {address2 = text, checkValid()},
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                            height: 40,
                            child: Center(
                              child: TextField(
                                style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                                maxLength: -1,
                                controller: address3InputController,
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.done,
                                // focusNode: detailAddrFocusNode,
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
                                onChanged: (text) => {address3 = text, checkValid()},
                              ),
                            )),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            isSame = !isSame;
                            setState(() {});
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 24,
                            child: Row(
                              children: [
                                Image.asset(
                                  isSame ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 10),
                                H14(
                                  text: LanguageService.trans("same_as_address_guardian"),
                                  weight: FW.medium,
                                  height: 1.3,
                                  color: isSame ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        H14(
                          text: LanguageService.trans("relationship_with_children"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 25),
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
                        //     selectedCategory: number_child,
                        //     categoryList: childnumberList,
                        //     onSelect: (selectedCategory) {
                        //       setState(() {
                        //         number_child = selectedCategory!;
                        //         //getDistrictList();
                        //       });
                        //     },
                        //     hint: LanguageService.trans("please_select_the_number_of_children")),
                        const SizedBox(height: 25),
                        InkWell(
                          child: Column(children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(number_child == '' ? LanguageService.trans('please_select_the_number_of_children') : number_child,
                                    style: number_child == '' ? AppTextStyle.PD(AppColor_BlackText.withOpacity(0.4), 16, weight: FW.medium) : AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium)),
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
                                            controller: dadheightInputController,
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
                                            controller: momheightInputController,
                                            keyboardType: const TextInputType.numberWithOptions(
                                              decimal: true,
                                              signed: true,
                                            ),
                                            textInputAction: TextInputAction.done,
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
                          ],
                        ),
                        // const SizedBox(height: 30),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     SizedBox(
                        //       width: (screenSize.width - 70) / 2,
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           H16(text: LanguageService.trans("mom_kidney"), weight: FW.medium, color: AppColor_BlackText),
                        //           const SizedBox(height: 10),
                        //           SizedBox(
                        //             width: screenSize.width,
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 Expanded(
                        //                   child: OutlineNumInput(
                        //                     controller: momheightInputController,
                        //                     keyboardType: TextInputType.number,
                        //                     textInputAction: TextInputAction.next,
                        //                     onEditingComplete: () => node.nextFocus(),
                        //                     placeholder: "",
                        //                     onChanged: (text) => {mom_height = text, checkValid()},
                        //                   ),
                        //                 ),
                        //                 const SizedBox(width: 10),
                        //                 H17(
                        //                   text: LanguageService.trans("cm"),
                        //                   weight: FW.medium,
                        //                   color: AppColor_BlackText,
                        //                 ),
                        //               ],
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     const SizedBox(width: 10),
                        //     SizedBox(
                        //       width: (screenSize.width - 70) / 2,
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           H16(text: LanguageService.trans("mom_weight"), weight: FW.medium, color: AppColor_BlackText),
                        //           const SizedBox(height: 10),
                        //           SizedBox(
                        //             width: screenSize.width,
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 Expanded(
                        //                   child: OutlineNumInput(
                        //                     controller: momweightInputController,
                        //                     keyboardType: TextInputType.number,
                        //                     textInputAction: TextInputAction.next,
                        //                     onEditingComplete: () => node.nextFocus(),
                        //                     placeholder: "",
                        //                     onChanged: (text) => {mom_weight = text, checkValid()},
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
                        //   ],
                        // ),
                        const SizedBox(height: 50),
                        Center(
                          child: MainTextButton(
                            text: LanguageService.trans("next"),
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            width: MediaQuery.of(context).size.width - 60,
                            disable: !isValid,
                            disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                            onPressed: () {
                              if (!isValid) {
                                return;
                              }

                              if (widget.snsid == "") {
                                if (nDuplicatedId != 2 || (nDuplicatedId == 2 && mValidId != id)) {
                                  showToast("아이디 중복확인 해주세요.");
                                  return;
                                }
                              }

                              if (nDuplicatedNickname != 2 || (nDuplicatedNickname == 2 && mValidNickname != nickname)) {
                                showToast("닉네임 중복확인 해주세요.");
                                return;
                              }
                              goNext();
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
