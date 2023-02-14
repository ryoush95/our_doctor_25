import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/monitoring/heath_result_model.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitor_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
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
import 'package:ourdoctor/pages/monitoring/monitoring_life_result.dart';
import 'package:ourdoctor/pages/monitoring/solution_area.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String comment1 = "";
  String comment2 = "";
  List<String> healthTitle = [];
  List<DevelopmentScoreDto> healthList = [];
  List<RecommendList> solList = [];

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

  ScrollController sc = ScrollController();

  @override
  void initState() {
    super.initState();
    getHealthResult();
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

  Color changeColor(String p) {
    if (p == "R") {
      return AppColor_Red;
    } else if (p == "G") {
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

  Future<void> getHealthResult() async {
    Future<MonitorHealthResultModel> info =
        httpService.getMonitoringHealthResult();
    info.then((value) async {
      if (value.result == 0) {
        value.data!.forEach((key, value) {
          healthTitle.add(key);
          healthList.add(value);
        });
      setState(() {
          solList = healthList[0].solutionList.values.toList();
          comment1 = healthList[0].feedbackTitle!;
          comment2 = healthList[0].feedbackDescription!;
          isLoading = false;
        });
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  //홈 그래프 신장 얻기
  Future<void> getHomeGraphTall() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeGraphTallResModel> info = httpService.monitorTallv2();
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

    Future<HomeGraphWeightResModel> info = httpService.monitorWeightv2();
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
        sc.jumpTo(0.0);
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
                : AppColor_GridText,
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                subTabIndex2 = 0;
                solList = dicHomeGraphTallInfo!.solutionList!.values.toList();
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
                solList = dicHomeGraphWeightInfo!.solutionList!.values.toList();
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
            const SizedBox(height: 10),
            dicHomeGraphTallInfo!.total_cnt! == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 28),
                      H18(
                        text: '신장 기록을 처음 완료했어요.😊',
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
                                text: "저번 기록보다",
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
            SolutionContainer(),
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
                        text: '체중 기록을 처음 완료했어요.',
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
                                text: "저번 기록보다",
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
            SolutionContainer(),
          ],
        );
      } //생활습관
    }
    return Container();
  }

  Widget healthTile(int index) {
    return InkWell(
      onTap: () {
        sc.jumpTo(0.0);
        setState(() {
          comment1 = healthList[index].feedbackTitle!;
          comment2 = healthList[index].feedbackDescription!;
          solList = healthList[index].solutionList.values.toList();
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
                H16(text: healthTitle[index]),
                const SizedBox(height: 5),
                Container(
                  width: 50,
                  height: 20,
                  color: changeColor(healthList[index].status!),
                  child: Center(
                    child: Text(
                      healthList[index].score.toString(),
                      style: const TextStyle(
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
      return healthList.isNotEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 360,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return healthTile(index);
                    },
                    itemCount: healthTitle.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0),
                  ),
                ),
                // const SizedBox(height: 30),
                H20(
                  text: "${healthTitle[subTabIndex]} 발달 점수",
                  align: TextAlign.start,
                ),
                RangeShow(
                  isInspect: true,
                  start: "",
                  end: "",
                  rate: healthList[subTabIndex].score!.toDouble(),
                  unit: "",
                  color: changeColor(healthList[subTabIndex].status!),
                  cur_value: healthList[subTabIndex].score!.toDouble(),
                ),

                Container(
                  width: MediaQuery.of(context).size.width - 64,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: AppColor_Light_Gray),
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 20),
                  // margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H16(text: comment1),
                      const SizedBox(
                        height: 10,
                      ),
                      H14(
                        text: comment2,
                        maxLine: 10,
                        height: 1.5,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                healthList[subTabIndex].status == "R"
                    ? Center(
                        child: MainTextButton(
                          text: "카카오톡으로 상담하기",
                          style: AppTextStyle.PD(Colors.white, 16,
                              weight: FW.medium),
                          width: 200,
                          height: 40,
                          radius: 20,
                          onPressed: () {
                            launch("http://pf.kakao.com/_JAjBb");
                          },
                        ),
                      )
                    : SolutionContainer(),
              ],
            )
          : const SizedBox();
    } else if (tabIndex == 1) {
      return MonitoringLifeResult(controller: sc);
    } else if (tabIndex == 2) {
      solList = subTabIndex2 == 0 ? dicHomeGraphTallInfo!.solutionList!.values.toList() : dicHomeGraphWeightInfo!.solutionList!.values.toList();
      setState(() {});
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

  Widget SolutionContainer() {
    return Container(
      height: 306,
      width: MediaQuery.of(context).size.width - 50,
      // margin: const EdgeInsets.all(20),
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
        children: [
          const SizedBox(height: 20),
          H16(text: "솔루션 추천"),
          // SchoolArea(curCategory: 2),//교육
          Expanded(
            child: ListView.builder(
              itemCount: solList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (solList[index].type! == "community") {
                      Navigator.push(
                          context,
                          SlideRightTransRoute(
                            builder: (context) => CommunityDetailPage(
                                uid: solList[index].id),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          SlideRightTransRoute(
                            builder: (context) =>
                                ProductDetail(pid: solList[index].id!),
                          ));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: CachedNetworkImage(
                            imageUrl: solList[index].imageUrl!,
                            width: 84,
                            height: 84,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 150,
                          child: H18(
                            text: solList[index].title!,
                            weight: FW.regular,
                            maxLine: 2,
                            align: TextAlign.center,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                height: 50,
                child: GridView.builder(
                  // scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _getTiles1(index);
                  },
                  itemCount: CATEGORYS.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: SingleChildScrollView(
                      controller: sc,
                      physics: const BouncingScrollPhysics(), child: Column(
                        children: [
                          _body(),
                          const SizedBox(height: 40)
                        ],
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}