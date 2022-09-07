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
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                H18(text: "1개 ", weight: FW.bold),
                H18(text: "항목에 대한", weight: FW.regular),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                H16(text: (dicInfo != null && dicInfo!.diagnose != null) ? "맞춤검사를 완료했습니다" : "맞춤검사가 가능합니다", weight: FW.regular),
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
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                // Navigator.push(context, SlideRightTransRoute(builder: (context) => const CustomInspectionMainPage()));
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
                            text: "영유아 검진",
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
                        )),
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
}
