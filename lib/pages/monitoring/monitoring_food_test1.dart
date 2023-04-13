import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/food_check_list1_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_result.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test2.dart';

class MonitoringFoodTest1 extends StatefulWidget {
  const MonitoringFoodTest1({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodTest1> createState() => _MonitoringFoodTest1State();
}

class _MonitoringFoodTest1State extends BaseState<MonitoringFoodTest1> {
  final HttpService httpService = HttpService();
  List<FoodCheck1> list = [];
  int quizNum = 0;
  int pageNum = 0;
  int nowNum = 0;
  List<FoodCheck1> quizList = [];
  List<String> quizResult = [];
  final itemCount = 6;
  bool lastPage = false;
  late ScrollController _listController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listController = ScrollController();
    getChekcList1();
  }

  Future<bool> onBackPressed() async {
    Navigator.pushReplacement(
        context,
        SlideRightTransRoute(
          builder: (context) => MonitoringFoodResult(),
        ));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  void getChekcList1() async {
    Future<FoodCheckList1> info = httpService.getCheckList1();
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list = value.data!.values.toList();
        goNext();
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  bool checkValid() {
    // print(list
    //     .sublist(pageNum * 5, )
    //     .where((element) => element.answer == "-1")
    //     .toList());
    if (quizList
        .sublist(0, quizList.length)
        .where((element) => element.answer == "-1")
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  void goNext() {
    quizList.clear();
    pageNum++;
    for (int i = nowNum; i < nowNum + itemCount; i++) {
      if (list.length == i) {
        lastPage = true;
        break;
      }
      quizList.add(list[i]);
    }
    nowNum = nowNum + itemCount;
    // for (var i in list) {
    //   if (i.page == pageNum.toString()) {
    //     quizList.add(i);
    //   }
    // }
    setState(() {});
  }

  Future<void> getResult() async {
    quizResult = list.map((e) => e.answer).toList();
    Navigator.of(context).pushReplacement(SlideRightTransRoute(
        builder: (context) => MonitoringFoodTest2(
              test1Data: quizResult,
            )));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    int numId = index + ((pageNum - 1) * itemCount);
    return SizedBox(
      height: 400,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Q${numId + 1}\n\n",
                style: AppTextStyle.PD(AppColor_Table_DateTime, 18,
                    weight: FW.bold),
              ),
              TextSpan(
                text: quizList[index].question!,
                style: AppTextStyle.PD(AppColor_BlackText, 17,
                    weight: FW.regular, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        checkbox(index, numId),
        const SizedBox(height: 30)
      ]),
    );
  }

  Widget checkbox(int index, int numId) {
    List<String> chekcList = quizList[index].choices!.split(",");
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width - 64,
          child: ListView.builder(
            // scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, check) => SizedBox(
              height: 50,
              width: (MediaQuery.of(context).size.width - 64) / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        list[numId].answer = "$check";
                        quizList[index].answer = "$check";
                      });
                    },
                    child: Image.asset(
                      quizList[index].answer == "$check"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(width: 10),
                  H16(text: chekcList[check]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      onBack: onBackPressed,
      child: Column(children: [
        SimpleHeader(
          title: "영양모니터링",
          onBackPressed: onBackPressed,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              controller: _listController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "식습관\n",
                            style: AppTextStyle.PD(
                              AppColor_Primary,
                              18,
                              weight: FW.bold,
                            ),
                          ),
                          TextSpan(
                            text: "체크리스트\n\n",
                            style: AppTextStyle.PD(AppColor_BlackText, 18,
                                weight: FW.bold, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                "$pageNum / ${(list.length / itemCount).round()}",
                            style: AppTextStyle.PD(AppColor_Table_DateTime, 15,
                                weight: FW.regular),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: quizList.length * 400,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quizList.length,
                      itemBuilder: _itemBuilder,
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColor_Gray,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            H12(
                              text: "자료 출처",
                              color: AppColor_Gray,
                              align: TextAlign.start,
                            ),
                            H12(
                              text:
                                  "\n김혜영. 어린이, 노인 등 맞춤 건강 식생활 정보 개발 및 활용 연구.\n\n식품의약안전처 연구용역보고서, 2021년",
                              color: AppColor_Gray,
                              align: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MainTextButton(
                    text: "다음",
                    backgroundColor: AppColor_Primary,
                    style: AppTextStyle.PD(Colors.white, 18, weight: FW.medium),
                    width: double.infinity,
                    height: 60,
                    radius: 10,
                    disable: !checkValid(),
                    disableBackground: !checkValid()
                        ? AppColor_Primary_Disable
                        : Colors.transparent,
                    onPressed: () {
                      if (!checkValid()) {
                        showToast("모든 문항에 체크해주세요");
                        return;
                      }
                      if (lastPage) {
                        getResult();
                        return;
                      }
                      goNext();
                      _listController.jumpTo(0.0);
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
