import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/monitor_development_list_model.dart';
import 'package:ourdoctor/models/monitor_life_list2_model.dart';
import 'package:ourdoctor/models/monitoring_record_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/monitoring/monitor_report1.dart';

class MonitoringTestForm extends StatefulWidget {
  const MonitoringTestForm({Key? key}) : super(key: key);

  @override
  State<MonitoringTestForm> createState() => _MonitoringTestFormState();
}

class _MonitoringTestFormState extends BaseState<MonitoringTestForm> {
  HttpService httpService = HttpService();
  int option4 = 0;
  bool isValid = false;
  List<String> allList = [];
  List<String> selList = [];
  List<String> quizNum = [];
  List<String> quizList = [];
  Map<String, String> answer = {};
  List<String> list4 = ["할 수 없다", "잘못한다", "할 수 있다", "잘한다"];
  List<String> list4Img = [];
  List<String> cate = ["발달영역", "생활습관", "신체"];
  List<String> subCate1 = ["대근육", "소근육", "인지", "언어", "사회성", "자조"];
  List<String> subCate2 = ["개인위생", "구강교육", "감각", "안전사고", "영양", "전자미디어", "정서", "대소변", "수면교육"];
  final List<String> bodyString = ["적정량의 식사를 하나요?", "매일 충분히 잠을 자나요?", "하루에 신체활동을 잘하나요?"];
  List<int> bodyScore = [0,0,0];

  int cateNum = 0;
  int subNum = 0;
  List<String> list = [];
  List<Map<String, HealthTestDto>>? map;
  List<Map<String, HealthTestDto>>? map2;

  String tall = "";
  String weight = "";
  String score = "";
  Color tallColor = AppColor_Selector_Border;
  Color weightColor = AppColor_Selector_Border;

  ScrollController? _listSc;
  ScrollController? _listSc2;
  TextEditingController tallCon = TextEditingController();
  TextEditingController weightCon = TextEditingController();

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = subCate1;
    _listSc = ScrollController();
    _listSc2 = ScrollController();
    getQuizList();
  }

  @override
  void dispose() {
    super.dispose();
    _listSc!.dispose();
    _listSc2!.dispose();
  }

  Future<void> getQuizList() async {
    Future<MonitoringHealthListModel> info = httpService.getMonitoringHealthList();
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list = value.data!.keys.toList();
        map = value.data!.values.toList();
        changeList();

        setState(() {});
      }
    }).catchError((onError) {
      showToast("검사기간이 아닙니다");
      Navigator.pop(context);
      print(onError.toString());
    });
  }

  Future<void> getQuizList2() async {
    Future<MonitoringHealthListModel> info2 = httpService.getMonitoringLifeList2();
    info2.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list = value.data!.keys.toList();
        map2 = value.data!.values.toList();
        changeList();
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  bool checkBodyValid() {
    if (quizList
        .sublist(0, quizList.length)
        .where((element) => element == "")
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  void changeList() {
    if (cateNum == 0) {
      map![subNum].forEach((key, value) {
        quizNum.add(key);
        quizList.add(value.question!);
        selList.add("1");
      });
    } else if (cateNum == 1){
      map2![subNum].forEach((key, value) {
        quizNum.add(key);
        quizList.add(value.question!);
        selList.add("1");
      });
    }
  }

  void goNext() async {
    if (selList.contains("-1")) {
      showToast('모든 문항에 대한 답변이 필요합니다.');
      return;
    }
    allList.addAll(selList);
    quizList.clear();
    selList.clear();

    if (subNum == list.length - 1) {
      goSave();
      quizNum.clear();
      cateNum++;
      subNum = 0;

      if (cateNum == 1) {
        getQuizList2();
        setState(() {});
      }
      allList.clear();

    } else {
      subNum++;
      changeList();
    }
    _listSc2!.jumpTo(0.0);
  }

  Future<void> goSave() async{
    Future<DefaultResModel>? insert;
    if (cateNum == 0) {
      insert = httpService.inputHealthSendResult(jsonEncode(quizNum), jsonEncode(allList));
    } else if (cateNum == 1){
      insert = httpService.inputLifeSendResult(jsonEncode(quizNum), jsonEncode(allList));
    }
    insert!.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        // showToast("검사가 저장되었습니다");
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> saveBody() async {
    int s = bodyScore.reduce((value, element) => value+element);
    score = (s * 2).toString();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String monitoring_time = dateFormat.format(DateTime.now());
    Future<MonitoringRecordResModel>? insert = httpService.monitoringRecord(monitoring_time, tall, weight, "", "", "", "", "", "", "", "", "", "", "", "");
    insert.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.pushReplacement(
            context,
            SlideRightTransRoute(
              builder: (context) =>
              const MonitorReport1(),
            ));
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        onBack: onBackPressed,
        child: Column(
          children: [
            SimpleHeader(
              onBackPressed: onBackPressed,
              title: "우아 발달 모니터링",
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColor_Primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      cate[cateNum],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Visibility(
                  visible: cate[cateNum] != "신체",
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColor_Primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        list[subNum],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                controller: _listSc2,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // testTile4(),
                    cate[cateNum] != "신체"
                        ? ListView.builder(
                            itemCount: quizList.length,
                            shrinkWrap: true,
                            controller: _listSc,
                            itemBuilder: (context, index) {
                              if (cateNum == 0) {
                                return testTile4(index);
                              } else {
                                return testTile2(index);
                              }
                            },
                          )
                        : bodyCheck(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: list.length - 1 == subNum,
                          child: MainTextButton(
                            text: "검사 저장하기",
                            backgroundColor: AppColor_Green,
                            style: AppTextStyle.PD(Colors.white, 18,
                                weight: FW.bold),
                            radius: 6,
                            height: 55,
                            width: 150,
                            disable: !checkBodyValid(),
                            disableBackground: !checkBodyValid()
                                ? AppColor_Primary_Disable
                                : Colors.transparent,
                            onPressed: () {
                              allList.addAll(selList);
                              goSave();
                              showToast('저장되었습니다');
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        MainTextButton(
                          text: cate[cateNum] == "신체" ? "완료" : "다음",
                          backgroundColor: AppColor_Primary,
                          style: AppTextStyle.PD(Colors.white, 18,
                              weight: FW.bold),
                          radius: 6,
                          height: 55,
                          width: 150,
                          disable: !checkBodyValid(),
                          disableBackground: !checkBodyValid()
                              ? AppColor_Primary_Disable
                              : Colors.transparent,
                          onPressed: () {
                            if (!checkBodyValid()) return;
                            if (cate[cateNum] == "신체") {
                              if (isValid == false || tall.isEmpty || weight.isEmpty) {
                                showToast("키와 체중을 정확히 입력해주세요");
                                return;
                              }
                              saveBody();
                              return;
                            }
                            goNext();
                            setState(() {});
                            // Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringTestResult(),));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget testTile2(index) {
    var screenSize = MediaQuery.of(context).size;
    double h = 25;
    double w = 80;
    return Container(
      width: screenSize.width,
      padding: const EdgeInsets.all(18),
      child: Column(children: [
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: "Q ${index + 1}",
            maxLine: 1,
            color: AppColor_Gray,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.bold,
          ),
        ),
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: quizList[index],
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
        ),
        const SizedBox(height: 35),
        // FlutterLogo(
        //   size: 100,
        // ),
        // const SizedBox(height: 35),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selList[index] = "0";
                    });
                  },
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            selList[index] == "0"
                                ? "assets/choose_on.png"
                                : "assets/choose_off.png",
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(height: 20),
                          selList[index] == "0"
                              ? Container(
                                  height: h,
                                  width: 50,
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 3, 5, 3),
                                  // color: AppColor_Primary,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                      color: AppColor_Primary),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/choose_check.png",
                                      ),
                                      const SizedBox(width: 5),
                                      H16(
                                          text: "예 ",
                                          weight: FW.medium,
                                          color: AppColor_White),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: h,
                                  width: 50,
                                  child: Center(
                                    child: H16(
                                        text: "예 ",
                                        weight: FW.medium,
                                        color: AppColor_BlackText),
                                  )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 55),
              InkWell(
                onTap: () {
                  setState(() {
                    selList[index] = "1";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          selList[index] == "1"
                              ? "assets/choose_on.png"
                              : "assets/choose_off.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(height: 20),
                        selList[index] == "1"
                            ? Container(
                                height: h,
                                width: w,
                                padding: const EdgeInsets.fromLTRB(3, 3, 5, 3),
                                // color: AppColor_Primary,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    color: AppColor_Primary),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/choose_check.png"),
                                    const SizedBox(width: 5),
                                    H16(
                                        text: "아니오",
                                        weight: FW.medium,
                                        color: AppColor_White),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: h,
                                width: w,
                                child: Center(
                                  child: H16(
                                      text: "아니오",
                                      weight: FW.medium,
                                      color: AppColor_BlackText),
                                )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 55),
      ]),
    );
  }

  Widget testTile4(int testNum) {
    var screenSize = MediaQuery.of(context).size;
    double h = 25;
    double w = (MediaQuery.of(context).size.width - 44) / 4;
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(children: [
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: "Q ${testNum + 1}",
            maxLine: 1,
            color: AppColor_Gray,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.bold,
          ),
        ),
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: quizList[testNum],
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
        ),
        const SizedBox(height: 35),
        // Image.network(map.muscle1[testNum]!.imageUrl!),
        const SizedBox(height: 35),
        Center(
            child: Container(
          width: screenSize.width,
          height: 100,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: list4.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      option4 = index;
                      selList[testNum] = index.toString();
                    });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        selList[testNum] == index.toString()
                            ? "assets/choose_on.png"
                            : "assets/choose_off.png",
                        height: 25,
                      ),
                      const SizedBox(height: 20),
                      selList[testNum] == index.toString()
                          ? Container(
                              height: h,
                              width: w + 3,
                              padding: const EdgeInsets.fromLTRB(3, 3, 5, 3),
                              // color: AppColor_Primary,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  color: AppColor_Primary),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    "assets/choose_check.png",
                                    width: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Center(
                                      child: H14(
                                          text: list4[index],
                                          weight: FW.medium,
                                          color: AppColor_White),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: h,
                              width: w,
                              child: Center(
                                child: H14(
                                    text: list4[index],
                                    weight: FW.medium,
                                    color: AppColor_BlackText),
                              )),
                    ],
                  ),
                ),
              );
            },
          ),
        )),
        const SizedBox(width: 55),
      ]),
    );
  }

  Widget bodyCheck() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              H16(
                text: "키와 체중을 입력해주세요.",
                weight: FW.medium,
                color: AppColor_BlackText,
                align: TextAlign.start,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: (screenSize.width - 70) / 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlineNumInput(
                          controller: tallCon,
                          borderColor: tallColor,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.done,
                          placeholder: "",
                          onChanged: (text) {
                            tall = text;
                            if (double.parse(tall) < 0 ||
                                double.parse(tall) > 200) {
                              isValid = false;
                              tallColor = Colors.red;
                            } else {
                              isValid = true;
                              tallColor = AppColor_Selector_Border;
                            }
                            // checkBodyValid();
                            setState(() {});
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
                  )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: (screenSize.width - 70) / 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlineNumInput(
                          controller: weightCon,
                          borderColor: weightColor,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.done,
                          placeholder: "",
                          onChanged: (text) {
                            weight = text;
                            if (double.parse(weight) < 0 ||
                                double.parse(weight) > 200) {
                              isValid = false;
                              weightColor = Colors.red;
                            } else {
                              isValid = true;
                              weightColor = AppColor_Selector_Border;
                            }
                            // checkBodyValid();
                            setState(() {
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      H17(
                        text: LanguageService.trans("kg"),
                        weight: FW.medium,
                        color: AppColor_BlackText,
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 50),
          Container(
              height: 150,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColor_Light_Gray),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bodyScore.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (bodyScore[index] == 0){
                            bodyScore[index] = 1;
                          } else {
                            bodyScore[index] = 0;
                          }
                          setState(() {});
                        },
                        child: Row(children: [
                          Image.asset(
                            bodyScore[index] == 0 ? "assets/ic_radio_off.png"
                                :"assets/ic_radio_on.png",
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          H16(
                            text: bodyString[index],
                            weight: FW.regular,
                          )
                        ]),
                      ),
                      const SizedBox(height: 18),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
