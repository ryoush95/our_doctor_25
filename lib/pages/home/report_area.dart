import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitor_week_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/dialog/dlg_common.dart';
import 'package:ourdoctor/pages/dialog/dlg_kaori_time.dart';
import 'package:ourdoctor/pages/home/disease_report.dart';
import 'package:ourdoctor/pages/home/height_report.dart';
import 'package:ourdoctor/pages/home/inspection_report.dart';
import 'package:ourdoctor/pages/home/language_report.dart';
import 'package:ourdoctor/pages/home/lifestyle_report.dart';
import 'package:ourdoctor/pages/home/prev_monitoring.dart';
import 'package:ourdoctor/pages/home/weight_report.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:sprintf/sprintf.dart';

import 'lifestyle_line_chart.dart';

class ReportArea extends StatefulWidget {
  final type;
  final result;

  ReportArea({Key? key, this.type, this.result = 0}) : super(key: key);

  @override
  ReportAreaState createState() => ReportAreaState();
}

class ReportAreaState extends BaseState<ReportArea> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController reportTabController;
  // late DateTime firstDate;
  int curYear = 0;
  int curMonth = 0;
  DateTime now = DateTime.now();

  // String firstDateString = '';
  // String lastDateString = '';
  List<ReportDto> reportList = [];
  List<ReportDto> reportList1 = [];
  List<ReportDto> reportList2 = [];
  List<MonitorWeekDto> arrResultList = [];

  final HttpService httpService = HttpService();

  HomeGraphTallDto? dicHomeGraphTallInfo;
  HomeGraphWeightDto? dicHomeGraphWeightInfo;
  HomeGraphLifeStyleDto? dicHomeGraphLifeStyleInfo;

  @override
  void initState() {
    super.initState();

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        dicHomeGraphTallInfo = null;
        dicHomeGraphWeightInfo = null;
        dicHomeGraphLifeStyleInfo = null;

        getHomeGraphTall();
        getHomeGraphWeight();

        // firstDate = now.subtract(Duration(days: now.weekday - 1)); //2022-07-11
        curYear = now.year;
        curMonth = now.month;
        getHomeGraphLifeStyle();
      }
    });

    eventBus.on<SelectBodyBrainEvent>().listen((event) {
      if (mounted) {
        if (isMoreBirth1(85) && !gBodyTab) {
          changeTab(3);
        } else {
          changeTab(0);
        }
      }
    });

    eventBus.on<CheckChildQuizEvent>().listen((event) {
      if(mounted) {
        changeTab(0);
      }
    });

    getHomeGraphTall();
    getHomeGraphWeight();

    // firstDate = now.subtract(Duration(days: getDateCount() - 1));
    // firstDateString = firstDate.month.toString() + LanguageService.trans('month') + ' ' + firstDate.day.toString() + LanguageService.trans('day');
    // if (firstDate.month == now.month) {
    //   lastDateString = now.day.toString() + LanguageService.trans('day');
    // } else {
    //   lastDateString = now.month.toString() + LanguageService.trans('month') + ' ' + now.day.toString() + LanguageService.trans('day');
    // }
    //firstDate = now.subtract(Duration(days: now.weekday - 1)); //2022-07-11
    curYear = now.year;
    curMonth = now.month;
    getHomeGraphLifeStyle();

    reportTabController = TabController(length: 4, vsync: this);
    reportTabController.addListener(() {
      changeTab(reportTabController.index);
    });

    // for test data
    for (int i = 0; i < 10; i++) {
      var rng = Random();
      ReportDto report = ReportDto();
      report.report_uid = i;
      report.morning_time = now.subtract(Duration(days: 6 - i)).toString();
      report.morning_temperature = ((rng.nextInt(50) + 350) / 10).toString();
      report.afternoon_time = now.subtract(Duration(days: 6 - i)).toString();
      report.afternoon_temperature = ((rng.nextInt(50) + 350) / 10).toString();
      report.am_time = '';
      report.pm_time = '';
      reportList.add(report);
    }
    for (int i = 0; i < 10; i++) {
      var rng = Random();
      ReportDto report = ReportDto();
      report.report_uid = i;
      report.morning_time = now.subtract(Duration(days: 6 - i)).toString();
      report.morning_temperature = ((rng.nextInt(50) + 350) / 10).toString();
      report.afternoon_time = now.subtract(Duration(days: 6 - i)).toString();
      report.afternoon_temperature = ((rng.nextInt(50) + 350) / 10).toString();
      report.am_time = '';
      report.pm_time = '';
      reportList1.add(report);
    }
    for (int i = 0; i < 10; i++) {
      var rng = Random();
      ReportDto report = ReportDto();
      report.report_uid = i;
      report.morning_time = now.subtract(Duration(days: 6 - i)).toString();
      report.morning_temperature = ((rng.nextInt(50) + 350) / 10).toString();
      report.afternoon_time = now.subtract(Duration(days: 6 - i)).toString();
      report.afternoon_temperature = ((rng.nextInt(50) + 350) / 10).toString();
      report.am_time = '';
      report.pm_time = '';
      reportList2.add(report);
    }
    print(widget.type * 4 + reportTabController.index.toInt());
    // for (int i = 0; i < 7; i++) {
    //   ReportDto report = ReportDto();
    //   report.report_uid = i;
    //   report.morning_time = "";
    //   report.morning_temperature = "";
    //   report.morning_saturation = "";
    //   report.morning_breath = "";
    //   report.morning_symptom = "";
    //   report.morning_medication = "";
    //   report.afternoon_time = "";
    //   report.afternoon_temperature = "";
    //   report.afternoon_saturation = "";
    //   report.afternoon_breath = "";
    //   report.afternoon_symptom = "";
    //   report.afternoon_medication = "";
    //
    //   reportList.add(report);
    // }
    // getWeekResultInfo();
    // eventBus.on<SelectChildEvent>().listen((event) {
    //   if (mounted) {
    //     getWeekResultInfo();
    //   }
    // });
  }

  void changeTab(int tab) {
    setState(() {
      tabIndex = tab;
      reportTabController.index = tabIndex;
      if (widget.type == 1) {
        eventBus.fire(HomeBrainTabEvent(type: reportTabController.index));
      }
    });
  }

  void setData() {
    // reportList.clear();
    // for (int i = 0; i < getDateCount(); i++) {
    //   ReportDto report = ReportDto();
    //   report.report_uid = i;
    //   report.morning_time = now.subtract(Duration(days: getDateCount() - 1 - i)).toString();
    //   report.morning_temperature = "0";
    //   report.morning_saturation = "0";
    //   report.morning_breath = "0";
    //   report.morning_symptom = "";
    //   report.morning_medication = '';
    //   report.afternoon_time = now.subtract(Duration(days: getDateCount() - 1 - i)).toString();
    //   report.afternoon_temperature = "0";
    //   report.afternoon_saturation = "0";
    //   report.afternoon_breath = "0";
    //   report.afternoon_symptom = "";
    //   report.afternoon_medication = "";
    //   report.am_time = "";
    //   report.pm_time = "";
    //   report.am_medication = "";
    //   report.pm_medication = "";
    //   report.am_saturation = "";
    //   report.pm_saturation = "";
    //
    //   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    //   DateTime temp = now.subtract(Duration(days: getDateCount() - 1 - i));
    //   String tempDate = dateFormat.format(temp);
    //
    //   //오전데이터 자료
    //   MonitorWeekDto amInfo = getData(tempDate, 1);
    //   if (amInfo.uid != null && amInfo.uid != "") {
    //     report.am_time = amInfo.regtime!;
    //     report.morning_temperature = amInfo.temperature!;
    //     report.morning_saturation = amInfo.oxygen! == "-1" ? "0" : amInfo.oxygen!;
    //     report.am_saturation = amInfo.oxygen!;
    //     report.morning_breath = amInfo.heartCnt! == "-1" ? "0" : amInfo.heartCnt!;
    //     report.am_breath = amInfo.heartCnt!;
    //     report.morning_symptom = amInfo.symptom!;
    //     report.morning_medication = amInfo.pillUrl! == "-1" ? "" : amInfo.pillUrl!;
    //     report.am_medication = amInfo.pillUrl!;
    //   }
    //
    //   //오후데이터 자료
    //   MonitorWeekDto pmInfo = getData(tempDate, 2);
    //   if (pmInfo.uid != null && pmInfo.uid != "") {
    //     report.pm_time = pmInfo.regtime!;
    //     report.afternoon_temperature = pmInfo.temperature!;
    //     report.afternoon_saturation = pmInfo.oxygen! == "-1" ? "0" : pmInfo.oxygen!;
    //     report.pm_saturation = pmInfo.oxygen!;
    //     report.afternoon_breath = pmInfo.heartCnt! == "-1" ? "0" : pmInfo.heartCnt!;
    //     report.pm_breath = pmInfo.heartCnt!;
    //     report.afternoon_symptom = pmInfo.symptom!;
    //     report.afternoon_medication = pmInfo.pillUrl! == "-1" ? "" : pmInfo.pillUrl!;
    //     report.pm_medication = pmInfo.pillUrl!;
    //   }
    //   reportList.add(report);
    // }
    // changeTab(1);
    // setState(() {});
    //
    // Future.delayed(const Duration(seconds: 1), () {
    //   setState(() {
    //     changeTab(0);
    //   });
    // });
  }

  MonitorWeekDto getData(String date, int type) {
    MonitorWeekDto item = MonitorWeekDto();
    for (int i = 0; i < arrResultList.length; i++) {
      MonitorWeekDto info = arrResultList.elementAt(i);
      String strDate = info.regtime!.split(" ")[0];
      String strHour = info.regtime!.split(" ")[1].substring(0, 2);
      int nHour = int.parse(strHour);
      if (strDate == date) {
        if (type == 1) {
          if (nHour < 12) {
            return info;
          }
        } else if (type == 2) {
          if (nHour > 12) {
            return info;
          }
        }
      }
    }
    return item;
  }

  // Network functions
  //////////////////////////////////
  //홈 그래프 신장 얻기
  Future<void> getHomeGraphTall() async {
    setState(() {
      isLoading = true;
    });

    print(gUserInfo!.accessToken!);
    Future<HomeGraphTallResModel> info = httpService.homeGraphTall();
    info.then((HomeGraphTallResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeGraphTallInfo = value.data!;
        // dicHomeGraphTallInfo!.graph = List.from(dicHomeGraphTallInfo!.graph!.reversed);
        if (isMoreBirth1(85) && !gBodyTab) {
          changeTab(3);
        }
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

  //홈 그래프 생활습관 얻기
  Future<void> getHomeGraphLifeStyle() async {
    setState(() {
      isLoading = true;
    });

    String curDate = sprintf("%04d-%02d", [curYear, curMonth]);
    Future<HomeGraphLifeStyleResModel> info = httpService.homeGraphLifeStyle1(curDate);
    info.then((HomeGraphLifeStyleResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeGraphLifeStyleInfo = value.data!;
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

  /*
  //모니터 주 결과 얻기
  Future<void> getWeekResultInfo() async {
    setState(() {
      isLoading = true;
    });

    String keyDate = DateFormat('yyyy-MM-dd').format(firstDate);
    Future<MonitorWeekResultResModel> offerInfo = httpService.monitorWeekResult(keyDate);
    offerInfo.then((MonitorWeekResultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrResultList = value.data!;
        setData();
      } else {
        showToast(value.reason ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }
  */
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: (isMoreBirth1(85) && widget.type == 1) ? 0 : 60,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabHeaderItem(widget.type == 0 ? LanguageService.trans("height") : LanguageService.trans("language"), 0),
              _buildTabHeaderItem(widget.type == 0 ? LanguageService.trans("weight") : LanguageService.trans("work_out"), 1),
              _buildTabHeaderItem(widget.type == 0 ? LanguageService.trans("lifestyle") : LanguageService.trans("sociability"), 2),
              _buildTabHeaderItem(widget.type == 0 ? LanguageService.trans("disease") : LanguageService.trans("custom_inspection"), 3),
              //_buildTabHeaderItem(LanguageService.trans("taking_medication"), 4),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          // padding: const EdgeInsets.symmetric(horizontal: 30),
          // height: heights[widget.type * 4 + reportTabController.index.toInt()] - (1 - widget.result) * 400,
          //height: 300,
          // child: DefaultTabController(
          //   length: 4,
          //   child: TabBarView(
          //     controller: reportTabController,
          //     physics: const NeverScrollableScrollPhysics(),
          //     children: [
          //       PrevMonitoring(data: reportList),
          //       widget.type == 0 ? HeightReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result) : LanguageReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result),
          //       widget.type == 0 ? WeightReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result) : LanguageReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result),
          //       widget.type == 0 ? LifestyleReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result) : LanguageReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result),
          //       widget.type == 0 ? DiseaseReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result) : InspectionReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result)
          //       // HeightReport(data: reportList, data1: reportList1, data2: reportList2),
          //       // TemperatureReport(data: reportList),
          //       // OxygenReport(data: reportList),
          //       // BreathReport(data: reportList),
          //       // SymptomReport(data: reportList),
          //       // MedicationReport(data: reportList),
          //     ],
          //   ),
          // ),
          child: Stack(
            children: [_body()],
          ),
        ),
      ],
    );
  }

  bool isTomorrowMonth() {
    int year = curYear;
    int month = curMonth;
    if (month + 1 == 13) {
      month = 1;
      year = year + 1;
    } else {
      month = month + 1;
    }
    if ((year + month) > (now.year + now.month)) {
      return true;
    } else {
      return false;
    }
  }

  Widget _body() {
    if (widget.type == 0) {
      if (reportTabController.index == 0) {
        if (dicHomeGraphTallInfo == null || dicHomeGraphTallInfo!.monitoring == null) {
          return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray), padding: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50), margin: const EdgeInsets.symmetric(horizontal: 30), child: PrevMonitoring());
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 28),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H18(text: LanguageService.trans('than_last_month'), weight: FW.regular),
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                              
                                TextSpan(text: sprintf(LanguageService.trans('%.1fcm '), [dicHomeGraphTallInfo!.heightPrevDiff]), style: AppTextStyle.PD(AppColor_BlackText, 18, height: 1.8)),
                                TextSpan(text: dicHomeGraphTallInfo!.heightPrevDiff! >= 0.0 ? '더 늘어났어요.' : '줄어들었어요.', style: AppTextStyle.PD(AppColor_BlackText, 18, weight: FW.regular)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Image.asset('assets/ic_smile2.png', width: 20, height: 20),
                      ],
                    ),
              const SizedBox(height: 18),
              Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: HeightReport(data: dicHomeGraphTallInfo!, result: widget.result)),
            ],
          );
        }
      } else if (reportTabController.index == 1) {
        if (dicHomeGraphWeightInfo == null || dicHomeGraphWeightInfo!.monitoring == null) {
          return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray), padding: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50), margin: const EdgeInsets.symmetric(horizontal: 30), child: PrevMonitoring());
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 28),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H18(text: LanguageService.trans('than_last_month'), weight: FW.regular),
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(text: sprintf(LanguageService.trans('%.1fkg '), [dicHomeGraphWeightInfo!.weightPrevDiff]), style: AppTextStyle.PD(AppColor_BlackText, 18, height: 1.8)),
                                TextSpan(text: dicHomeGraphWeightInfo!.weightPrevDiff! >= 0.0 ? '더 늘어났어요.' : '줄어들었어요.', style: AppTextStyle.PD(AppColor_BlackText, 18, weight: FW.regular)),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Image.asset('assets/ic_smile2.png', width: 20, height: 20),
                      ],
                    ),
              const SizedBox(height: 18),
              Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: WeightReport(data: dicHomeGraphWeightInfo!, result: widget.result)),
            ],
          );
        }//생활습관
      } else if (reportTabController.index == 2) {
        if (dicHomeGraphLifeStyleInfo == null || dicHomeGraphLifeStyleInfo!.monitoringFood == null) {
          return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray), padding: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50), margin: const EdgeInsets.symmetric(horizontal: 30), child: PrevMonitoring());
        } else {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 32),
                  InkWell(
                      onTap: () {
                        if (curMonth - 1 == 0) {
                          curMonth = 12;
                          curYear = curYear - 1;
                        } else {
                          curMonth = curMonth - 1;
                        }
                        setState(() {});
                        getHomeGraphLifeStyle();
                      },
                      child: Image.asset('assets/chevron_left_black_24dp.png', width: 20)),
                  const SizedBox(width: 18),
                  //H16(text: '${firstDate.month}월 ${numOfWeeks(firstDate)}주차' /*firstDateString + ' - ' + lastDateString*/, color: const Color(0xFF888888), weight: FW.semi_bold),
                  H16(text: '$curYear년 $curMonth월', color: AppColor_BlackText.withOpacity(0.5), weight: FW.semi_bold),
                  const SizedBox(width: 18),
                  InkWell(
                      onTap: () {
                        // if (firstDate.subtract(const Duration(days: -7)).isAfter(now)) {
                        //   return;
                        // }
                        if (isTomorrowMonth()) {
                          return;
                        }

                        if (curMonth + 1 == 13) {
                          curMonth = 1;
                          curYear = curYear + 1;
                        } else {
                          curMonth = curMonth + 1;
                        }
                        setState(() {});
                        getHomeGraphLifeStyle();
                      },
                      child: Opacity(opacity: (now.year == curYear && now.month == curMonth) ? 0.2 : 1.0, child: Image.asset('assets/chevron_right_black_24dp.png', width: 20))),
                  const SizedBox(width: 10),
                  InkWell(
                      onTap: () async {
                        // var _result = await showDialog(context: context, builder: (_) => KaoriDialog());
                        // CommonDialog().showOneBtnPopup(context).then((val) {
                        //   if (val.toString() == "1") {}
                        // });
                        Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: ['assets/img_table2.png'], type: 1)));
                      },
                      child: Image.asset(
                        'assets/question_mark_black_24dp.png',
                        width: 22,
                      )),
                ],
              ),
              const SizedBox(height: 18),
              Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: LifestyleReport(data: dicHomeGraphLifeStyleInfo!, result: widget.result)),
            ],
          );
        }
      } else if (reportTabController.index == 3) {
        return Column(
          children: [Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: DiseaseReport(data: reportList, data1: reportList1, data2: reportList2, result: widget.result))],
        );
      }
    } else if (widget.type == 1) {
      if (reportTabController.index == 0) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: LanguageReport(
                data: reportList,
                data1: reportList1,
                data2: reportList2,
                result: widget.result,
                type: reportTabController.index,
              ),
            )
          ],
        );
      } else if (reportTabController.index == 1) {
        return Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: LanguageReport(
                  data: reportList,
                  data1: reportList1,
                  data2: reportList2,
                  result: widget.result,
                  type: reportTabController.index,
                )),
          ],
        );
      } else if (reportTabController.index == 2) {
        return Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: LanguageReport(
                  data: reportList,
                  data1: reportList1,
                  data2: reportList2,
                  result: widget.result,
                  type: reportTabController.index,
                )),
          ],
        );
      } else if (reportTabController.index == 3) {
        return Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InspectionReport(
                  data: reportList,
                  data1: reportList1,
                  data2: reportList2,
                  result: widget.result,
                ))
          ],
        );
      }
    }
    return Container();
  }

  Widget _buildTabHeaderItem(String tabText, int step) {
    return InkWell(
      child: Stack(
        children: [
          SizedBox(
              width: (MediaQuery.of(context).size.width - 60) / 4,
              height: 40,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Center(
                    child: H16(text: tabText, color: tabIndex == step ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2), weight: FW.medium, maxLine: 2),
                  ),
                  Expanded(child: Container()),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: tabIndex == step ? 4 : 3,
                    color: tabIndex == step ? AppColor_BlackText : AppColor_f4f5f7,
                  ),
                ],
              )),
        ],
      ),
      onTap: () {
        changeTab(step);
      },
    );
  }

  int numOfWeeks(DateTime date) {
    String strDate = date.toString();
    String firstDay = strDate.substring(0, 8) + '01' + strDate.substring(10);

// week day for the first day of the month
    int weekDay = DateTime.parse(firstDay).weekday;

    DateTime testDate = date;

    int weekOfMonth;

//  If your calender starts from Monday
    weekDay--;
    weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    print('Week of the month: $weekOfMonth');
    weekDay++;

// If your calender starts from sunday
    if (weekDay == 7) {
      weekDay = 0;
    }
    weekOfMonth = ((testDate.day + weekDay) / 7).ceil();
    print('Week of the month: $weekOfMonth');
    return weekOfMonth;
  }
}
