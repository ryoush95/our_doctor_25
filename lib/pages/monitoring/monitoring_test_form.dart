import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/monitoring/monitor_report1.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_test_result.dart';
import 'package:ourdoctor/provider/child_quiz_provider.dart';
import 'package:provider/provider.dart';

class MonitoringTestForm extends StatefulWidget {
  const MonitoringTestForm({Key? key}) : super(key: key);

  @override
  State<MonitoringTestForm> createState() => _MonitoringTestFormState();
}

class _MonitoringTestFormState extends BaseState<MonitoringTestForm> {
  String option = "1";
  int option4 = 0;
  List<String> allList = [];
  List<String> selList = [];
  List<String> list4 = ["할 수 없다", "잘못한다", "할 수 있다", "잘한다"];
  List<String> list4Img = [];
  List<String> cate = ["발달영역", "생활습관", "신체"];
  List<String> subCate1 = ["1","2","3"];
  List<String> subCate2 = ["1","2","3","4"];
  int cateNum = 0;
  int subNum = 0;

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
    for (int i = 0; i < 10; i++) {
      selList.add("0");
    }
    _listSc = ScrollController();
    _listSc2 = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _listSc!.dispose();
    _listSc2!.dispose();
  }

  // void goNext() {
  //   if (widget.list.sublist(0, widget.list.length).where((element) => element.answer == "").toList().isNotEmpty) {
  //     showToast('모든 문항에 대한 답변이 필요합니다.');
  //     return;
  //   }
  //   for(var i in widget.list){
  //     Provider.of<ChildQuizProvider>(context, listen: false).updateList(i.id!, i.answer);
  //   }
  // }

  bool checkValid() {
    if (selList
        .sublist(0, selList.length)
        .where((element) => element == "")
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  void goNext() {
    if (selList.sublist(0, 10).where((element) => element == "").toList().isNotEmpty) {
      showToast('모든 문항에 대한 답변이 필요합니다.');
      return;
    }

    selList.clear();
    for (int i = 0; i < 10; i++) {
      selList.add("1");
    }

    if (subNum == subCate1.length-1) {
      cateNum++;
      allList.addAll(selList);
      subNum = 0;
    } else {
      subNum++;
    }
    // _listSc2!.jumpTo(0.0);
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColor_Primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      subCate1[subNum],
                      style: TextStyle(color: Colors.white),
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
                    cate[cateNum] != "신체" ? ListView.builder(
                      itemCount: selList.length,
                      shrinkWrap: true,
                      controller: _listSc,
                      itemBuilder: (context, index) {
                        return testTile2(index);
                    },) : bodyCheck(),
                    const SizedBox(height: 30),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: subCate1.length-1 == subNum,
                            child: MainTextButton(
                              text: "검사 저장하기",
                              backgroundColor: AppColor_Green,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                              radius: 6,
                              height: 55,
                              width: 150,
                              disable: !checkValid(),
                              disableBackground:
                              !checkValid() ? AppColor_Primary_Disable : Colors.transparent,
                              onPressed: () {
                                // goNext();
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          MainTextButton(
                            text: cate[cateNum] == "신체" ? "완료" : "다음",
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            radius: 6,
                            height: 55,
                            width: 150,
                            disable: !checkValid(),
                            disableBackground: !checkValid() ? AppColor_Primary_Disable : Colors.transparent,
                            onPressed: () {
                              if(!checkValid()) return;
                              if(cate[cateNum] == "신체"){
                                Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => const MonitorReport1(),));
                                return;
                              }
                              goNext();
                              setState(() {});
                              // Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringTestResult(),));
                            },
                          ),
                        ],
                      ),
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
            text: "answpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
        ),
        const SizedBox(height: 35),
        FlutterLogo(
          size: 100,
        ),
        const SizedBox(height: 35),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selList[index] = "1";
                    });
                  },
                  child: Row(
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
                            width: 50,
                            padding: const EdgeInsets.fromLTRB(3, 3, 5, 3),
                            // color: AppColor_Primary,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                color: AppColor_Primary
                            ),
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
                    selList[index] = "0";
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: const EdgeInsets.fromLTRB(3, 3, 5, 3),
                          // color: AppColor_Primary,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                              color: AppColor_Primary
                          ),
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

  Widget testTile4() {
    var screenSize = MediaQuery.of(context).size;
    double h = 25;
    double w = (MediaQuery.of(context).size.width-44) / 4;
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(children: [
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: "Q1",
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
            text: "answpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
        ),
        const SizedBox(height: 35),
        FlutterLogo(
          size: 100,
        ),
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
                        });
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            option4 == index
                                ? "assets/choose_on.png"
                                : "assets/choose_off.png",
                            height: 25,
                          ),
                          const SizedBox(height: 20),
                          option4 == index
                              ? Container(
                            height: h,
                            width: index == 3 ? 70 : w + 3,
                            padding: const EdgeInsets.fromLTRB(3, 3, 5, 3),
                            // color: AppColor_Primary,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                color: AppColor_Primary
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/choose_check.png",
                                  width: 18,
                                ),
                                const SizedBox(width: 5),
                                H14(
                                    text: list4[index],
                                    weight: FW.medium,
                                    color: AppColor_White),
                              ],
                            ),
                          )
                              : SizedBox(
                              height: h,
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
                },),
            )
        ),
        const SizedBox(width: 55),
      ]),
    );
  }

  Widget bodyCheck() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(20.0),
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
                          keyboardType:
                          const TextInputType
                              .numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction:
                          TextInputAction.done,
                          placeholder: "",
                          onChanged: (text) {
                            // monitoringData!.height = text;
                            setState(() {});
                            checkValid();
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
                          keyboardType:
                          const TextInputType
                              .numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction:
                          TextInputAction.done,
                          placeholder: "",
                          onChanged: (text) {
                            // monitoringData!.weight = text;
                            setState(() {});
                            checkValid();
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
        ],
      ),
    );
  }

}
