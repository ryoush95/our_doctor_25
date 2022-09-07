import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/free_test_res_model.dart';
import 'package:ourdoctor/pages/analysis/diagnosis_result1.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';

import 'skip_confirm_dialog.dart';

class FreeDiagnosis {
  int? dad_height;
  int? mom_kidney;
  int? gender;
  int? child_height;
  double? child_weight;
  String? birth_date;
  int? sleep_night;
  int? sleep_launch;

  FreeDiagnosis({this.dad_height, this.mom_kidney, this.gender, this.child_height, this.child_weight, this.birth_date, this.sleep_night, this.sleep_launch});
}

class DiagnosisMainPage extends StatefulWidget {
  DiagnosisMainPage({Key? key}) : super(key: key);
  // String? snsid;
  // String? type;
  // String? alarm;

  @override
  DiagnosisMainPageState createState() => DiagnosisMainPageState();
}

class DiagnosisMainPageState extends BaseState<DiagnosisMainPage> {
  final HttpService httpService = HttpService();
  var dadHeightInputController = TextEditingController();
  var momHeightInputController = TextEditingController();
  var childHeightInputController = TextEditingController();
  var childWeightInputController = TextEditingController();
  var birthInputController = TextEditingController();

  bool isValid = false;
  int gender = 1;
  String dad_height = "";
  String mom_height = "";
  String child_height = "";
  String child_weight = "";
  String child_birth = "";
  String sleep_night_hour = "0시간";
  String sleep_night_min = "0분";
  String sleep_launch_hour = "0시간";
  String sleep_launch_min = "0분";

  List<String> timeList1 = []; //낮잠 시간
  List<String> timeList2 = []; //분
  List<String> timeList3 = []; //밤잠 시간

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i <= 720; i += 10) {
    //   timeList1.add(i.toString());
    // }
    //
    // for (var i = 0; i <= 1440; i += 30) {
    //   timeList2.add(i.toString());
    // }
    for (var i = 0; i < 8; i++) {
      if (i < 7) {
        timeList1.add("$i시간");
      } else {
        timeList1.add("$i시간 이상");
      }
    }

    for (var i = 0; i < 14; i++) {
      if (i < 13) {
        timeList3.add("$i시간");
      } else {
        timeList3.add("$i시간 이상");
      }
    }

    for (var i = 0; i < 60; i += 30) {
      timeList2.add(i.toString() + "분");
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    //onFinish();
    return true;
  }

  void checkValid() {
    if (dad_height.isEmpty || mom_height.isEmpty || child_height.isEmpty || child_weight.isEmpty || child_birth.isEmpty) {
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

  void onFinish() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 282,
            // padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 52),
                H20(text: LanguageService.trans('monitoring_question_finish_title'), maxLine: 2, height: 1.4, weight: FW.bold, color: AppColor_BlackText),
                const SizedBox(height: 8),
                H16(text: LanguageService.trans('monitoring_question_finish_sesc'), height: 1.5, weight: FW.regular),
                const SizedBox(height: 33),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 32, left: 32),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 64 - 14) / 2,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: AppColor_Primary,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Center(
                            child: H18(
                              text: LanguageService.trans('continue1'),
                              color: AppColor_White,
                              weight: FW.semi_bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 64 - 14) / 2,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: AppColor_Green,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Center(
                            child: H18(
                              text: LanguageService.trans('start'),
                              color: AppColor_White,
                              weight: FW.semi_bold,
                            ),
                          ),
                        ),
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

  Future<void> showBirthdayDlg() async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      child_birth = _result;
      birthInputController.text = child_birth;
      checkValid();
    }
  }

  void onSkip() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return const SkipConfirmDialog();
        });
  }

  // void goNext() {
  //   FreeDiagnosis? data;
  //   data = FreeDiagnosis(
  //       dad_height: int.parse(dad_height), mom_kidney: int.parse(mom_height), gender: gender, child_height: int.parse(child_height), child_weight: double.parse(child_weight), birth_date: birthInputController.value.text, sleep_night: int.parse(sleep_night), sleep_launch: int.parse(sleep_launch));
  //   Navigator.push(context, SlideRightTransRoute(builder: (context) => DiagnosisResultPage(data: data)));
  // }
  void goNext() {
    // int sleep_launch = 0;
    // int sleep_night = 0;

    // int launch_hour = int.parse(sleep_launch_hour.replaceAll("시간", ""));
    // int launch_min = int.parse(sleep_launch_min.replaceAll("분", ""));
    // int night_hour = int.parse(sleep_night_hour.replaceAll("시간", ""));
    // int night_min = int.parse(sleep_night_min.replaceAll("분", ""));
    // sleep_launch = launch_hour * 60 + launch_min;
    // sleep_night = night_hour * 60 + night_min;

    final lunch_hour;
    final launch_min;
    if(sleep_launch_hour.contains("이상")) {
      lunch_hour = int.parse(sleep_launch_hour.replaceAll("시간 이상", ""));
      sleep_launch_min = "0분";
      launch_min = int.parse(sleep_launch_min.replaceAll("분", ""));
    } else {
      lunch_hour = int.parse(sleep_launch_hour.replaceAll("시간", ""));
      launch_min = int.parse(sleep_launch_min.replaceAll("분", ""));
    }
    
    final night_hour;
    final night_min;
    if(sleep_night_hour.contains("이상")) {
      night_hour = int.parse(sleep_night_hour.replaceAll("시간 이상", ""));
      sleep_night_min = "0분";
      night_min = int.parse(sleep_night_min.replaceAll("분", ""));
    } else {
      night_hour = int.parse(sleep_night_hour.replaceAll("시간", ""));
      night_min = int.parse(sleep_night_min.replaceAll("분", ""));
    }
    int sleep_launch = lunch_hour * 60 + launch_min;
    int sleep_night = night_hour * 60 + night_min;

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (today == child_birth) {
      showToast("생년월일이 오늘날짜로 설정되어 있습니다.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future<FreeTestResModel> offerInfo = httpService.freeTest(dad_height, mom_height, gender.toString(), child_height, child_weight, child_birth, sleep_launch.toString(), sleep_night.toString());
    offerInfo.then((FreeTestResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        FreeTtestDto? info = value.data;
        info!.hEIGHT!.curValue = child_height;
        info.wEIGHT!.curValue = child_weight;
        Navigator.push(context, SlideRightTransRoute(builder: (context) => DiagnosisResult1Page(data: info, dadHeight: dad_height, momHeight: mom_height, childHeight: child_height, childWeight: child_weight)));
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  header(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Container(
                                height: 125,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor_Light_Gray),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          H18(
                                            text: LanguageService.trans("my_child_in_1_minute"),
                                            color: AppColor_BlackText,
                                          ),
                                          const SizedBox(height: 10),
                                          H16(text: LanguageService.trans("future_tall_bmi_sleep_free_diagnosis"), maxLine: 2, height: 1.3, weight: FW.regular, align: TextAlign.start)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Image.asset(
                                      'assets/ic_grapth.png',
                                      width: (screenSize.width - 295),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 22),
                            H18(
                              text: LanguageService.trans("parent_basic_information"),
                              color: AppColor_BlackText,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: (screenSize.width - 64 - 10) / 2,
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
                                                height: 52,
                                                controller: dadHeightInputController,
                                                keyboardType: const TextInputType.numberWithOptions(
                                                  decimal: true,
                                                  signed: true,  
                                                ),
                                                textInputAction: TextInputAction.next,
                                                onEditingComplete: () => node.nextFocus(),
                                                placeholder: "",
                                                onChanged: (text) => {
                                                  dad_height = text,
                                                  checkValid(),
                                                },
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
                                  width: (screenSize.width - 64 - 10) / 2,
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
                                                controller: momHeightInputController,
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
                              ],
                            ),
                            const SizedBox(height: 55),
                            H18(
                              text: LanguageService.trans("child_basic_information"),
                              color: AppColor_BlackText,
                            ),
                            const SizedBox(height: 20),
                            Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      gender = 1;
                                    });
                                  },
                                  child: Column(children: [
                                    Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        elevation: 3,
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: gender == 1 ? AppColor_White : AppColor_BlackText.withOpacity(0.04),
                                          ),
                                          child: Image.asset(gender == 1 ? "assets/ic_male_on.png" : "assets/ic_male_off.png"),
                                        )),
                                    const SizedBox(height: 10),
                                    H14(text: LanguageService.trans("male"), weight: FW.regular, color: gender == 1 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.5))
                                  ]),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      gender = 2;
                                    });
                                  },
                                  child: Column(children: [
                                    Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        elevation: 3,
                                        child: Container(
                                            width: 75,
                                            height: 75,
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: gender == 2 ? AppColor_White : AppColor_BlackText.withOpacity(0.04),
                                            ),
                                            child: Image.asset(gender == 2 ? "assets/ic_female_on.png" : "assets/ic_female_off.png"))),
                                    const SizedBox(height: 10),
                                    H14(text: LanguageService.trans("female"), weight: FW.regular, color: gender == 2 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.5))
                                  ]),
                                ),
                              ],
                            )),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: (screenSize.width - 64 - 10) / 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      H16(text: LanguageService.trans("child_height"), weight: FW.medium, color: AppColor_BlackText),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: screenSize.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: OutlineNumInput(
                                                controller: childHeightInputController,
                                                keyboardType: const TextInputType.numberWithOptions(
                                                  decimal: true,
                                                  signed: true,
                                                ),
                                                textInputAction: TextInputAction.next,
                                                onEditingComplete: () => node.nextFocus(),
                                                placeholder: "",
                                                onChanged: (text) => {child_height = text, checkValid()},
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
                                  width: (screenSize.width - 64 - 10) / 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      H16(text: LanguageService.trans("child_weight"), weight: FW.medium, color: AppColor_BlackText),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: screenSize.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: OutlineNumInput(
                                                controller: childWeightInputController,
                                                 keyboardType: const TextInputType.numberWithOptions(
                                                  decimal: true,
                                                  signed: true,
                                                ),
                                                textInputAction: TextInputAction.next,
                                                onEditingComplete: () => node.nextFocus(),
                                                placeholder: "",
                                                onChanged: (text) => {child_weight = text, checkValid()},
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            H17(
                                              text: LanguageService.trans("kg"),
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
                            const SizedBox(height: 35),
                            H16(text: LanguageService.trans("child_date_birth"), weight: FW.medium, color: AppColor_BlackText),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 55,
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
                                  node.requestFocus();
                                  showBirthdayDlg();
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColor_Selector_Border), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColor_BlackText), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                  hintText: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                  hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
                            H16(text: "자녀 평균 낮잠 수면 시간", weight: FW.medium, color: AppColor_BlackText),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: (screenSize.width - 70) / 2,
                                  child: Selector(
                                      selectedCategory: sleep_launch_hour,
                                      categoryList: timeList1,
                                      onSelect: (selectedCategory) {
                                        setState(() {
                                          sleep_launch_hour = selectedCategory!;
                                          checkValid();
                                          //getDistrictList();
                                        });
                                      },
                                      hint: "시간"),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: (screenSize.width - 70) / 2,
                                  child: Selector(
                                      selectedCategory: sleep_launch_min,
                                      categoryList: timeList2,
                                      onSelect: (selectedCategory) {
                                        setState(() {
                                          sleep_launch_min = selectedCategory!;
                                          checkValid();
                                          //getDistrictList();
                                        });
                                      },
                                      hint: "분"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 35),
                            H16(text: "자녀 평균 밤잠 수면 시간", weight: FW.medium, color: AppColor_BlackText),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: (screenSize.width - 70) / 2,
                                  child: Selector(
                                      selectedCategory: sleep_night_hour,
                                      categoryList: timeList3,
                                      onSelect: (selectedCategory) {
                                        setState(() {
                                          sleep_night_hour = selectedCategory!;
                                          checkValid();
                                          //getDistrictList();
                                        });
                                      },
                                      hint: "시간"),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: (screenSize.width - 70) / 2,
                                  child: Selector(
                                      selectedCategory: sleep_night_min,
                                      categoryList: timeList2,
                                      onSelect: (selectedCategory) {
                                        setState(() {
                                          sleep_night_min = selectedCategory!;
                                          checkValid();
                                          //getDistrictList();
                                        });
                                      },
                                      hint: "분"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: MainTextButton(
                                text: LanguageService.trans("view_results"),
                                backgroundColor: AppColor_Primary,
                                style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
                                width: MediaQuery.of(context).size.width - 64,
                                height: 58,
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
                  ),
                ],
              )),
        ));
  }

  header() =>  SizedBox(
    height: 62,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => onBackPressed(),
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: 62,
            padding: const EdgeInsets.only(left: 30, right: 10),
            child: Image.asset(
              'assets/path_12225.png',
              width: 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
            child: Center(
              child: H18(
                text: LanguageService.trans("1_minute_free_diagnosis"),
                weight: FW.medium,
                height: 1.2,
                color: AppColor_BlackText,
                maxLine: 2,
              ),
            ),
          ),
        GestureDetector(
            onTap: () => onSkip(),
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 62,
              padding: const EdgeInsets.only(right: 30, left: 10),
              alignment: Alignment.center,
              child: H18(
                text: "Skip",
                weight: FW.medium,
                height: 1.2,
                color: AppColor_BlackText.withOpacity(0.4),
              ),
            )),
      ],
    ));

}
