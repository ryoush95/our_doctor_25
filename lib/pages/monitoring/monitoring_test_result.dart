import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/models/monitoring/life_result_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MonitoringLifeResult extends StatefulWidget {
  const MonitoringLifeResult({Key? key}) : super(key: key);

  @override
  State<MonitoringLifeResult> createState() => _MonitoringLifeResultState();
}

class _MonitoringLifeResultState extends BaseState<MonitoringLifeResult> {
  final HttpService httpService = HttpService();
  List<LifeCateDto> cateScroe = [];
  List<WrongAnswer> wrongList = [];
  int tabIndex = 0;
  String option = "1";
  List<String> CATEGORY = ["개인위생", "구강교육", "감각", "안전사고", "영양", "전자미디어", "정서", "대소변", "수면교육"];
  // List<int> cateint = [26,16,7,11,21,15,13,27,19];
  ScrollController sc = ScrollController();
  Color indiColor = AppColor_Primary;
  String inidiImage = "assets/icon_good.png";
  String indiText = "성장과 발달에 적합한 생활습관을 잘 지키고 있는 편이에요. 놓치고 있었던 부분을 확인하여 더욱 좋은 생활 습관을 정립해 보세요.";


  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLifeResult();
  }

  Future<void> getLifeResult() async {
    Future<LifeResultModel> info = httpService.getMonitoringLifeResult();
    info.then((value) async {
      if (value.result == 0) {
        CATEGORY = value.data!.keys.toList();
        cateScroe = value.data!.values.toList();
        wrongList = cateScroe[0].wrongAnswers!.values.toList();
        setStatus();
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Widget categoryTile(int index) {
    return InkWell(
      onTap: () {
        sc.jumpTo(0.0);
        wrongList = cateScroe[index].wrongAnswers!.values.toList();
        setState(() {
          tabIndex = index;
          setStatus();
        });
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: tabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
          child: SizedBox(
            child: Stack(
              children: [
                Center(
                  child: H14(
                    text: CATEGORY[index],
                    weight: FW.bold,
                    align: TextAlign.center,
                    maxLine: 1,
                    color: tabIndex == index
                        ? AppColor_White
                        : AppColor_BlackText.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget testTile2(index) {
    var screenSize = MediaQuery.of(context).size;
    double h = 25;
    double w = 80;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        SizedBox(
          width: screenSize.width,
          child: H16(
            text: "Q${index +1}",
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
            text: wrongList[index].question!,
            maxLine: 5,
            align: TextAlign.left,
            height: 1.5,
            weight: FW.medium,
          ),
        ),
        const SizedBox(height: 35),
        // Text(wrongList[index].imageUrl!),
        wrongList[index].imageUrl! != ""
            ? CachedNetworkImage(
                imageUrl: wrongList[index].imageUrl!,
                // height: 100,
                errorWidget: (context, url, error) => const SizedBox(height: 35),
              )
            : const SizedBox(height: 35),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Opacity(
                        opacity: option == "1" ? 0.5 : 1,
                        child: Image.asset(
                          wrongList[index].answer! == 1
                              ? "assets/choose_on.png"
                              : "assets/choose_test_check.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      wrongList[index].answer! == 1
                          ? Opacity(
                        opacity: 0.5,
                        child: Container(
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
                      ),
                          )
                          : SizedBox(
                          height: h,
                          width: w,
                          child: Center(
                            child: H16(
                                text: "예 ",
                                weight: FW.medium,
                                color: AppColor_Red),
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Opacity(
                        opacity: wrongList[index].answer! == 0 ? 0.5 : 1,
                        child: Image.asset(
                          wrongList[index].answer! == 0
                              ? "assets/choose_on.png"
                              : "assets/choose_test_check.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      wrongList[index].answer! == 0
                          ? Opacity(
                        opacity: 0.5,
                        child: Container(
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
                      ),
                          )
                          : SizedBox(
                          height: h,
                          width: w,
                          child: Center(
                            child: H16(
                                text: "아니오",
                                weight: FW.medium,
                                color: AppColor_Red),
                          ))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 55, height: 50,),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.all(20),
          color: AppColor_Light_Gray,
          child: Row(
            children: [
              Image.asset("assets/monitoring_doctor_icon.png", width: 70,),
              const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width - 180,
                child: H14(text: wrongList[index].description!,
                  maxLine: 5,
                  height: 1.5,
                  align: TextAlign.start,
                  color: AppColor_Red,
                  weight: FW.regular,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  void setStatus() {
    String s = cateScroe[tabIndex].status!;
    indiText = cateScroe[tabIndex].feedbackDescription!;
    if (s == "B") {
      inidiImage = "assets/icon_good.png";
      indiColor = AppColor_Primary;
    } else if (s == "R") {
      inidiImage = "assets/icon_bad.png";
      indiColor = AppColor_Red;
    } else {
      inidiImage = "assets/icon_normal.png";
      indiColor = AppColor_Oxygen;
    }
  }

  void getWrongList() {

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: sc,
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cateScroe.isNotEmpty ? Center(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  percent: cateScroe[tabIndex].score!/cateScroe[tabIndex].totalScore!,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(inidiImage,
                        height: 60,
                        width: 70,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cateScroe[tabIndex].score!.toString(),style: TextStyle(
                              color: indiColor,
                            ),),
                            Text("/${cateScroe[tabIndex].totalScore!}")
                          ],
                        ),
                      )
                    ],
                  ),
                  progressColor: indiColor,
                  backgroundColor: AppColor_Light_Gray,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  lineWidth: 8.0,
                ),
              ) : const SizedBox(),
              const SizedBox(height: 30),
              // RichText(
              //   text: TextSpan(
              //       children: [
              //     TextSpan(
              //       text: "성장, 발달에 ",
              //       style:
              //           AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.bold),
              //     ),
              //     TextSpan(
              //       text: "좋은 생활습관",
              //       style:
              //           AppTextStyle.PD(AppColor_Primary, 16, weight: FW.bold),
              //     ),
              //     TextSpan(
              //       text: "이에요",
              //       style:
              //           AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.bold),
              //     ),
              //   ]),
              // ),
              const SizedBox(height: 10),
              SizedBox(
                // height: 90,
                child: H14(
                  text: indiText,
                  maxLine: 4,
                  height: 1.5,
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: GridView.builder(
            // scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return categoryTile(index);
            },
            itemCount: CATEGORY.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
          ),
        ),
        Container(
          height: wrongList.length * 400,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wrongList.length,
            itemBuilder: (context, index) => testTile2(index),
          ),
        ),
      ]),
    );
  }
}
