import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/hosiptal_list_res_model.dart';
import 'package:ourdoctor/models/signup_parent_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';

class SignupParentInfo {
  final String id;
  final String pwd;
  final String name;
  final String birth;
  final String phone;
  final String code;
  final String addr1;
  final String addr2;
  final bool same_addr;
  final String relationship;
  final int child_number;
  final String dad_height;
  // final String dad_weight;
  final String mom_height;
  // final String mom_weight;
  final String type;
  final String nickname;
  final String alarm;

  SignupParentInfo(this.id, this.pwd, this.name, this.birth, this.phone, this.code, this.addr1, this.addr2, this.same_addr, this.relationship, this.child_number, this.dad_height, this.mom_height, this.type, this.nickname, this.alarm);
}

class SignupChildInfo {
  final List<String> history;
  final List<int> selCommon;
  final List<String> history_direct;
  final int disease_count;
  final int child_count;
  final List<String> name;
  final List<String> height;
  final List<String> weight;
  final List<String> profileImage;
  final List<int> gender;
  final List<String> birthday;
  final List<List<int>> symptoms;
  final List<String> symptom_direct;
  final List<String> address1;
  final List<String> address2;
  final List<String> address3;

  SignupChildInfo(this.history, this.selCommon, this.history_direct, this.disease_count, this.child_count, this.name, this.height, this.weight, this.profileImage, this.gender, this.birthday, this.symptoms, this.symptom_direct, this.address1, this.address2, this.address3);
}

class SignupHomePage extends StatefulWidget {
  SignupHomePage({Key? key, required this.parentInfo, required this.childInfo}) : super(key: key);

  SignupParentInfo parentInfo;
  SignupChildInfo childInfo;

  @override
  SignupHomePageState createState() => SignupHomePageState();
}

class SignupHomePageState extends BaseState<SignupHomePage> {
  final HttpService httpService = HttpService();
  List<TextEditingController> testdateInputController = [];
  List<TextEditingController> address1InputController = [];
  List<TextEditingController> address2InputController = [];
  List<TextEditingController> address3InputController = [];

  List<String> testdate = [];
  List<String> address1 = []; //우편번호
  List<String> address2 = []; //주소 1
  List<String> address3 = []; //주소 2

  List<String> mCity = [];
  List<String> mDistrict = [];
  List<String> mHospital = [];

  List<String> districtList = [];
  List<String> hospitalList = [];
  List<HospitalDto> arrHospitalList = [];
  List<String> hospitalId = [];

  bool isValid = true;
  List<bool> isSame = [];

  int child = 0;
  String profileImage = "";

  SignupParentInfo? parentInfo;
  SignupChildInfo? childInfo;

  List<String> childSymptom = [];
  /*<String>[
    LanguageService.trans("kidney_disease"),
    LanguageService.trans("heart"),
    LanguageService.trans("asthma"),
    LanguageService.trans("genetic_disease"),
    LanguageService.trans("direct_input"),
  ];*/

  // FocusNode? detailAddrFocusNode;
  @override
  void initState() {
    super.initState();

    parentInfo = widget.parentInfo;
    childInfo = widget.childInfo;
    for (int i = 0; i < childInfo!.child_count; i++) {
      testdateInputController.add(TextEditingController());
      testdate.add("");
      address1InputController.add(TextEditingController(text: childInfo!.address1[i]));
      address1.add(childInfo!.address1[i]);
      address2InputController.add(TextEditingController(text: childInfo!.address2[i]));
      address2.add(childInfo!.address2[i]);
      address3InputController.add(TextEditingController(text: childInfo!.address3[i]));
      address3.add(childInfo!.address3[i]);
      isSame.add(false);
      mCity.add("");
      mDistrict.add("");
      mHospital.add("");
      hospitalId.add("2");
    }
    for (int i = 0; i < childInfo!.child_count; i++) {
      if (gCityList!.isNotEmpty) {
        mCity[i] = gCityList!.elementAt(0);
        getDistrictList(i);
      }
    }
    for (int i = 0; i < gDiseaseList!.child!.length; i++) {
      childSymptom.add(gDiseaseList!.child![i].name!);
    }
    // detailAddrFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    // detailAddrFocusNode!.dispose();

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void checkValid() {
    if (testdate.isEmpty) {
      //address1.isEmpty || address2.isEmpty || relationship.isEmpty || mDistrict.isEmpty
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }
  }

  Future<void> showBirthdayDlg(int index) async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      testdate[index] = _result;
      testdateInputController[index].text = testdate[index];
      checkValid();
    }
  }

  void goNext() {
    reqSignup();
  }

  void getDistrictList(int index) {
    for (int i = 0; i < gDistrictList!.length; i++) {
      DistrictList info = gDistrictList!.elementAt(i);
      if (info.city == mCity[index]) {
        districtList = info.list!;
      }
    }

    if (districtList.isNotEmpty) {
      mDistrict[index] = districtList.elementAt(0);
      hospitalList = [];
      getHosiptalList(index);
    }
  }

  //주소검색데이터로부터 병원정보 얻기
  void getHospitalFromAddress(int index) {
    var arr = address2[child].split(" ");
    if (arr.length > 3) {
      // 서울특별시 강남구 선릉로90길 64
      String city = arr[0];
      String district = arr[1];
      String district1 = arr[2];
      String temp = district1.substring(district1.length - 1);
      if (temp == "구") {
        district = district.replaceAll("시", "") + district1;
      }
      for (int i = 0; i < gDistrictList!.length; i++) {
        DistrictList info = gDistrictList!.elementAt(i);
        if (city.contains(info.city!)) {
          for (int i = 0; i < info.list!.length; i++) {
            String gun = info.list!.elementAt(i);
            if (district == gun) {
              mCity[index] = info.city!;
              mDistrict[index] = gun;
              districtList = info.list!;
              getHosiptalList(index);
              break;
            }
          }
        }
      }
    }
  }

  // Network functions
  //////////////////////////////////
  //
  //회원가입
  Future<void> reqSignup() async {
    String token = await LocalService.getToken();

    setState(() {
      isLoading = true;
    });
    String history6 = "";
    for (int i = 0; i < childInfo!.disease_count; i++) {
      history6 = history6 + childInfo!.history_direct[i];
      if (i < childInfo!.disease_count - 1) {
        history6 = history6 + ",";
      }
    }
    List<Map<String, String>> familyHistory = [];
    int length = childInfo!.selCommon.length;
    if (childInfo!.selCommon.contains(gDiseaseList!.parent!.length - 1)) length = length - 1;
    for (int i = 0; i < length; i++) {
      Map<String, String> history = {'id': gDiseaseList!.parent![childInfo!.selCommon[i]].id!, 'detail': childInfo!.history[i]};
      familyHistory.add(history);
    }
    for (int i = 0; i < childInfo!.history_direct.length; i++) {
      Map<String, String> history = {'id': "0", 'detail': childInfo!.history_direct[i]};
      if (childInfo!.history_direct[i] != "") familyHistory.add(history);
    }
    String family_history = json.encode(familyHistory);
    print(family_history);
    print(childInfo!.history_direct.length);
    Future<SignupParentResModel> offInfo =
        httpService.signup2(parentInfo!.id, parentInfo!.pwd, parentInfo!.type, token, parentInfo!.name, parentInfo!.birth, parentInfo!.phone, parentInfo!.code, parentInfo!.addr1, parentInfo!.addr2, parentInfo!.dad_height, parentInfo!.mom_height, family_history, "", "", widget.parentInfo.alarm);
    offInfo.then((SignupParentResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        for (int i = 0; i < childInfo!.child_count; i++) {
          String medical_history = "";
          List<int> symptom = childInfo!.symptoms[i];
          for (int j = 0; j < gDiseaseList!.child!.length; j++) {
            if (symptom.contains(j)) {
              if (j < gDiseaseList!.child!.length - 1) {
                medical_history = medical_history + childSymptom[j];
              }
              if (j == gDiseaseList!.child!.length - 1) {
                medical_history = medical_history + "(" + childSymptom[j] + ") " + childInfo!.symptom_direct[i];
              }
              medical_history = medical_history + ",";
            }
          }
          medical_history = medical_history.substring(0, medical_history.length - 1);

          Future<DefaultResModel> offInfo = httpService.addChildren2(value.data!.access_token.toString(), "", childInfo!.name[i], childInfo!.gender[i], childInfo!.height[i], childInfo!.weight[i], childInfo!.birthday[i], medical_history, testdate[i], address1[i], address2[i], address3[i],
              hospitalId[i], parentInfo!.relationship, childInfo!.profileImage[i]);
          offInfo.then((DefaultResModel value) async {
            setState(() {
              isLoading = false;
            });
            if (value.result == 0) {
              // Navigator.push(context, SlideRightTransRoute(builder: (context) => SignupFinishPage()));
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

  //병원리스트 얻기
  Future<void> getHosiptalList(int index) async {
    setState(() {
      isLoading = true;
    });

    Future<HospitalListResModel> info = httpService.hospitalList(mCity[index], mDistrict[index]);
    info.then((HospitalListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        hospitalId[index] = "";
        arrHospitalList = value.data!;
        hospitalList = [];
        for (int i = 0; i < arrHospitalList.length; i++) {
          hospitalList.add(arrHospitalList.elementAt(i).name!);
        }
        if (arrHospitalList.isNotEmpty) {
          mHospital[index] = arrHospitalList.elementAt(0).name!;
          hospitalId[index] = arrHospitalList.elementAt(0).id!;
        }
        setState(() {});
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError.toString());
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
                          text: LanguageService.trans("home_care_children_choice"),
                          color: AppColor_BlackText,
                        ),
                        const SizedBox(height: 10),
                        H14(
                          text: LanguageService.trans("please_select_a_child_who_needs_home_treatment"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 15),
                        Container(
                            height: 115,
                            width: screenSize.width - 60,
                            decoration: BoxDecoration(color: AppColor_Light_Gray, borderRadius: BorderRadius.circular(30)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: _itemBuilder,
                              itemCount: childInfo!.child_count,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                            )),
                        const SizedBox(height: 60),
                        H24B(
                          text: LanguageService.trans("home_care_information"),
                          color: AppColor_BlackText,
                        ),
                        const SizedBox(height: 20),
                        H14(
                          text: LanguageService.trans("confirmation_test_date"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                            controller: testdateInputController[child],
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
                              showBirthdayDlg(child);
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
                                        controller: address1InputController[child],
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () => node.nextFocus(),
                                        placeholder: LanguageService.trans("zip_code"),
                                        onChanged: (text) => {address1[child] = text, checkValid()},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              MainTextButton(
                                text: LanguageService.trans("search"),
                                backgroundColor: AppColor_Primary,
                                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                                width: 90,
                                disable: true,
                                disableBackground: AppColor_BlackText,
                                onPressed: () async {
                                  // Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => AddressSearchPage()));
                                  // detailAddrFocusNode!.requestFocus();
                                  // address1 = received["postcode"];
                                  // address2 = received["addr"];
                                  checkValid();
                                  address1[child] = "789";
                                  address2[child] = "test";
                                  address1InputController[child].text = address1[child];
                                  address2InputController[child].text = address2[child];
                                  //getHospitalFromAddress();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        UnderlineInput1(
                          controller: address2InputController[child],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => node.nextFocus(),
                          placeholder: LanguageService.trans("address1"),
                          onChanged: (text) => {address2[child] = text, checkValid()},
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                            height: 40,
                            child: Center(
                              child: TextField(
                                style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                                maxLength: -1,
                                controller: address3InputController[child],
                                onEditingComplete: () => node.nextFocus(),
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
                                onChanged: (text) => {address3[child] = text, checkValid()},
                              ),
                            )),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            isSame[child] = !isSame[child];
                            setState(() {});
                            if (isSame[child]) {
                              address1[child] = parentInfo!.code;
                              address2[child] = parentInfo!.addr1;
                              address3[child] = parentInfo!.addr2;
                              address1InputController[child].text = address1[child];
                              address2InputController[child].text = address2[child];
                              address3InputController[child].text = address3[child];
                            }
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 24,
                            child: Row(
                              children: [
                                Image.asset(
                                  isSame[child] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 10),
                                H14(
                                  text: LanguageService.trans("same_as_address_guardian"),
                                  weight: FW.medium,
                                  height: 1.3,
                                  color: isSame[child] ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        H14(
                          text: LanguageService.trans("emergency_call_connection_hospital"),
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
                        const SizedBox(height: 10),
                        SelectorBox(
                            selectedCategory: mCity[child],
                            categoryList: gCityList!,
                            onSelect: (selectedCategory) {
                              setState(() {
                                mCity[child] = selectedCategory!;
                                mDistrict[child] = "";
                                getDistrictList(child);
                              });
                            },
                            hint: "si"),
                        const SizedBox(height: 10),
                        SelectorBox(
                            selectedCategory: mDistrict[child],
                            categoryList: districtList,
                            onSelect: (selectedCategory) {
                              setState(() {
                                mDistrict[child] = selectedCategory!;
                                mHospital[child] = "";
                                hospitalList = [];
                                getDistrictList(child);
                              });
                            },
                            hint: "gu"),
                        const SizedBox(height: 10),
                        SelectorBox(
                            selectedCategory: mHospital[child],
                            categoryList: hospitalList,
                            onSelect: (selectedCategory) {
                              setState(() {
                                mHospital[child] = selectedCategory!;
                                for (int i = 0; i < arrHospitalList.length + 1; i++) {
                                  HospitalDto info = arrHospitalList.elementAt(i);
                                  if (info.name == mHospital[child]) {
                                    hospitalId[child] = info.id!;
                                  }
                                }
                              });
                            },
                            hint: "hospital"),
                        const SizedBox(height: 15),
                        H14(
                          text: LanguageService.trans("please_select_the_nearest_hospital"),
                          weight: FW.bold,
                          color: AppColor_BlackText.withOpacity(0.5),
                        ),
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

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          child = index;
          setState(() {});
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                          visible: profileImage.isEmpty,
                          child: Center(
                            child: Image.asset(
                              "assets/group_19977.png",
                              fit: BoxFit.fill,
                            ),
                          )),
                      Visibility(
                        visible: profileImage.isNotEmpty,
                        child: ExtendedImage.network(
                          profileImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                          cache: true,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [Image.asset(childInfo!.gender[index] == 1 ? "assets/ic_male.png" : "assets/ic_female.png", width: 15), const SizedBox(width: 5), H14(text: childInfo!.name[index], weight: FW.regular)],
                )
              ],
            )));
  }
}
