import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_checkbox.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/header_text.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_input.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';

/**
 * 가족력 수정하기
 */
class EditFamilyHisPage extends StatefulWidget {
  EditFamilyHisPage({Key? key, this.usrInfo}) : super(key: key);
  UserInfoDto? usrInfo;

  @override
  EditFamilyHisPageState createState() => EditFamilyHisPageState();
}

class EditFamilyHisPageState extends BaseState<EditFamilyHisPage> {
  final HttpService httpService = HttpService();
  List<TextEditingController> directInputController = [];

  bool isValid = false;
  List<String> releation = ["조부모", "부모", "형제 ˑ 자매"];
  List<String> commonSymptoms = ["고혈압", "당뇨", "심/뇌혈관 질환", "천식", "암", "직접입력"];
  List<int> selCommon = [];

  List<bool> allFamilyIdx1 = [false, false, false, false, false, false];
  List<bool> allFamilyIdx2 = [false, false, false, false, false, false];
  List<bool> allFamilyIdx3 = [false, false, false, false, false, false];
  List<bool> allDiseaseIdx1 = []; //질병
  List<bool> allDiseaseIdx2 = []; //질병
  List<bool> allDiseaseIdx3 = []; //질병
  List<String> allDiseaseContent = []; //질병입력내용

  @override
  void initState() {
    super.initState();

    List<String> tempList = [];
    for (int i = 0; i < widget.usrInfo!.familyHistory!.length; i++) {
      FamilyHistory info = widget.usrInfo!.familyHistory!.elementAt(i);
      if (info.name == "고혈압") {
        if (!selCommon.contains(0)) {
          selCommon.add(0);
        }
        if (info.detail == "조부모") {
          allFamilyIdx1[0] = true;
        }

        if (info.detail == "부모") {
          allFamilyIdx2[0] = true;
        }

        if (info.detail == "형제 ˑ 자매") {
          allFamilyIdx3[0] = true;
        }
      }

      if (info.name == "당뇨") {
        if (!selCommon.contains(1)) {
          selCommon.add(1);
        }
        if (info.detail == "조부모") {
          allFamilyIdx1[1] = true;
        }

        if (info.detail == "부모") {
          allFamilyIdx2[1] = true;
        }

        if (info.detail == "형제 ˑ 자매") {
          allFamilyIdx3[1] = true;
        }
      }

      if (info.name == "심/뇌혈관 질환") {
        if (!selCommon.contains(2)) {
          selCommon.add(2);
        }
        if (info.detail == "조부모") {
          allFamilyIdx1[2] = true;
        }

        if (info.detail == "부모") {
          allFamilyIdx2[2] = true;
        }

        if (info.detail == "형제 ˑ 자매") {
          allFamilyIdx3[2] = true;
        }
      }

      if (info.name == "천식") {
        if (!selCommon.contains(3)) {
          selCommon.add(3);
        }
        if (info.detail == "조부모") {
          allFamilyIdx1[3] = true;
        }

        if (info.detail == "부모") {
          allFamilyIdx2[3] = true;
        }

        if (info.detail == "형제 ˑ 자매") {
          allFamilyIdx3[3] = true;
        }
      }

      if (info.name == "암") {
        if (!selCommon.contains(4)) {
          selCommon.add(4);
        }
        if (info.detail == "조부모") {
          allFamilyIdx1[4] = true;
        }

        if (info.detail == "부모") {
          allFamilyIdx2[4] = true;
        }

        if (info.detail == "형제 ˑ 자매") {
          allFamilyIdx3[4] = true;
        }
      }

      //기타
      if (info.name != "고혈압" && info.name != "당뇨" && info.name != "심/뇌혈관 질환" && info.name != "천식" && info.name != "암") {
        if (!tempList.contains(info.name)) {
          selCommon.add(5);
          tempList.add(info.name!);
          allDiseaseContent.add(info.name!);
          directInputController.add(TextEditingController(text: info.name!));

          if (info.detail == "조부모") {
            allDiseaseIdx1.add(true);
          } else {
            allDiseaseIdx1.add(false);
          }

          if (info.detail == "부모") {
            allDiseaseIdx2.add(true);
          } else {
            allDiseaseIdx2.add(false);
          }

          if (info.detail == "형제 ˑ 자매") {
            allDiseaseIdx3.add(true);
          } else {
            allDiseaseIdx3.add(false);
          }
        } else {
          int index = getIndex(info.name!);
          if (info.detail == "조부모") {
            allDiseaseIdx1[index] = true;
          }

          if (info.detail == "부모") {
            allDiseaseIdx2[index] = true;
          }

          if (info.detail == "형제 ˑ 자매") {
            allDiseaseIdx3[index] = true;
          }
        }
      }
    }

    checkValid();
  }

  int getIndex(String name) {
    for (int i = 0; i < allDiseaseContent.length; i++) {
      if (name == allDiseaseContent[i]) {
        return i;
      }
    }
    return 0;
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

  void onSelect(int type, int index, bool selected) {
    if (type == 1) {
      if (selected) {
        selCommon.add(index);
        allFamilyIdx1[index] = false;
        allFamilyIdx2[index] = false;
        allFamilyIdx3[index] = false;
        if (index == 5) {
          onAddDisease();
        }
      } else {
        selCommon.remove(index);
        if (index == 5) {
          onAllDelDisease();
        }
      }
    }
    setState(() {});
    checkValid();
  }

  void checkValid() {
    if (selCommon.isEmpty) {
      setState(() {
        isValid = false;
      });
    } else {
      for (int i = 0; i < selCommon.length; i++) {
        String name = commonSymptoms[selCommon[i]];
        if (name != "직접입력") {
          if (!allFamilyIdx1[selCommon[i]] && !allFamilyIdx2[selCommon[i]] && !allFamilyIdx3[selCommon[i]]) {
            setState(() {
              isValid = false;
            });
            return;
          }
        }
      }

      for (int i = 0; i < allDiseaseContent.length; i++) {
        if (!allDiseaseIdx1[i] && !allDiseaseIdx2[i] && !allDiseaseIdx3[i]) {
          setState(() {
            isValid = false;
          });
          return;
        }
        if (allDiseaseContent[i] == "") {
          setState(() {
            isValid = false;
          });
          return;
        }
      }
      setState(() {
        isValid = true;
      });
    }
  }

  void onAddDisease() {
    allDiseaseIdx1.add(false);
    allDiseaseIdx2.add(false);
    allDiseaseIdx3.add(false);
    allDiseaseContent.add("");
    directInputController.add(TextEditingController());
    checkValid();
  }

  void onDelDisease(int index) {
    allDiseaseIdx1.removeAt(index);
    allDiseaseIdx2.removeAt(index);
    allDiseaseIdx3.removeAt(index);
    allDiseaseContent.removeAt(index);
    directInputController.removeAt(index);

    if (allDiseaseIdx1.isEmpty) {
      selCommon.remove(5);
    }
    checkValid();
  }

  void onAllDelDisease() {
    allDiseaseIdx1.clear();
    allDiseaseIdx2.clear();
    allDiseaseIdx3.clear();
    allDiseaseContent.clear();
    directInputController.clear();
    checkValid();
  }

  Parent getDisease(String name) {
    for (int i = 0; i < gDiseaseList!.parent!.length; i++) {
      Parent item = gDiseaseList!.parent!.elementAt(i);
      if (name == item.name) {
        return item;
      }
    }

    Parent info = Parent();
    info.id = "";
    info.name = "";
    info.inputable = "";

    return info;
  }

  // Network functions
  //////////////////////////////////
  //가족력 수정하기
  void reqChangeFamilyHistory() {
    String familyHistory = "";
    List<Map<String, String>> historyList = [];
    for (int i = 0; i < selCommon.length; i++) {
      String name = commonSymptoms[selCommon[i]];
      if (name == "직접입력") {
        for (int i = 0; i < allDiseaseContent.length; i++) {
          if (allDiseaseIdx1[i]) {
            Map<String, String> info = {
              'id': "0",
              'name': allDiseaseContent[i],
              'detail': "조부모", //releation[allDiseaseIdx[i]],
            };
            historyList.add(info);
          }
          if (allDiseaseIdx2[i]) {
            Map<String, String> info = {
              'id': "0",
              'name': allDiseaseContent[i],
              'detail': "부모",
            };
            historyList.add(info);
          }
          if (allDiseaseIdx3[i]) {
            Map<String, String> info = {
              'id': "0",
              'name': allDiseaseContent[i],
              'detail': "형제 ˑ 자매",
            };
            historyList.add(info);
          }
        }
      } else {
        Parent item = getDisease(name);
        if (allFamilyIdx1[i]) {
          Map<String, String> info = {
            'id': item.id!,
            'name': item.name!,
            'detail': "조부모", //releation[allFamilyIdx1[i]],
          };
          historyList.add(info);
        }

        if (allFamilyIdx2[i]) {
          Map<String, String> info = {
            'id': item.id!,
            'name': item.name!,
            'detail': "부모",
          };
          historyList.add(info);
        }

        if (allFamilyIdx3[i]) {
          Map<String, String> info = {
            'id': item.id!,
            'name': item.name!,
            'detail': "형제 ˑ 자매",
          };
          historyList.add(info);
        }
      }
    }

    if (historyList.isNotEmpty) {
      familyHistory = json.encode(historyList);
    }

    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.changeFamilyHistory(familyHistory);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast("저장 완료되었습니다.");
        eventBus.fire(UpdateUserEvent());
        onBackPressed();
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
              title: "가족력 수정하기",
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
                    const SizedBox(height: 14),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 6,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 80 / 30, mainAxisSpacing: 10, crossAxisSpacing: 15),
                        itemBuilder: (BuildContext context, int index) {
                          return AppCheckbox(
                            text: commonSymptoms[index],
                            checked: selCommon.contains(index) ? true : false,
                            padding: 16.0,
                            withBorder: true,
                            onChecked: (checked) => {onSelect(1, index, checked!)},
                          );
                        }),
                    //고혈압
                    Visibility(
                      visible: selCommon.contains(0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H14(text: "고혈압 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx1[0] = !allFamilyIdx1[0];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx1[0] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx2[0] = !allFamilyIdx2[0];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx2[0] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx3[0] = !allFamilyIdx3[0];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx3[0] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //당뇨
                    Visibility(
                      visible: selCommon.contains(1),
                      child: Container(
                        margin: const EdgeInsets.only(top: 36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H14(text: "당뇨 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx1[1] = !allFamilyIdx1[1];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx1[1] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx2[1] = !allFamilyIdx2[1];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx2[1] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx3[1] = !allFamilyIdx3[1];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx3[1] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //심/뇌혈관 질환
                    Visibility(
                      visible: selCommon.contains(2),
                      child: Container(
                        margin: const EdgeInsets.only(top: 36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H14(text: "심/뇌혈관 질환 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx1[2] = !allFamilyIdx1[2];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx1[2] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx2[2] = !allFamilyIdx2[2];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx2[2] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx3[2] = !allFamilyIdx3[2];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx3[2] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //천식
                    Visibility(
                      visible: selCommon.contains(3),
                      child: Container(
                        margin: const EdgeInsets.only(top: 36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H14(text: "천식 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx1[3] = !allFamilyIdx1[3];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx1[3] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx2[3] = !allFamilyIdx2[3];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx2[3] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx3[3] = !allFamilyIdx3[3];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx3[3] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //암
                    Visibility(
                      visible: selCommon.contains(4),
                      child: Container(
                        margin: const EdgeInsets.only(top: 36.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H14(text: "암 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx1[4] = !allFamilyIdx1[4];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx1[4] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx2[4] = !allFamilyIdx2[4];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx2[4] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    allFamilyIdx3[4] = !allFamilyIdx3[4];
                                    checkValid();
                                  },
                                  child: SizedBox(
                                    width: (screenSize.width - 60) / 3,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        Image.asset(allFamilyIdx3[4] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: selCommon.contains(5),
                      child: Container(
                        margin: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 1,
                              color: AppColor_Selector_Border,
                            ),
                            const SizedBox(height: 40),
                            H16(text: "질병 직접입력", weight: FW.medium, color: AppColor_BlackText),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: _itemBuilder,
                              itemCount: allDiseaseContent.length,
                            ),
                            const SizedBox(height: 25),
                            Container(
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor_Light_Gray),
                              child: InkWell(
                                  onTap: () {
                                    onAddDisease();
                                  },
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/add_circle_black_24dp.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(width: 5),
                                      H16(text: "질병 추가", weight: FW.bold, color: AppColor_Primary),
                                    ],
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 54),
                    MainTextButton(
                      text: "저장하기",
                      width: screenSize.width - 60,
                      backgroundColor: AppColor_Primary,
                      height: 58,
                      disable: !isValid,
                      disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                      style: const TextStyle(color: AppColor_White, fontWeight: FontWeight.w500, fontSize: 17),
                      onPressed: () {
                        if (!isValid) {
                          return;
                        }
                        reqChangeFamilyHistory();
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlineInput(
                controller: directInputController[index],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                //onEditingComplete: () => node.nextFocus(),
                placeholder: "가족력 질병 직접입력",
                onChanged: (text) => {
                  allDiseaseContent[index] = text,
                  checkValid(),
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                onDelDisease(index);
              },
              child: Image.asset(
                'assets/ic_delete.png',
                width: 25,
                height: 25,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        H14(text: "질병 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
        const SizedBox(height: 15),
        Row(
          children: [
            InkWell(
              onTap: () {
                allDiseaseIdx1[index] = !allDiseaseIdx1[index];
                checkValid();
              },
              child: SizedBox(
                width: (screenSize.width - 60) / 3,
                height: 24,
                child: Row(
                  children: [
                    Image.asset(allDiseaseIdx1[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                allDiseaseIdx2[index] = !allDiseaseIdx2[index];
                checkValid();
              },
              child: SizedBox(
                width: (screenSize.width - 60) / 3,
                height: 24,
                child: Row(
                  children: [
                    Image.asset(allDiseaseIdx2[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                allDiseaseIdx3[index] = !allDiseaseIdx3[index];
                checkValid();
              },
              child: SizedBox(
                width: (screenSize.width - 60) / 3,
                height: 24,
                child: Row(
                  children: [
                    Image.asset(allDiseaseIdx3[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
