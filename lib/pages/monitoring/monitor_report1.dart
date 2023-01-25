import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitor_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/height_report.dart';
import 'package:ourdoctor/pages/home/prev_monitoring.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/home/weight_report.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_test_result.dart';
import 'package:ourdoctor/pages/monitoring/solution_area.dart';
import 'package:sprintf/sprintf.dart';

class MonitorReport1 extends StatefulWidget {
  const MonitorReport1({Key? key}) : super(key: key);

  @override
  State<MonitorReport1> createState() => _MonitorReport1State();
}

class _MonitorReport1State extends BaseState<MonitorReport1> {
// List<MonitoringDto> monitoringList = [];
  // static const platform = MethodChannel('doctor.flutter.dev');
  final HttpService httpService = HttpService();
  bool isLast = false;
  int subTabIndex = 0;
  int tabIndex = 0;
  int subTabIndex2 = 0;
  List<MonitorListDto>? arrMonitorList = [];
  String comment1 = "또래보다 느릴 수 있어 심화평가 권고";
  String comment2 = """
큰 근육을 이용한 운동발달이 또래보다 느릴 수 있어요. 대근육운동은 아이의 신경계 및 근골격계의 발달과 밀접하게 연관되어 있어요.
아이들은 운동기능을 통해 세상을 탐색하며 신체,
인지, 정서를 발달시켜나가요.
자세한 발달 상태 파악을 위해 병원 진단 진단 및 상담이 필요합니다.
""";

  //FIXME: 테스트후 삭제
  void qkfekf(int index) {
    if (testScore[index] < 80) {
      comment1 = "노력이 필요해요";
    } else if (testScore[index] < 90) {
      comment1 = "보통이에요";
    } else {
      comment1 = "잘하고있어요 ";
    }
    return;
  }

  void qkfekf2(int index) {
    switch (index) {
      case 0 : comment2 = """
큰 근육을 이용한 운동발달이 또래보다 느릴 수 있어요. 대근육운동은 아이의 신경계 및 근골격계의 발달과 밀접하게 연관되어 있어요.
아이들은 운동기능을 통해 세상을 탐색하며 신체,
인지, 정서를 발달시켜나가요.
자세한 발달 상태 파악을 위해 병원 진단 진단 및 상담이 필요합니다.
""";
      break;
      case 1 : comment2 = """
손의 작은 근육을 이용한 정밀한 조작과 협응능력의 발달이 또래보다 느릴 수 있어요. 소근육운동은 아이들이 세상을 탐색하고 지능을 발달시키는 일과 밀접하게 연관되어 있어요.
자세한 발달 상태 파악을 위해 병원 진단 진단 및 상담이 필요합니다.
      """;
      break;
      case 2 : comment2 = """
인지발달이 또래와 비슷하거나 다소 느릴 수 있어요. 인지발달은 아이가
경험한 세상을 이해하고 기억해서 문제해결에 활용하는 법을 배워나가는
과정이에요. 운동, 언어, 사회성발달과 밀접하게 연관되어 있으면서 향후
놀이와 학습의 기초가 됩니다.
      """;
      break;
      case 3 : comment2 = """
언어영역발달이 또래와 비슷하거나 다소 느릴 수
있어요. 언어는 타인과의 소통을 통해 사회적 관계를 형성해나가는 기초가 되어요. 아이는 언어발달을 통해 시간과 공간의 제약을 넘어 사고의 범위를
확장시켜 나가고 있어요.
      """;
      break;
      case 4 : comment2 = """
사회성이 또래보다 발달되어 있어요. 아이가 사회적 관계를 통해 가치관, 태도, 규범, 행동양상을 건강하게 형성해나가고, 이후 도덕심, 이타심, 올바른
성의식을 발전시켜나가기에 유리한
장점을 가지고 있어요.
      """;
      break;
      case 5 : comment2 = """
자조영역발달이 또래보다 높은 수준이예요. 자기조절능력과 자율성 및
주도성을 습득하기에 유리한 장점을 가지고 있어요. 자조능력의 발달을
위해서는 대근육운동, 소근육운동의 발달이 선행되어야 하고, 이는 훗날 사회성 형성의 든든한 기초가 됩니다.
      """;
      break;
    }
  }


  HomeGraphTallDto? dicHomeGraphTallInfo;
  HomeGraphWeightDto? dicHomeGraphWeightInfo;

  List<String> CATEGORYS = ["발달영역", "생활습관", "신체"];
  List<String> subCategory = ["대근육", "소근육", "인지", "언어", "사회성", "자조"];
  List<String> subCategoryImg = [
    "monitor_icon1.png",
    "monitor_icon2.png",
    "monitor_icon3.png",
    "monitor_icon4.png",
    "monitor_icon5.png",
    "monitor_icon6.png",
  ];
  List<int> testScore = [68, 72, 86, 86, 98, 100];

  @override
  void initState() {
    super.initState();
    getHomeGraphTall();
    getHomeGraphWeight();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  Color changeColor(int p) {
    if (p < 80) {
      return AppColor_Red;
    } else if (p < 90) {
      return AppColor_Oxygen;
    } else {
      return AppColor_Primary;
    }
  }

  String getDate(String allDate, int type) {
    String result = "";

    if (allDate == "") {
      return "";
    }
    var arr = allDate.split(",");
    if (arr.length > type) {
      result = arr[type - 1].substring(0, 16);
      result = result.replaceAll("-", ".");
    }

    return result;
  }

  //홈 그래프 신장 얻기
  Future<void> getHomeGraphTall() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeGraphTallResModel> info = httpService.homeGraphTall();
    info.then((HomeGraphTallResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeGraphTallInfo = value.data!;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //홈 그래프 체중 얻기
  Future<void> getHomeGraphWeight() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeGraphWeightResModel> info = httpService.homeGraphWeight();
    info.then((HomeGraphWeightResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeGraphWeightInfo = value.data!;
        // dicHomeGraphWeightInfo!.graph = List.from(dicHomeGraphWeightInfo!.graph!.reversed);
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  Widget _getTiles1(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          tabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: tabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
        child: Center(
          child: H14(
            text: CATEGORYS[index],
            weight: FW.bold,
            align: TextAlign.center,
            color: tabIndex == index
                ? Colors.white
                : AppColor_BlackText.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  // CATE: 신장 체중 선택
  Widget bodyTabSelector() {
    return Container(
        width: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: AppColor_Table_Border),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                subTabIndex2 = 0;
                setState(() {});
              },
              child: Container(
                  height: 25,
                  width: 65,
                  margin: const EdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        subTabIndex2 == 0
                            ? const BoxShadow(
                                color: AppColor_Table_Border,
                                blurRadius: 4.0, // soften the shadow
                                spreadRadius: 2.0, //extend the shadow
                                offset: Offset(
                                  3.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 5 Vertically
                                ))
                            : const BoxShadow(
                                color: AppColor_Table_Border,
                                blurRadius: 0.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  0.0, // Move to bottom 5 Vertically
                                ))
                      ],
                      color: subTabIndex2 == 0
                          ? AppColor_Primary
                          : AppColor_Table_Border),
                  child: Center(
                    child: H14(
                      text: "신장",
                      weight: FW.medium,
                      color: subTabIndex2 == 0
                          ? Colors.white
                          : AppColor_Table_DateTime,
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                subTabIndex2 = 1;
                setState(() {});
              },
              child: Container(
                  height: 25,
                  width: 65,
                  margin: const EdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        subTabIndex2 == 1
                            ? const BoxShadow(
                                color: AppColor_Table_Border,
                                blurRadius: 4.0, // soften the shadow
                                spreadRadius: 2.0, //extend the shadow
                                offset: Offset(
                                  3.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 5 Vertically
                                ))
                            : const BoxShadow(
                                color: AppColor_Table_Border,
                                blurRadius: 0.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  0.0, // Move to bottom 5 Vertically
                                ))
                      ],
                      color: subTabIndex2 == 1
                          ? AppColor_Primary
                          : AppColor_Table_Border),
                  child: Center(
                    child: H14(
                      text: "체중",
                      weight: FW.medium,
                      color: subTabIndex2 == 1
                          ? Colors.white
                          : AppColor_Table_DateTime,
                    ),
                  )),
            ),
          ],
        ));
  }

  Widget bodyTile() {
    if (subTabIndex2 == 0) {
      if (dicHomeGraphTallInfo == null ||
          dicHomeGraphTallInfo!.monitoring == null) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: AppColor_Light_Gray),
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
            margin: const EdgeInsets.only(top: 30.0),
            child: PrevMonitoring());
      } else {
        return Column(
          children: [
            dicHomeGraphTallInfo!.total_cnt! == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 28),
                      H18(
                        text: '신장 기록을 처음 완료했어요.😊\n한달 주기로 기록을 지속해주세요.',
                        weight: FW.regular,
                        maxLine: 2,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                    ],
                  )
                : Visibility(
                    visible: dicHomeGraphTallInfo!.heightPrevDiff! > 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 28),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H18(
                                text: LanguageService.trans('than_last_month'),
                                weight: FW.regular),
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: sprintf(
                                        LanguageService.trans('%.1fcm '), [
                                      (dicHomeGraphTallInfo!.heightPrevDiff)!
                                          .abs()
                                    ]),
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 18,
                                        height: 1.8)),
                                TextSpan(
                                    text:
                                        dicHomeGraphTallInfo!.heightPrevDiff! >=
                                                0.0
                                            ? '더 늘어났어요.'
                                            : '줄어들었어요.',
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 18,
                                        weight: FW.regular)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Image.asset('assets/ic_smile2.png',
                            width: 20, height: 20),
                      ],
                    ),
                  ),
            const SizedBox(height: 18),
            Container(
                // padding: const EdgeInsets.symmetric(horizontal: 30),
                child: HeightReport(data: dicHomeGraphTallInfo!, result: 1)),
          ],
        );
      }
    } else if (subTabIndex2 == 1) {
      if (dicHomeGraphWeightInfo == null ||
          dicHomeGraphWeightInfo!.monitoring == null) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: AppColor_Light_Gray),
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
            margin: const EdgeInsets.only(top: 30.0),
            child: PrevMonitoring());
      } else {
        return Column(
          children: [
            dicHomeGraphWeightInfo!.total_cnt! == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 28),
                      H18(
                        text: '체중 기록을 처음 완료했어요.😊\n일일 주기로 기록을 지속해주세요.',
                        weight: FW.regular,
                        maxLine: 2,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                    ],
                  )
                : Visibility(
                    visible: dicHomeGraphTallInfo!.heightPrevDiff! > 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 28),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H18(
                                text: LanguageService.trans('than_last_month'),
                                weight: FW.regular),
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: sprintf(
                                        LanguageService.trans('%.1fkg '), [
                                      (dicHomeGraphWeightInfo!.weightPrevDiff)!
                                          .abs()
                                    ]),
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 18,
                                        height: 1.8)),
                                TextSpan(
                                    text: dicHomeGraphWeightInfo!
                                                .weightPrevDiff! >=
                                            0.0
                                        ? '더 늘어났어요.'
                                        : '줄어들었어요.',
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 18,
                                        weight: FW.regular)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Image.asset('assets/ic_smile2.png',
                            width: 20, height: 20),
                      ],
                    ),
                  ),
            const SizedBox(height: 18),
            Container(
                // padding: const EdgeInsets.symmetric(horizontal: 30),
                child: WeightReport(data: dicHomeGraphWeightInfo!, result: 1)),
          ],
        );
      } //생활습관
    }
    return Container();
  }

  Widget growTile(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          qkfekf(index);
          qkfekf2(index);
          subTabIndex = index;
        });
      },
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 90,
            margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            decoration: const BoxDecoration(
                color: AppColor_White,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor_Light_Gray,
                    blurRadius: 3.0, // soften the shadow
                    spreadRadius: 4.0, //extend the shadow
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                H16(text: subCategory[index]),
                const SizedBox(height: 5),
                Container(
                  width: 50,
                  height: 20,
                  color: changeColor(testScore[index]),
                  child: Center(
                    child: Text(
                      testScore[index].toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/" + subCategoryImg[index],
              width: 80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (tabIndex == 0) {
      return Column(
        children: [
          SizedBox(
            height: 360,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return growTile(index);
              },
              itemCount: subCategory.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0),
            ),
          ),
          // const SizedBox(height: 30),
          H20(
            text: "${subCategory[subTabIndex]} 발달 점수",
            align: TextAlign.start,
          ),
          RangeShow(
            isInspect: true,
            start: "",
            end: "",
            rate: testScore[subTabIndex].toDouble(),
            unit: "",
            color: changeColor(testScore[subTabIndex]),
            cur_value: testScore[subTabIndex].toDouble(),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 64,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: AppColor_Light_Gray),
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            // margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H16(text: comment1),
                SizedBox(height: 10,),
                Text(
                  comment2,
                  style: TextStyle(
                      color: AppColor_GrayText, fontSize: 16, height: 1.5),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          testScore[subTabIndex] < 80
              ? Center(
                  child: MainTextButton(
                    text: "카카오톡으로 상담하기",
                    style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                    width: 200,
                    height: 40,
                    radius: 20,
                    onPressed: () {
                      // Navigator.push(context, SlideRightTransRoute(builder: (context) => ,));
                    },
                  ),
                )
              : SolutionArea(),
        ],
      );
    } else if (tabIndex == 1) {
      return MonitoringTestResult();
    } else if (tabIndex == 2) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            bodyTabSelector(),
            bodyTile(),
          ],
        ),
      );
    }
    return const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SimpleHeader(
                title: "우아 발달 모니터링 리포트",
                onBackPressed: onBackPressed,
              ),
              Container(
                // width: MediaQuery.of(context).size.width - 64,
                padding: const EdgeInsets.only(left: 20, right: 20,top: 10),
                height: 50,
                child: GridView.builder(
                  // scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _getTiles1(index);
                  },
                  itemCount: CATEGORYS.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _body()),
                ),
              ),
            ],
          ),
        ));
  }
}
