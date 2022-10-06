import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_brain_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/custom_inspection.dart';
import 'package:ourdoctor/pages/my/custom_inspection2.dart';
import 'package:ourdoctor/provider/child_quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class InspectionReport extends StatefulWidget {
  InspectionReport({Key? key, required this.data, required this.data1, required this.data2, this.result = 0}) : super(key: key);

  final List<ReportDto> data;
  final List<ReportDto> data1;
  final List<ReportDto> data2;
  final int result;

  @override
  InspectionReportState createState() => InspectionReportState();
}

class InspectionReportState extends BaseState<InspectionReport> {
  DateTime now = DateTime.now();
  final HttpService httpService = HttpService();
  HomeBraninDto? dicInfo;
  final tooltip = GlobalKey();
  String childQuiz = "";
  int testNum = 0;
  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"), textStyle: AppTextStyle.PD(AppColor_BlackText, 12), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(10.0), onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
  }

  @override
  void initState() {
    super.initState();

    getHomeBrainInfo();

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getHomeBrainInfo();
      }
    });
  }

  // Network functions
  //////////////////////////////////
  //홈 두뇌  데이터 정보 얻기
  Future<void> getHomeBrainInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeBrainResModel> info = httpService.homeBraninInfo("mchat");
    info.then((HomeBrainResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicInfo = value.data!;
        setState(() {
          if(dicInfo!.diagnose == null && (dicInfo!.quizCode != childQuiz && getChildQuiz())){
            testNum = 2;
          } else if(dicInfo!.diagnose == null || (dicInfo!.quizCode != childQuiz && getChildQuiz())){
            testNum = 1;
          } else {
            testNum = 0;
          }
        });
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
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Visibility(
              visible: testNum != 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  H18(text: "$testNum개 ", weight: FW.bold),
                  H18(text: "항목에 대한", weight: FW.regular),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                H16(text: testNum == 0 ? "맞춤검사를 완료했습니다." : "맞춤검사가 가능합니다.", weight: FW.regular),
                const SizedBox(width: 5),
                Image.asset(
                  (dicInfo != null && dicInfo!.diagnose != null) ? 'assets/ic_status1.png' : 'assets/ic_smile5.png',
                  width: 20,
                  height: 20,
                )
              ],
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.push(context, SlideRightTransRoute(builder: (context) => const CustomInspectionMainPage()));
              },
              child: Visibility(
                visible: dicInfo == null || dicInfo!.diagnose == null,
                child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor_Primary), borderRadius: BorderRadius.circular(16), color: Colors.white),
                    child: Stack(
                      children: [
                        Center(
                          child: H18(
                            text: "M-CHAT 자폐증 선별 검사",
                            weight: FW.bold,
                            align: TextAlign.start,
                            color: AppColor_Primary,
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 15,
                          child: Image.asset(
                            'assets/add_circle_black_24dp.png',
                            width: 25,
                            height: 25,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            const SizedBox(height: 10,),
            Visibility(
              visible: dicInfo != null && dicInfo!.diagnose != null,
              child: Container(
                width: MediaQuery.of(context).size.width - 64,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor_Green), borderRadius: BorderRadius.circular(16), color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Center(
                              child: H18(
                                text: "M-CHAT 자폐증 선별 검사",
                                weight: FW.bold,
                                align: TextAlign.start,
                                color: AppColor_Green,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 0,
                              child: Image.asset(
                                'assets/check_circle_black_24dp.png',
                                width: 24,
                                height: 24,
                              ),
                            )
                          ],
                        ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 85,
                      child: H16(
                        text: (dicInfo == null || dicInfo!.diagnose == null) ? "" : dicInfo!.diagnose!.comment!,
                        weight: FW.regular,
                        align: TextAlign.center,
                        color: AppColor_BlackText.withOpacity(0.6),
                        maxLine: 10,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            //영유아 검진 시작
            Visibility(
              visible: getChildQuiz(),
              child:
              dicInfo?.quizCode == childQuiz
              ?Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor_Green), borderRadius: BorderRadius.circular(16), color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Center(
                            child: H18(
                              text: "$childQuiz차 영유아 검진",
                              weight: FW.bold,
                              align: TextAlign.start,
                              color: AppColor_Green,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 0,
                            child: Image.asset(
                              'assets/check_circle_black_24dp.png',
                              width: 24,
                              height: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
              :InkWell(
                onTap: () {
                  Navigator.push(context, SlideRightTransRoute(
                      builder: (context) => ChangeNotifierProvider(create: (_) => ChildQuizProvider(),
                        child:CustomInspectionMainPage2(),)),
                  );
                },
                child: Visibility(
                  visible: getChildQuiz(),
                  child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor_Primary), borderRadius: BorderRadius.circular(16), color: Colors.white),
                      child: Stack(
                        children: [
                          Center(
                            child: H18(
                              text: "$childQuiz차 영유아 검진",
                              weight: FW.bold,
                              align: TextAlign.start,
                              color: AppColor_Primary,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 15,
                            child: Image.asset(
                              'assets/add_circle_black_24dp.png',
                              width: 25,
                              height: 25,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
            Visibility(
              visible: dicInfo != null && dicInfo!.diagnose != null && dicInfo!.classExist! && dicInfo!.storeExist!,
              child: Container(
                height: 52,
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  children: [
                    Visibility(
                      visible: dicInfo != null && dicInfo!.diagnose != null && dicInfo!.classExist!,
                      child: InkWell(
                        onTap: () {
                          eventBus.fire(MoreHomeCareEvent(type: 1));
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 70) / 2,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor_Green.withOpacity(0.1)),
                          child: Center(
                            child: H16(
                              text: "맞춤 클래스",
                              weight: FW.bold,
                              align: TextAlign.center,
                              color: AppColor_Green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: dicInfo != null && dicInfo!.diagnose != null && dicInfo!.storeExist!,
                      child: InkWell(
                        onTap: () {
                          eventBus.fire(MoreHomeCareEvent(type: 0));
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 70) / 2,
                          height: MediaQuery.of(context).size.height,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor_Primary.withOpacity(0.1)),
                          child: Center(
                            child: H16(
                              text: "스토어",
                              weight: FW.bold,
                              align: TextAlign.center,
                              color: AppColor_Primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.result == 1 ? const SizedBox(height: 40) : const SizedBox(),
            // widget.result == 1 ? ResultArea(type: 7, result: 2) : const SizedBox(),
          ],
        ));
  }

  int getWeight() {
    return 25;

    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    // String date = dateFormat.format(now);
    // int hour = now.hour;
    // for (int i = 0; i < widget.data.length; i++) {
    //   if (hour >= 12) {
    //     if (widget.data.elementAt(i).pm_time.contains(date)) {
    //       String data = widget.data.elementAt(i).afternoon_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   } else {
    //     if (widget.data.elementAt(i).am_time.contains(date)) {
    //       String data = widget.data.elementAt(i).morning_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   }
    // }
    // return "미측정";
  }

  String getCurTime() {
    int hour = now.hour;
    if (hour < 12) {
      return "오늘 오전";
    } else {
      return "오늘 오후";
    }
  }

  bool getChildQuiz() {
    DateTime dt = DateTime.parse(gSelChildInfo!.birth!);
    int birthCode = DateTime.now().difference(dt).inDays ~/ 30;
    if (birthCode < 1) {
      childQuiz = '1';
      return true;
    } else if (birthCode >= 3 && birthCode <= 6) {
      childQuiz = '2';
      return true;
    } else if (birthCode >= 8 && birthCode <= 12) {
      childQuiz = '3';
      return true;
    } else if (birthCode >= 17 && birthCode <=24) {
      childQuiz = '4';
      return true;
    } else if (birthCode >= 29 && birthCode <= 36) {
      childQuiz = '5';
      return true;
    } else if (birthCode >= 41 && birthCode <= 48) {
      childQuiz = '6';
      return true;
    } else if (birthCode >= 53 && birthCode <= 60) {
      childQuiz = '7';
      return true;
    } else if (birthCode >= 65 && birthCode <= 71) {
      childQuiz = '8';
      return true;
    }
    return false;
  }
}
