import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/brain_quiz_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/food_list_res_model.dart';
import 'package:ourdoctor/models/monitoring_record_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_result.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_result1.dart';
import 'package:ourdoctor/provider/old_food_list_provider.dart';
import 'package:provider/provider.dart';

class SecondStepPage extends StatefulWidget {
  SecondStepPage({Key? key, required this.selBrain, required this.hasDisease, required this.surgeryList, required this.hasphotoList, this.uid = ""}) : super(key: key);

  List<int>? selBrain;
  int? hasDisease;
  List<int>? surgeryList;
  List<int>? hasphotoList;
  String? uid;

  @override
  SecondStepPageState createState() => SecondStepPageState();
}

class SecondStepPageState extends BaseState<SecondStepPage> {
  final HttpService httpService = HttpService();

  bool isValid = false;

  //언어
  List<String>? arrLangStep1List = [];
  List<int>? arrLangStep1idxList = [];
  List<String>? arrLangStep2List = [];
  List<int>? arrLangStep2IdxList = [];

  //운동
  List<String>? arrWorkStep1List = [];
  List<int>? arrWorkStep1IdxList = [];
  List<String>? arrWorkStep2List = [];
  List<int>? arrWorkStep2IdxList = [];

  //사회성
  List<String>? arrSocial1Step1List = [];
  List<int>? arrSocial1Step1IdxList = [];
  List<String>? arrSocial2Step1List = [];
  List<int>? arrSocial2Step1IdxList = [];

  ///////////////////
  List<String>? arrUnderstandList1 = [];
  List<String>? arrUnderstandList2 = [];
  List<String>? arrDescribeList1 = [];
  List<String>? arrDescribeList2 = [];
  List<String>? arrActionList1 = [];
  List<String>? arrActionList2 = [];
  List<String>? arrBigMuscleList1 = [];
  List<String>? arrBigMuscleList2 = [];
  List<String>? arrSmailMuscleList1 = [];
  List<String>? arrSmailMuscleList2 = [];

  @override
  void initState() {
    super.initState();
    // monitoringData!.language = "1";
    // monitoringData!.sociability = "0";
    // monitoringData!.work_out = "1";

    getBrainQuizList();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  // 타일
  Widget _getTiles(int type, int index) {
    String content = "";
    int status = 1;
    if (type == 1) {
      content = arrLangStep1List!.elementAt(index);
      status = arrLangStep1idxList![index];
    } else if (type == 2) {
      content = arrLangStep2List!.elementAt(index);
      status = arrLangStep2IdxList![index];
    } else if (type == 3) {
      content = arrSocial1Step1List!.elementAt(index);
      status = arrSocial1Step1IdxList![index];
    } else if (type == 4) {
      content = arrSocial2Step1List!.elementAt(index);
      status = arrSocial2Step1IdxList![index];
    } else if (type == 5) {
      content = arrWorkStep1List!.elementAt(index);
      status = arrWorkStep1IdxList![index];
    } else if (type == 6) {
      content = arrWorkStep2List!.elementAt(index);
      status = arrWorkStep2IdxList![index];
    }

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 60,
            child: H14(
              text: content,
              weight: FW.medium,
              color: AppColor_BlackText,
              maxLine: 4,
              align: TextAlign.left,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (type == 1) {
                      arrLangStep1idxList![index] = 1;
                    } else if (type == 2) {
                      arrLangStep2IdxList![index] = 1;
                    } else if (type == 3) {
                      arrSocial1Step1IdxList![index] = 1;
                    } else if (type == 4) {
                      arrSocial2Step1IdxList![index] = 1;
                    } else if (type == 5) {
                      arrWorkStep1IdxList![index] = 1;
                    } else if (type == 6) {
                      arrWorkStep2IdxList![index] = 1;
                    }
                    setState(() {});
                  },
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    child: Row(
                      children: [
                        Image.asset(
                          status == 1 ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        H16(text: LanguageService.trans("yes"), weight: FW.medium, color: AppColor_BlackText),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (type == 1) {
                      arrLangStep1idxList![index] = 0;
                    } else if (type == 2) {
                      arrLangStep2IdxList![index] = 0;
                    } else if (type == 3) {
                      arrSocial1Step1IdxList![index] = 0;
                    } else if (type == 4) {
                      arrSocial2Step1IdxList![index] = 0;
                    } else if (type == 5) {
                      arrWorkStep1IdxList![index] = 0;
                    } else if (type == 6) {
                      arrWorkStep2IdxList![index] = 0;
                    }
                    setState(() {});
                  },
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    child: Row(
                      children: [
                        Image.asset(
                          status == 0 ? "assets/ic_option_on.png" : "assets/ic_option_off.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        H16(text: LanguageService.trans("no"), weight: FW.medium, color: AppColor_BlackText),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
          ),
        ],
      ),
    );
  }

  //on/off상태 얻기
  int getStatusIdx(String msg) {
    for (int i = 0; i < arrLangStep1List!.length; i++) {
      if (arrLangStep1List![i] == msg) {
        return arrLangStep1idxList![i];
      }
    }

    for (int i = 0; i < arrLangStep2List!.length; i++) {
      if (arrLangStep2List![i] == msg) {
        return arrLangStep2IdxList![i];
      }
    }

    for (int i = 0; i < arrWorkStep1List!.length; i++) {
      if (arrWorkStep1List![i] == msg) {
        return arrWorkStep1IdxList![i];
      }
    }

    for (int i = 0; i < arrWorkStep2List!.length; i++) {
      if (arrWorkStep2List![i] == msg) {
        return arrWorkStep2IdxList![i];
      }
    }

    for (int i = 0; i < arrSocial1Step1List!.length; i++) {
      if (arrSocial1Step1List![i] == msg) {
        return arrSocial1Step1IdxList![i];
      }
    }

    for (int i = 0; i < arrSocial2Step1List!.length; i++) {
      if (arrSocial2Step1List![i] == msg) {
        return arrSocial2Step1IdxList![i];
      }
    }

    return 0;
  }

  // Network functions
  //////////////////////////////////
  //모니터링 두뇌 질문 리스트
  Future<void> getBrainQuizList() async {
    setState(() {
      isLoading = true;
    });

    Future<BrainQuizListResModel> offerInfo = httpService.monitoringBrainList();
    offerInfo.then((BrainQuizListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        //언어
        arrLangStep1List!.addAll(value.data!.language!.understand1!);
        arrLangStep1List!.addAll(value.data!.language!.describe1!);

        arrLangStep2List!.addAll(value.data!.language!.understand2!);
        arrLangStep2List!.addAll(value.data!.language!.describe2!);

        //운동
        arrWorkStep1List!.addAll(value.data!.workOut!.bigMuscle1!);
        arrWorkStep1List!.addAll(value.data!.workOut!.smallMuscle1!);

        arrWorkStep2List!.addAll(value.data!.workOut!.bigMuscle2!);
        arrWorkStep2List!.addAll(value.data!.workOut!.smallMuscle2!);

        //사회성
        arrSocial1Step1List!.addAll(value.data!.social!.action1!);
        arrSocial2Step1List!.addAll(value.data!.social!.action2!);

        /////////////////
        for (int i = 0; i < arrLangStep1List!.length; i++) {
          arrLangStep1idxList!.add(1);
        }

        for (int i = 0; i < arrLangStep2List!.length; i++) {
          arrLangStep2IdxList!.add(1);
        }

        for (int i = 0; i < arrWorkStep1List!.length; i++) {
          arrWorkStep1IdxList!.add(1);
        }

        for (int i = 0; i < arrWorkStep2List!.length; i++) {
          arrWorkStep2IdxList!.add(1);
        }

        for (int i = 0; i < arrSocial1Step1List!.length; i++) {
          arrSocial1Step1IdxList!.add(1);
        }

        for (int i = 0; i < arrSocial2Step1List!.length; i++) {
          arrSocial2Step1IdxList!.add(1);
        }

        ///////////////////////////
        arrUnderstandList1 = value.data!.language!.understand1;
        arrUnderstandList2 = value.data!.language!.understand2;
        arrDescribeList1 = value.data!.language!.describe1;
        arrDescribeList2 = value.data!.language!.describe2;
        arrActionList1 = value.data!.social!.action1;
        arrActionList2 = value.data!.social!.action2;
        arrBigMuscleList1 = value.data!.workOut!.bigMuscle1;
        arrBigMuscleList2 = value.data!.workOut!.bigMuscle2;
        arrSmailMuscleList1 = value.data!.workOut!.smallMuscle1;
        arrSmailMuscleList2 = value.data!.workOut!.smallMuscle2;

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
    });
  }

  void goNext() {
    Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringResultPage()));
    httpService.monitoringSave();
    Future<DefaultResModel> info = httpService.monitoringSave();
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast("success");
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

  //모니터링 기록
  Future<void> saveMonitoring() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String monitoring_time = dateFormat.format(DateTime.now()); //앱내 모니터링 날짜(yyyy-MM-dd HH:mm:ss)
    String height = monitoringData == null ? "" : monitoringData!.height!; //신장
    String weight = monitoringData == null ? "" : monitoringData!.weight!; //몸무게
    String nutrition = monitoringData == null ? "" : monitoringData!.nutrition!; //카로리(아침,점심,간식,저녁), 반점으로 구분, 없으면 0
    String sleep_at_night = monitoringData == null ? "" : monitoringData!.sleep_at_night!; //밤잠
    String sleep_at_lunch = monitoringData == null ? "" : monitoringData!.sleep_at_lunch!; //낮잠
    String symptom_list = ""; //질병데이터 json 리스트(예시대로 올려야 함)
    String language = ""; //언어성평가 json데이터
    String sociability = ""; //사회성평가 json데이터
    String work_out = ""; //운동성평가 json데이터

    final p = Provider.of<OldFoodListProvider>(context);
    List<FoodDto> food1 = monitoringData == null ? [] : p.food1;
    List<FoodDto> food2 = monitoringData == null ? [] : p.food2;
    List<FoodDto> food3 = monitoringData == null ? [] : p.food3;
    List<FoodDto> food4 = monitoringData == null ? [] : p.food4;

    //신체발달 관련
    if (widget.hasDisease == 1) {
      List<Map<String, String>> symptomList = [];
      if (monitoringData != null) {
        for (int i = 0; i < monitoringData!.symptom_list!.length; i++) {
          //카테고리
          String category = monitoringData!.symptom_list![i].category!;
          //질병
          String symptom = monitoringData!.symptom_list![i].symptom!;
          //질병 진단 날짜 체크
          String record_time = monitoringData!.symptom_list![i].record_time!;

          //수술/검사 여부
          String surgey_name = "";
          String surgey_time = "";
          if (widget.surgeryList![i] == 1) {
            surgey_name = monitoringData!.symptom_list![i].surgey_name!;
            surgey_time = monitoringData!.symptom_list![i].surgey_time!;
          }

          //복약 여부
          String img = "";
          if (widget.hasphotoList![i] == 1) {
            img = monitoringData!.symptom_list![i].medication!;
            File file = File(img);
            img = file.path.split('/').last;
          }

          Map<String, String> info = {
            'category': category,
            'symptom': symptom,
            'record_time': record_time,
            'surgery_name': surgey_name,
            'surgery_time': surgey_time,
            'medication': img,
          };
          symptomList.add(info);
        }
      }

      symptom_list = json.encode(symptomList);
    }

    //두뇌발달 관련
    //언어
    List<int> understand1 = [];
    for (int i = 0; i < arrUnderstandList1!.length; i++) {
      understand1.add(getStatusIdx(arrUnderstandList1![i]));
    }
    List<int> understand2 = [];
    for (int i = 0; i < arrUnderstandList2!.length; i++) {
      understand2.add(getStatusIdx(arrUnderstandList2![i]));
    }
    List<List<int>> understand = [[]];
    understand.clear();
    understand.add(understand1);
    understand.add(understand2);

    List<int> describe1 = [];
    for (int i = 0; i < arrDescribeList1!.length; i++) {
      describe1.add(getStatusIdx(arrDescribeList1![i]));
    }
    List<int> describe2 = [];
    for (int i = 0; i < arrDescribeList2!.length; i++) {
      describe2.add(getStatusIdx(arrDescribeList2![i]));
    }
    List<List<int>> describe = [[]];
    describe.clear();
    describe.add(describe1);
    describe.add(describe2);

    Map<String, List<List<int>>> info1 = {
      'understand': understand,
      'describe': describe,
    };
    language = json.encode(info1);

    //사회성
    List<int> action1 = [];
    for (int i = 0; i < arrActionList1!.length; i++) {
      action1.add(getStatusIdx(arrActionList1![i]));
    }
    List<int> action2 = [];
    for (int i = 0; i < arrActionList2!.length; i++) {
      action2.add(getStatusIdx(arrActionList2![i]));
    }
    List<List<int>> action = [[]];
    action.clear();
    action.add(action1);
    action.add(action2);

    Map<String, List<List<int>>> info2 = {
      'action': action,
    };
    sociability = json.encode(info2);

    //운동
    List<int> big1 = [];
    for (int i = 0; i < arrBigMuscleList1!.length; i++) {
      big1.add(getStatusIdx(arrBigMuscleList1![i]));
    }
    List<int> big2 = [];
    for (int i = 0; i < arrBigMuscleList2!.length; i++) {
      big2.add(getStatusIdx(arrBigMuscleList2![i]));
    }
    List<List<int>> big = [[]];
    big.clear();
    big.add(big1);
    big.add(big2);

    List<int> small1 = [];
    for (int i = 0; i < arrSmailMuscleList1!.length; i++) {
      small1.add(getStatusIdx(arrSmailMuscleList1![i]));
    }
    List<int> small2 = [];
    for (int i = 0; i < arrSmailMuscleList2!.length; i++) {
      small2.add(getStatusIdx(arrSmailMuscleList2![i]));
    }
    List<List<int>> small = [[]];
    small.clear();
    small.add(small1);
    small.add(small2);

    Map<String, List<List<int>>> info3 = {
      'big_muscle': big,
      'small_muscle': small,
    };
    work_out = json.encode(info3);

    String foodJson1 = json.encode(food1);
    String foodJson2 = json.encode(food2);
    String foodJson3 = json.encode(food3);
    String foodJson4 = json.encode(food4);

    setState(() {
      isLoading = true;
    });

    Future<MonitoringRecordResModel> info = httpService.monitoringRecord(
        monitoring_time,
        height,
        weight,
        nutrition,
        sleep_at_night,
        sleep_at_lunch,
        symptom_list,
        language,
        sociability,
        work_out,
        foodJson1,
        foodJson2,
        foodJson3,
        foodJson4,
        widget.uid!);
    info.then((MonitoringRecordResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        LocalService.setMonitoringStatus("1");
        String _recv = await Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringResult1Page(uid: value.data!.id)));
        if (_recv != null && _recv != "") {
          Navigator.pop(context, _recv);
        }
      } else {
        if (value.result == 106) {
          //token expired
          showToast(value.msg ?? "");
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        } else if (value.result == 203) {
          showToast("오늘 이미 모니터링을 하셨습니다.");
        } else {
          showToast(value.msg ?? "");
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
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleHeader(
                  title: LanguageService.trans('diagnosis_of_the_day'),
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H24B(
                          text: LanguageService.trans("2_brain_development"),
                          color: AppColor_BlackText,
                          align: TextAlign.left,
                          height: 1.5,
                        ),
                        //언어
                        Visibility(
                          visible: widget.selBrain!.contains(0),
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  H18(
                                    text: LanguageService.trans("by_age"),
                                    weight: FW.bold,
                                  ),
                                  const SizedBox(width: 2),
                                  H18(
                                    text: LanguageService.trans("language"),
                                    weight: FW.bold,
                                    color: AppColor_Primary,
                                  ),
                                  const SizedBox(width: 3),
                                  H18(
                                    text: LanguageService.trans("please_record_your_progress"),
                                    weight: FW.bold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Visibility(
                                visible: arrLangStep1List!.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: H18(
                                    text: "연령 전 단계",
                                    weight: FW.bold,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _getTiles(1, index);
                                  },
                                  itemCount: arrLangStep1List!.length,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 1,
                                color: AppColor_Selector_Border,
                              ),
                              const SizedBox(height: 50),
                              Visibility(
                                visible: arrLangStep2List!.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: H18(
                                    text: "현재 연령 단계",
                                    weight: FW.bold,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _getTiles(2, index);
                                  },
                                  itemCount: arrLangStep2List!.length,
                                ),
                              ),
                              // const SizedBox(height: 40),
                              Container(
                                height: 1,
                                width: screenSize.width - 60,
                                decoration: BoxDecoration(color: AppColor_BlackText.withOpacity(0.07)),
                              ),
                            ],
                          ),
                        ),
                        //사회성
                        Visibility(
                          visible: widget.selBrain!.contains(2),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  H18(
                                    text: LanguageService.trans("by_age"),
                                    weight: FW.bold,
                                  ),
                                  const SizedBox(width: 2),
                                  H18(
                                    text: LanguageService.trans("sociability"),
                                    weight: FW.bold,
                                    color: AppColor_Primary,
                                  ),
                                  const SizedBox(width: 3),
                                  H18(
                                    text: LanguageService.trans("please_record_your_progress"),
                                    weight: FW.bold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Visibility(
                                visible: arrSocial1Step1List!.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: H18(
                                    text: "연령 전 단계",
                                    weight: FW.bold,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _getTiles(3, index);
                                  },
                                  itemCount: arrSocial1Step1List!.length,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 1,
                                color: AppColor_Selector_Border,
                              ),
                              const SizedBox(height: 50),
                              Visibility(
                                visible: arrSocial2Step1List!.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: H18(
                                    text: "현재 연령 단계",
                                    weight: FW.bold,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _getTiles(4, index);
                                  },
                                  itemCount: arrSocial2Step1List!.length,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                height: 1,
                                width: screenSize.width - 60,
                                decoration: BoxDecoration(color: AppColor_BlackText.withOpacity(0.07)),
                              ),
                            ],
                          ),
                        ),
                        //운동
                        Visibility(
                          visible: widget.selBrain!.contains(1),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  H18(
                                    text: LanguageService.trans("by_age"),
                                    weight: FW.bold,
                                  ),
                                  const SizedBox(width: 2),
                                  H18(
                                    text: LanguageService.trans("work_out"),
                                    weight: FW.bold,
                                    color: AppColor_Primary,
                                  ),
                                  const SizedBox(width: 3),
                                  H18(
                                    text: LanguageService.trans("please_record_your_progress"),
                                    weight: FW.bold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Visibility(
                                visible: arrWorkStep1List!.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: H18(
                                    text: "연령 전 단계",
                                    weight: FW.bold,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _getTiles(5, index);
                                  },
                                  itemCount: arrWorkStep1List!.length,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 1,
                                color: AppColor_Selector_Border,
                              ),
                              const SizedBox(height: 50),
                              Visibility(
                                visible: arrWorkStep2List!.isNotEmpty,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: H18(
                                    text: "현재 연령 단계",
                                    weight: FW.bold,
                                    align: TextAlign.start,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _getTiles(6, index);
                                  },
                                  itemCount: arrWorkStep2List!.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H18(
                              text: (2).toString(),
                              weight: FW.bold,
                            ),
                            H18(
                              text: ' / 2',
                              weight: FW.regular,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )),
                MainTextButton(
                  text: "모니터링 결과보기",
                  backgroundColor: AppColor_Primary,
                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                  radius: 0,
                  height: 66,
                  onPressed: () {
                    //goNext();
                    saveMonitoring();
                  },
                ),
              ],
            )));
  }
}
