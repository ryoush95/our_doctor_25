import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/monitor_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_floating_button.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/circular_progress.dart';
import 'package:ourdoctor/pages/home/community_area.dart';
import 'package:ourdoctor/pages/home/community_area_monitor.dart';
import 'package:ourdoctor/pages/home/developmental_class_area.dart';
import 'package:ourdoctor/pages/home/growth_store_area.dart';
import 'package:ourdoctor/pages/home/info_area.dart';
import 'package:ourdoctor/pages/home/report_area.dart';
import 'package:ourdoctor/pages/home/top_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class MonitoringFragment extends StatefulWidget {
  MonitoringFragment({Key? key, this.type = 0, this.pageType = 0}) : super(key: key);
  int? type;
  int? pageType;

  @override
  MonitoringFragmentState createState() => MonitoringFragmentState();
}

class MonitoringFragmentState extends BaseState<MonitoringFragment> {
  // List<MonitoringDto> monitoringList = [];
  final ScrollController _scrController = ScrollController();
  ScrollController scrollController = ScrollController();
  static const platform = MethodChannel('doctor.flutter.dev');
  final HttpService httpService = HttpService();
  bool isLast = false;
  int page = 0;
  int curCategory = 0;
  int curCategory1 = 0;
  List<MonitorListDto>? arrMonitorList = [];

  final tooltip = GlobalKey();
  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"), textStyle: AppTextStyle.PD(AppColor_BlackText, 12), height: 87, width: 200, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10), borderRadius: BorderRadius.circular(10.0), onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
  }

  void onChooseCategory(int index) {
    setState(() {
      curCategory = index;
      curCategory1 = index;
    });
  }

  @override
  void initState() {
    super.initState();
    curCategory = widget.type!;
    curCategory1 = widget.type!;
    scrollController = ScrollController()..addListener(loadMore);
    getMonitorList();

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        refresh();
      }
    });

    eventBus.on<InfoTabEvent>().listen((event) async {
      if (mounted) {
        curCategory = event.type;
        setState(() {});
        moveScroll();
      }
    });
    setState(() {});

    if (widget.pageType == 2) {
      moveScroll();
    }
  }

  void moveScroll() {
    Future.delayed(const Duration(milliseconds: 150), () {
      _scrController.jumpTo(750);
    });
  }

  // void loadMonitorList() {
  //   monitoringList.clear();
  //   setState(() {
  //     for (int i = 0; i < arrMonitorList!.length; i++) {
  //       MonitorListDto item = arrMonitorList!.elementAt(i);
  //       DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  //       DateTime date = dateFormat.parse(item.regtime!);
  //       bool bAm = date.hour < 12;
  //
  //       MonitoringDto monitorDto = MonitoringDto(
  //         uid: item.uid!,
  //         dateTime: item.regtime!,
  //         temperature: RecordItem(
  //           type: 0,
  //           amDateTime: bAm ? getDate(item.stepTimes!, 1) : "",
  //           amValue: bAm ? (item.temperature! == "" ? LanguageService.trans('unmeasured') : (item.temperature!)) : "",
  //           amImage: "",
  //           amResult: bAm ? getTemperatureStatus(item.temperature!) : "",
  //           pmDateTime: !bAm ? getDate(item.stepTimes!, 1) : "",
  //           pmValue: !bAm ? (item.temperature! == "" ? LanguageService.trans('unmeasured') : (item.temperature!)) : "",
  //           pmImage: "",
  //           pmResult: !bAm ? getTemperatureStatus(item.temperature!) : "",
  //         ),
  //         oxygen: RecordItem(
  //           type: 1,
  //           amDateTime: bAm ? getDate(item.stepTimes!, 2) : "",
  //           amValue: bAm ? (item.oxygen! == "" ? LanguageService.trans('unmeasured') : (item.oxygen! == "-1" ? "측정하지 않음" : item.oxygen!)) : "",
  //           amImage: "",
  //           amResult: bAm ? getOxygenStatus(item.oxygen!) : "",
  //           pmDateTime: !bAm ? getDate(item.stepTimes!, 2) : "",
  //           pmValue: !bAm ? (item.oxygen! == "" ? LanguageService.trans('unmeasured') : (item.oxygen! == "-1" ? "측정하지 않음" : item.oxygen!)) : "",
  //           pmImage: "",
  //           pmResult: !bAm ? getOxygenStatus(item.oxygen!) : "",
  //         ),
  //         breath: RecordItem(
  //           type: 4,
  //           amDateTime: bAm ? getDate(item.stepTimes!, 3) : "",
  //           amValue: bAm ? (item.heartCnt! == "" ? LanguageService.trans('unmeasured') : (item.heartCnt! == "-1" ? "측정하지 않음" : ("분당 " + item.heartCnt! + "회"))) : "",
  //           amImage: "",
  //           amResult: bAm ? getBreathStatus(item.heartCnt!) : "",
  //           pmDateTime: !bAm ? getDate(item.stepTimes!, 3) : "",
  //           pmValue: !bAm ? (item.heartCnt! == "" ? LanguageService.trans('unmeasured') : (item.heartCnt! == "-1" ? "측정하지 않음" : ("분당 " + item.heartCnt! + "회"))) : "",
  //           pmImage: "",
  //           pmResult: !bAm ? getBreathStatus(item.heartCnt!) : "",
  //         ),
  //         symptoms: RecordItem(
  //           type: 2,
  //           amDateTime: bAm ? getDate(item.stepTimes!, 4) : "",
  //           amValue: bAm ? (getSymptomsContent(item.symptom!) == "" ? LanguageService.trans('unmeasured') : getSymptomsContent(item.symptom!)) : "",
  //           amImage: "",
  //           amResult: bAm ? getSymptomsStatus(item.symptom!) : "",
  //           pmDateTime: !bAm ? getDate(item.stepTimes!, 4) : "",
  //           pmValue: !bAm ? (getSymptomsContent(item.symptom!) == "" ? LanguageService.trans('unmeasured') : getSymptomsContent(item.symptom!)) : "",
  //           pmImage: "",
  //           pmResult: !bAm ? getSymptomsStatus(item.symptom!) : "",
  //         ),
  //         medication: RecordItem(
  //             type: 3,
  //             amDateTime: bAm ? getDate(item.stepTimes!, 5) : "",
  //             amValue: bAm ? (item.pillUrl! == "" ? LanguageService.trans('unmeasured') : (item.pillUrl! == "-1" ? LanguageService.trans('no_medication') : LanguageService.trans('exist_taking_medication'))) : "",
  //             amImage: bAm ? (item.pillUrl! == "-1" ? "" : item.pillUrl!) : "",
  //             amResult: bAm ? getMedicationStatus(item.pillUrl!) : "",
  //             pmDateTime: !bAm ? getDate(item.stepTimes!, 5) : "",
  //             pmValue: !bAm ? (item.pillUrl! == "" ? LanguageService.trans('unmeasured') : (item.pillUrl! == "-1" ? LanguageService.trans('no_medication') : LanguageService.trans('exist_taking_medication'))) : "",
  //             pmImage: !bAm ? (item.pillUrl! == "-1" ? "" : item.pillUrl!) : "",
  //             pmResult: !bAm ? getMedicationStatus(item.pillUrl!) : ""),
  //         question: item.speciality!,
  //         answer: item.comment!,
  //         answerTime: item.commentTime!,
  //         doctorName: "우아 닥터",
  //         info: item,
  //       );
  //       monitoringList.add(monitorDto);
  //     }
  //   });
  // }

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

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    page = 0;
    getMonitorList();
  }

  void loadMore() {
    if (!isLoading) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        page = page + 1;
        getMonitorList();
      }
    }
  }

  Future<void> goChatting() async {
    try {
      final int result = await platform.invokeMethod('talk', {"uid": gUserInfo!.id, "name": gUserInfo!.name});
    } on PlatformException catch (e) {
      showToast("'${e.message}'.");
    }
  }

  // Network functions
  //////////////////////////////////
  //모니터 리스트 얻기
  Future<void> getMonitorList() async {
    setState(() {
      isLoading = true;
    });

    Future<MonitorListResModel> offerInfo = httpService.monitorList(page);
    offerInfo.then((MonitorListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (page == 0) {
          arrMonitorList!.clear();
        }
        arrMonitorList!.addAll(value.data!.list!);
        isLast = value.data!.isLast!;
        // loadMonitorList();
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
    return PageLayout(
        isLoading: isLoading,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                controller: _scrController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopArea(name: gSelChildInfo!.name!, type: 0),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        H18(text: "신체 발달 스코어" ),
                        H18(text: "두뇌 발달 스코어" ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularProgress(type: 1, subType: curCategory1 = 0),
                        CircularProgress(type: 2, subType: curCategory1 = 1),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              Container(
                                // width: 100,
                                child: H20(text: LanguageService.trans('발달 리포트'), maxLine: 2, align: TextAlign.start),
                              ),
                              // const SizedBox(width: 3),
                              // InkWell(
                              //   key: const Key('show_more_ink_well'),
                              //   child: Container(
                              //     key: tooltip,
                              //     child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                              //   ),
                              //   onTap: showMoreText,
                              // ),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(right: 30),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: AppColor_Table_Border),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    gBodyTab = true;
                                    eventBus.fire(SelectBodyBrainEvent());
                                    eventBus.fire(SubTabEvent(type: 0));
                                    onChooseCategory(0);
                                  },
                                  child: Container(
                                      height: 25,
                                      width: 65,
                                      margin: const EdgeInsets.only(left: 0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(13),
                                          boxShadow: [
                                            curCategory == 0
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
                                          color: curCategory == 0 ? AppColor_Primary : AppColor_Table_Border),
                                      child: Center(
                                        child: H14(
                                          text: LanguageService.trans("body"),
                                          weight: FW.medium,
                                          color: curCategory == 0 ? Colors.white : AppColor_Table_DateTime,
                                        ),
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    gBodyTab = false;
                                    eventBus.fire(SelectBodyBrainEvent());
                                    eventBus.fire(SubTabEvent(type: 1));
                                    onChooseCategory(1);
                                  },
                                  child: Container(
                                      height: 25,
                                      width: 65,
                                      margin: const EdgeInsets.only(left: 0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(13),
                                          boxShadow: [
                                            curCategory == 1
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
                                          color: curCategory == 1 ? AppColor_Primary : AppColor_Table_Border),
                                      child: Center(
                                        child: H14(
                                          text: LanguageService.trans("brains"),
                                          weight: FW.medium,
                                          color: curCategory == 1 ? Colors.white : AppColor_Table_DateTime,
                                        ),
                                      )),
                                ),
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InfoArea(type: curCategory),
                    ReportArea(type: curCategory, result: 0),
                    const SizedBox(height: 60),
                    GrowthStoreArea(curCategory: 1),
                    const SizedBox(height: 60),
                    DevelopmentalClassArea(curCategory: 1),
                    const SizedBox(height: 30),
                    CommunityArea2(curCategory: 1),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Positioned(
                child: AppFloatingButton(onPressed: goChatting),
                right: 12,
                bottom: 12,
              ),
            )
          ],
        ));
  }
}
