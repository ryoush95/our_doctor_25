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
import 'package:ourdoctor/pages/home/prev_monitoring.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class LanguageReport extends StatefulWidget {
  LanguageReport({Key? key, required this.data, required this.data1, required this.data2, this.result = 0, this.type = 0}) : super(key: key);

  final List<ReportDto> data;
  final List<ReportDto> data1;
  final List<ReportDto> data2;
  final int result;
  final int type;

  @override
  LanguageReportState createState() => LanguageReportState();
}

class LanguageReportState extends BaseState<LanguageReport> {
  DateTime now = DateTime.now();
  final HttpService httpService = HttpService();
  HomeBraninDto? dicInfo;

  int pageType = 0;
  final tooltip = GlobalKey();
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

    pageType = widget.type;
    getHomeBrainInfo();

    eventBus.on<HomeBrainTabEvent>().listen((event) {
      if (mounted) {
        pageType = event.type;
        getHomeBrainInfo();
      }
    });
    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getHomeBrainInfo();
      }
    });
  }

  String getTitle() {
    String result = "";
    if (dicInfo == null || dicInfo!.diagnose == null) {
      return "";
    }

    if (pageType == 0) {
      result = "언어력이 " + dicInfo!.diagnose!.result! + "해요";
      if (dicInfo!.diagnose!.result == "주의") {
        result = "언어력이 " + dicInfo!.diagnose!.result! + "가 필요해요";
      }
    } else if (pageType == 1) {
      result = "운동신경이 " + dicInfo!.diagnose!.result! + "해요";
      if (dicInfo!.diagnose!.result == "주의") {
        result = "운동신경을 " + dicInfo!.diagnose!.result! + " 해주세요";
      }
    } else if (pageType == 2) {
      result = "사회성이 " + dicInfo!.diagnose!.result! + "해요";
      if (dicInfo!.diagnose!.result == "주의") {
        result = "사회성에 " + dicInfo!.diagnose!.result! + "가 필요해요";
      }
    }

    return result;
  }

  String getTitleImg() {
    String result = "";
    if (dicInfo == null || dicInfo!.diagnose == null) {
      return 'assets/ic_status1.png';
    }

    if (dicInfo!.diagnose!.result! == "주의") {
      return 'assets/ic_status2.png';
    } else if (dicInfo!.diagnose!.result! == "부족") {
      return 'assets/ic_status3.png';
    } else {
      return 'assets/ic_status1.png';
    }
  }

  // Network functions
  //////////////////////////////////
  //홈 두뇌  데이터 정보 얻기
  Future<void> getHomeBrainInfo() async {
    String category = "";
    if (pageType == 0) {
      category = "language";
    } else if (pageType == 1) {
      category = "workout";
    } else if (pageType == 2) {
      category = "social";
    }
    setState(() {
      isLoading = true;
    });

    Future<HomeBrainResModel> info = httpService.homeBraninInfo(category);
    info.then((HomeBrainResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicInfo = value.data!;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      // setState(() {
      //   isLoading = false;
      // });
      // showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          H18(text: getTitle()),
                          const SizedBox(width: 5),
                          Visibility(
                            visible: dicInfo != null && dicInfo!.diagnose != null,
                            child: Image.asset(getTitleImg(), width: 24),
                          ),
                        ],
                      ),
                      Visibility(
                          visible: dicInfo != null && dicInfo!.diagnose != null,
                          child: const SizedBox(
                            height: 20,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dicInfo == null || dicInfo!.diagnose == null ? PrevMonitoring() : const SizedBox(),
                          dicInfo != null && dicInfo!.diagnose != null && dicInfo!.diagnose!.color! == "R"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/icon4.png', width: 60),
                                    const SizedBox(width: 10),
                                    Image.asset('assets/icon2.png', width: 60),
                                    const SizedBox(width: 10),
                                    Image.asset('assets/icon3.png', width: 60),
                                  ],
                                )
                              : const SizedBox(),
                          dicInfo != null && dicInfo!.diagnose != null && dicInfo!.diagnose!.color! == "Y"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/icon1.png', width: 60),
                                    const SizedBox(width: 10),
                                    Image.asset('assets/icon5.png', width: 60),
                                    const SizedBox(width: 10),
                                    Image.asset('assets/icon3.png', width: 60),
                                  ],
                                )
                              : const SizedBox(),
                          dicInfo != null && dicInfo!.diagnose != null && dicInfo!.diagnose!.color! == "B"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/icon1.png', width: 60),
                                    const SizedBox(width: 10),
                                    Image.asset('assets/icon2.png', width: 60),
                                    const SizedBox(width: 10),
                                    Image.asset('assets/icon6.png', width: 60),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Visibility(
                          visible: dicInfo != null && dicInfo!.diagnose != null,
                          child: const SizedBox(
                            height: 20,
                          )),
                      H16(
                        text: (dicInfo == null || dicInfo!.diagnose == null) ? "" : dicInfo!.diagnose!.comment!,
                        weight: FW.regular,
                        height: 1.6,
                        color: AppColor_Result_Text,
                        maxLine: 6,
                        align: TextAlign.justify,
                      )
                    ],
                  ),
                )),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                H16(text: LanguageService.trans('than_last_month'), weight: FW.regular),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [H16(text: '0.3sae ', weight: FW.bold), H16(text: LanguageService.trans('i_grew_more'), weight: FW.regular), const SizedBox(width: 5), Image.asset('assets/ic_icon2.png', width: 20)],
            ),
            const SizedBox(height: 10),
            Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                padding: const EdgeInsets.all(30),
                child: Stack(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [H18(text: "language", weight: FW.regular), const SizedBox(width: 5), H18(text: "4.9sae")],
                  ),
                  Positioned(
                    top: 40,
                    child: Container(
                        height: 240,
                        width: screenSize.width - 120,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            const SizedBox(width: 80),
                            Container(
                              decoration: BoxDecoration(color: AppColor_Light_Gray),
                              height: 200,
                              width: 2,
                            ),
                            SizedBox(width: (screenSize.width - 260) / 3),
                            Container(
                              decoration: BoxDecoration(color: AppColor_Light_Gray),
                              height: 200,
                              width: 2,
                            ),
                            SizedBox(width: (screenSize.width - 260) / 3),
                            Container(
                              decoration: BoxDecoration(color: AppColor_Light_Gray),
                              height: 200,
                              width: 2,
                            ),
                            SizedBox(width: (screenSize.width - 260) / 3),
                            Container(
                              decoration: BoxDecoration(color: AppColor_Light_Gray),
                              height: 200,
                              width: 2,
                            )
                          ],
                        )),
                  ),
                  Positioned(
                      top: 90,
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child: Center(
                                  child: H14(
                                text: LanguageService.trans("Synthesis"),
                                weight: FW.regular,
                              ))),
                          Stack(
                            children: [
                              Container(
                                width: (screenSize.width - 280),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor_Light_Gray,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                width: 110,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor_a8daff,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                      top: 150,
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child: Center(
                                  child: H14(
                                text: LanguageService.trans("understanding"),
                                weight: FW.regular,
                              ))),
                          Stack(
                            children: [
                              Container(
                                width: (screenSize.width - 280),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor_Light_Gray,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor_Height,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                      top: 210,
                      child: Row(
                        children: [
                          Container(
                              width: 110,
                              child: Center(
                                  child: H14(
                                text: LanguageService.trans("expression"),
                                weight: FW.regular,
                              ))),
                          Stack(
                            children: [
                              Container(
                                width: (screenSize.width - 280),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor_Light_Gray,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor_Oxygen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                      top: 40,
                      left: 200,
                      child: DottedBorder(
                          borderType: BorderType.Rect,
                          color: Colors.black,
                          strokeWidth: 1,
                          child: Container(
                            height: 260,
                            width: 0,
                            decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                          )))
                ])),
             */
            // const SizedBox(height: 20),
            // RangeShow(start: "2", end: "6", rate: 50, unit: "세", cur_value: 4),
            // const SizedBox(height: 40),
            widget.result == 1 ? const SizedBox(height: 40) : const SizedBox(),
            // widget.result == 1 ? ResultArea(type: 4, result: 2) : const SizedBox(),
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
}
