import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_disease_res_model.dart';
import 'package:ourdoctor/models/home_vaccine_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/result_area.dart';
import 'package:ourdoctor/pages/dialog/dlg_common.dart';
import 'package:ourdoctor/pages/home/symptom_report.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import 'inoculation_info1.dart';

class DiseaseData {
  String date;
  String text;
  DiseaseData({this.date = "", this.text = ""});
}

class DiseaseReport extends StatefulWidget {
  DiseaseReport(
      {Key? key,
      required this.data,
      required this.data1,
      required this.data2,
      this.result = 1,
      this.type = 0})
      : super(key: key);

  final List<ReportDto> data;
  final List<ReportDto> data1;
  final List<ReportDto> data2;
  final int result;
  final int type;

  @override
  DiseaseReportState createState() => DiseaseReportState();
}

class DiseaseReportState extends BaseState<DiseaseReport> {
  DateTime now = DateTime.now();
  DateTime MonthstartDay = DateTime.now();
  DateTime startDay = DateTime.now();
  final HttpService httpService = HttpService();
  int type = 0; // 0이면 캘린더 표시, 1이면 질병

  List<DiseaseData> data = [
    DiseaseData(date: "2022-05-08", text: "Health screenings"),
    DiseaseData(date: "2022-05-18", text: "MMR"),
  ];

  var days = [
    LanguageService.trans('sun'),
    LanguageService.trans('mon'),
    LanguageService.trans('tue'),
    LanguageService.trans('wed'),
    LanguageService.trans('thu'),
    LanguageService.trans('fri'),
    LanguageService.trans('sat'),
  ];
  List<Widget> week_show = [];
  List<Widget> month_show = [];

  HomeVaccineDto? dicVaccineInfo;
  HOmeSymptomGraphDto? dicDiseaseInfo;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 7; i++) {
      week_show.add(SizedBox(
        width: 45,
        child: Center(
          child: H16(
            text: days[i],
            weight: FW.medium,
          ),
        ),
      ));
    }
    MonthstartDay = DateTime(now.year, now.month);
    refreshCalendar();

    getSymptomGraphInfo();
    getVaccineInfo();
    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getSymptomGraphInfo();
        getVaccineInfo();
      }
    });
  }

  void refreshCalendar() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    setState(() {
      startDay = MonthstartDay;
      if (DateTime(MonthstartDay.year, MonthstartDay.month, 1).weekday != 7) startDay = startDay.subtract(Duration(days: (DateTime(MonthstartDay.year, MonthstartDay.month, 1).weekday)));
      month_show.clear();
      var i = 0;
      while (i < 50) {
        i++;
        var j;
        String date = dateFormat.format(startDay);
        String NowString = dateFormat.format(now);
        for (j = 0; j < data.length; j++) {
          if (data[j].date == date) break;
        }
        var showmode = 0;
        if (j < data.length)
          showmode = 1;
        else if (NowString == date) showmode = 2;

        month_show.add(Container(
            width: 45,
            child: Column(children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: showmode == 2 ? AppColor_Primary : AppColor_White,
                  borderRadius: showmode == 2 ? BorderRadius.all(Radius.circular(13.0)) : BorderRadius.all(Radius.circular(0.0)),
                ),
                child: Center(
                  child: H16(
                      text: startDay.day.toString(),
                      color: showmode == 1
                          ? AppColor_4b6eff
                          : (showmode == 2
                              ? AppColor_White
                              : startDay.weekday == 7
                                  ? AppColor_Red
                                  : (startDay.weekday == 6 ? AppColor_Primary : AppColor_BlackText))),
                ),
              ),
              Center(
                child: H16(text: showmode == 1 ? data[j].text : "", color: AppColor_4b6eff),
              ),
            ])));
        startDay = startDay.add(const Duration(days: 1));
        if (startDay.month > MonthstartDay.month && startDay.weekday == 7) {
          break;
        }
      }
    });
  }

  void checkupCalendar(int type) {
    //type = 1 : 검진 캘린더  2 : 접종 캘린더
    data.clear();
    DateTime userBirth = new DateFormat("yyyy-MM-dd").parse(gSelChildInfo!.birth!);
    if (type == 1) {
      //검진 캘린더
      for (int i = 0; i < dicVaccineInfo!.healthList!.length; i++) {
        DateTime newDate = userBirth.add(Duration(days: 30 * int.parse(dicVaccineInfo!.healthList!.elementAt(i).periodStart!)));
        String temp = DateFormat('yyyy-MM-dd').format(newDate);
        DiseaseData info = DiseaseData();
        info.date = temp;
        info.text = dicVaccineInfo!.healthList!.elementAt(i).name!;
        data.add(info);
      }
    } else if(type == 2) {
      //접종 캘린더
      for (int i = 0; i < dicVaccineInfo!.vaccineList!.length; i++) {
        DateTime newDate = userBirth.add(Duration(days: 30 * int.parse(dicVaccineInfo!.vaccineList!.elementAt(i).periodStart!)));
        String temp = DateFormat('yyyy-MM-dd').format(newDate);
        DiseaseData info = DiseaseData();
        info.date = temp;
        info.text = dicVaccineInfo!.vaccineList!.elementAt(i).name!;
        data.add(info);
      }
    }

    refreshCalendar();

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
                width: double.infinity,
                height: 450,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                ),
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: H20(
                        text: "캘린더",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            MonthstartDay = DateTime(MonthstartDay.year, MonthstartDay.month - 1);
                          });
                          refreshCalendar();
                        },
                        child: Image.asset('assets/Path 12637.png', width: 10),
                      ),
                      const SizedBox(width: 30),
                      H20(text: sprintf("%d.%02d", [MonthstartDay.year, MonthstartDay.month])),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          setState(() {
                            MonthstartDay = DateTime(MonthstartDay.year, MonthstartDay.month + 1);
                          });
                          refreshCalendar();
                        },
                        child: Image.asset('assets/Path 12638.png', width: 10),
                      )
                    ]),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: week_show),
                    const SizedBox(height: 20),
                    month_show.length >= 7 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [month_show[0], month_show[1], month_show[2], month_show[3], month_show[4], month_show[5], month_show[6]]) : const SizedBox(),
                    month_show.length >= 14 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [month_show[7], month_show[8], month_show[9], month_show[10], month_show[11], month_show[12], month_show[13]]) : const SizedBox(),
                    month_show.length >= 21 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [month_show[14], month_show[15], month_show[16], month_show[17], month_show[18], month_show[19], month_show[20]]) : const SizedBox(),
                    month_show.length >= 28 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [month_show[21], month_show[22], month_show[23], month_show[24], month_show[25], month_show[26], month_show[27]]) : const SizedBox(),
                    month_show.length >= 35 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [month_show[28], month_show[29], month_show[30], month_show[31], month_show[32], month_show[33], month_show[34]]) : const SizedBox(),
                  ],
                ));
          });
        });
  }

  String gethealthContent() {
    String result = "";

    if (dicVaccineInfo == null || dicVaccineInfo!.healthList!.isEmpty) {
      return result;
    }

    String childBirth = gSelChildInfo!.birth!;
    DateTime childBirthDate = DateTime.parse(childBirth);
    for (int i = 0; i < dicVaccineInfo!.healthList!.length; i++) {
      HealthListDto info = dicVaccineInfo!.healthList!.elementAt(i);

      DateTime startDate = DateTime(childBirthDate.year, childBirthDate.month + int.parse(info.periodStart!), childBirthDate.day);
      DateTime endDate = DateTime(childBirthDate.year, childBirthDate.month + int.parse(info.periodEnd!), childBirthDate.day);

      final start = DateFormat('yyyy.MM.dd').format(startDate);
      final end = DateFormat('yyyy.MM.dd').format(endDate);

      String content = sprintf("%s ~ %s\n%s", [start, end, info.name]);
      if (result == "") {
        result = content;
      } else {
        result = result + "\n\n" + content;
      }
    }

    return result;
  }

  String getHealthCount() {
    String result = "";

    if (dicVaccineInfo == null || dicVaccineInfo!.healthList!.isEmpty) {
      return result;
    }
    int count = dicVaccineInfo!.healthList!.length;

    return count.toString() + "개";
  }

  String getVaccineContent() {
    String result = "";

    if (dicVaccineInfo == null || dicVaccineInfo!.vaccineList!.isEmpty) {
      return result;
    }

    String childBirth = gSelChildInfo!.birth!;
    DateTime childBirthDate = DateTime.parse(childBirth);
    for (int i = 0; i < dicVaccineInfo!.vaccineList!.length; i++) {
      HealthListDto info = dicVaccineInfo!.vaccineList!.elementAt(i);

      DateTime startDate = DateTime(childBirthDate.year, childBirthDate.month + int.parse(info.periodStart!), childBirthDate.day);
      DateTime endDate = DateTime(childBirthDate.year, childBirthDate.month + int.parse(info.periodEnd!), childBirthDate.day);

      final start = DateFormat('yyyy.MM.dd').format(startDate);
      final end = DateFormat('yyyy.MM.dd').format(endDate);

      String content = sprintf("%s ~ %s\n%s", [start, end, info.name]);
      if (result == "") {
        result = content;
      } else {
        result = result + "\n\n" + content;
      }
    }

    return result;
  }

  String getVaccineCount() {
    String result = "";

    if (dicVaccineInfo == null || dicVaccineInfo!.vaccineList!.isEmpty) {
      return result;
    }
    int count = dicVaccineInfo!.vaccineList!.length;

    return count.toString() + "개";
  }

  int getDiffDays(SymptomList inof) {
    return 0;
  }

  Widget _getLifeTiles(int index) {
    SymptomList item = dicDiseaseInfo!.symptomList!.elementAt(index);
    return Container(
      height: 65,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 64,
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (item.medicationUrl!.isEmpty) {
                      return;
                    }
                    List<String> imgs = [];
                    imgs.add(item.medicationUrl!);
                    Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: imgs, type: 0)));
                  },
                  child: Row(
                    children: [
                      H18(
                        text: item.symptom!,
                        weight: FW.semi_bold,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      Visibility(
                        visible: item.medicationUrl!.isNotEmpty,
                        child: Container(width: 5),
                      ),
                      Visibility(
                        visible: item.medicationUrl!.isNotEmpty,
                        child: Image.asset(
                          'assets/ic_search.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 20),
                Visibility(
                  visible: dicDiseaseInfo != null && dicDiseaseInfo!.symptomStartDate!.isNotEmpty,
                  child: H14(
                    text: "D+" + checkSelDate1(dicDiseaseInfo == null ? "" : dicDiseaseInfo!.symptomStartDate!).toString(),
                    weight: FW.semi_bold,
                    align: TextAlign.start,
                    color: AppColor_Primary,
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    symptomComplete(item.id!, index);
                  },
                  child: Container(
                    width: 74,
                    height: 24,
                    decoration: BoxDecoration(border: Border.all(width: 1.5, color: AppColor_Green), borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    child: Center(
                      child: H14(
                        text: "완치됐어요",
                        weight: FW.semi_bold,
                        align: TextAlign.start,
                        color: AppColor_Green,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0xFFF4F5F7),
          ),
        ],
      ),
    );
  }

  int checkSelDate1(String date) {
    int diffDays = 0;

    if (date == "") {
      return diffDays;
    }
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String curDate = dateFormat.format(now);

    DateTime date1 = dateFormat.parse(date);
    DateTime date2 = dateFormat.parse(curDate);
    diffDays = date2.difference(date1).inDays;

    return diffDays;
  }

  int checkSelDate2(String date) {
    int diffDays = 0;

    if (date == "") {
      return diffDays;
    }
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String curDate = dateFormat.format(now);

    DateTime date1 = dateFormat.parse(date);
    DateTime date2 = dateFormat.parse(curDate);
    diffDays = date2.difference(date1).inDays;

    return diffDays.abs();
  }

  _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  // Network functions
  //////////////////////////////////
  //홈 그래프 질병정보 얻기
  Future<void> getSymptomGraphInfo() async {
    // DateTime temp = DateTime.now().add(const Duration(days: -7));
    String newDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    setState(() {
      isLoading = true;
    });
    Future<HOmeSymptomGraphResModel> info = httpService.homeDiseaseGraph(newDate);
    info.then((HOmeSymptomGraphResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (value.data!.symptomList!.isEmpty) {
          type = 0;
        } else {
          type = 1;
        }
        dicDiseaseInfo = value.data;
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

  //홈 검진백신 데이터 얻기
  Future<void> getVaccineInfo() async {
    setState(() {
      isLoading = true;
    });
    Future<HomeVaccineResModel> info = httpService.homehealthVaccine();
    info.then((HomeVaccineResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicVaccineInfo = value.data!;
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

  //질병 완쾌
  Future<void> symptomComplete(String uid, int index) async {
    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> info = httpService.symptomComplete(uid);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicDiseaseInfo!.symptomList!.removeAt(index);
        showToast("질병 완쾌 되었습니다.");
        if (dicDiseaseInfo!.symptomList!.isEmpty) {
          type = 0;
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: type == 0
            ? Column(
                children: [
                  const SizedBox(width: 28),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: H18(
                          text: LanguageService.trans('are_you_healthy'),
                          weight: FW.regular,
                          align: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          H18(
                            text: "D+" + checkSelDate2(dicDiseaseInfo == null ? "" : dicDiseaseInfo!.symptomNoDate!).toString(),
                            color: AppColor_BlackText,
                          ),
                          H18(
                            text: "일",
                            color: AppColor_BlackText,
                          ),
                          const SizedBox(width: 5),
                          Image.asset('assets/ic_status1.png', width: 20, height: 20),
                        ],
                      )
                    ],
                  ),
                  Visibility(
                    visible: dicVaccineInfo != null && dicVaccineInfo!.healthList!.isNotEmpty,
                    child: Container(
                        width: MediaQuery.of(context).size.width - 64,
                        margin: const EdgeInsets.only(top: 18),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                        padding: const EdgeInsets.all(30),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [H16(text: LanguageService.trans("upcoming_health_checkup")), H16(text: getHealthCount(), color: AppColor_Primary)],
                          ),
                          const SizedBox(height: 24),
                          Container(
                              width: MediaQuery.of(context).size.width - 64,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Colors.white),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                // H16(text: "2022.04.07 - 2022.04.11"),
                                // const SizedBox(height: 5),
                                H14(
                                  text: gethealthContent(),
                                  weight: FW.semi_bold,
                                  maxLine: 100,
                                  height: 1.1,
                                  align: TextAlign.start,
                                ),
                                // const SizedBox(height: 20),
                                // H16(text: "2022.04.07 - 2022.04.11"),
                                // const SizedBox(height: 5),
                                // H16(
                                //   text: "- 7차 구강검진",
                                //   weight: FW.regular,
                                // ),
                              ])),
                          const SizedBox(height: 20),
                          MainTextButton(
                            text: "검진 캘린더",
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                            width: screenSize.width - 60,
                            height: 46,
                            radius: 4,
                            showBorder: false,
                            onPressed: () async {
                              // Navigator.pop(context);

                              if (dicVaccineInfo!.healthList!.isEmpty) {
                                showToast("건강검진 내역이 없습니다.");
                                return;
                              }
                              MonthstartDay = DateTime(now.year, now.month);
                              refreshCalendar();
                              checkupCalendar(1);

                             /* if (isMoreBirth(6)) {
                                _launchURL(HEALTH_CALENDAR);
                              } else {
                                CommonDialog().showHealthCalendarPopup(context).then((val) {
                                  if (val.toString() == "1") {}
                                });
                              }*/
                            },
                          ),
                        ])),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 64,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                      padding: const EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [H16(text: "접종/검진"), H16(text: getVaccineCount(), color: AppColor_Green)],
                             ),

                      /*  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H16(text: "접종/검진"),
                            Image.asset('assets/ic_right_arrow.png', width: 10),
                          ],
                        ),*/
                        const SizedBox(height: 24),
                        Container(
                          width: MediaQuery.of(context).size.width - 64,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white),
                          child: H14(
                            text: getVaccineContent(),
                            weight: FW.semi_bold,
                            maxLine: 100,
                            height: 1.1,
                            align: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 20),
                        MainTextButton(
                          text: "접종 기록 업데이트",
                          backgroundColor: AppColor_Primary,
                          style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                          width: screenSize.width - 60,
                          height: 46,
                          radius: 4,
                          showBorder: false,
                          onPressed: () async {
                            // Navigator.pop(context);

                            if (dicVaccineInfo!.healthList!.isEmpty) {
                              showToast("예방접종 내역이 없습니다.");
                              return;
                            }
                            MonthstartDay = DateTime(now.year, now.month);
                            refreshCalendar();
                            checkupCalendar(2);

                           /* // 2022-06-29
                            if (isMoreBirth(12)) {
                              _launchURL(vaccine_CALENDAR);
                            } else {
                              CommonDialog().showVaccineCalendarPopup(context).then((val) {
                                if (val.toString() == "1") {}
                              });
                            }*/

                           // Navigator.push(context, SlideRightTransRoute(builder: (context) => InoculationInfo1Page()));
                          },
                        ),
                            /*H16(text: "접종/검진"),
                            const SizedBox(height: 8),
                            H14(
                              text: "개인화된 정보를 확인 가능하도록\n업데이트 예정입니다.",
                              weight: FW.semi_bold,
                              align: TextAlign.start,
                              maxLine: 2,
                              color: AppColor_BlackText.withOpacity(0.4),
                              height: 1.1,
                            ),
                            const SizedBox(height: 25),
                            InkWell(
                              onTap: () {
                                _launchURL(HEALTH_URL1);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width -
                                      64 -
                                      48,
                                  height: 46,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: AppColor_Primary),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/ic_health1.png',
                                          width: 24),
                                      const SizedBox(width: 6),
                                      H16(
                                        text: "예방 접종정보 확인하기",
                                        weight: FW.medium,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                _launchURL(HEALTH_URL2);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width -
                                      64 -
                                      48,
                                  height: 46,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: AppColor_Green),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/ic_health2.png',
                                          width: 24),
                                      const SizedBox(width: 6),
                                      H16(
                                        text: "영유아건강검진 정보 확인하기",
                                        weight: FW.medium,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                            ),*/
                          ])),
                  const SizedBox(height: 20),
                  Container(
                      width: MediaQuery.of(context).size.width - 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: AppColor_Light_Gray),
                      // padding: const EdgeInsets.all(30),
                      child: Column(children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 30),
                            H16(text: "시기별 유행성 질환 Tip "),
                            Image.asset(
                              "assets/ic_disease_tip.png",
                              width: 21,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: MediaQuery.of(context).size.width - 64,
                          decoration: const BoxDecoration(
                              color: AppColor_Selector_Border),
                          margin: const EdgeInsets.only(right: 30, left: 30),
                          child: ExtendedImage.network(
                            dicVaccineInfo == null
                                ? ""
                                : dicVaccineInfo!.tipImage!,
                            width: MediaQuery.of(context).size.width - 64 - 60,
                            fit: BoxFit.fitWidth,
                            cache: true,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ])),
                  // widget.result == 1 ? const SizedBox(height: 40) : const SizedBox(),
                  // widget.result == 1 ? ResultArea(type: 3, result: 2) : const SizedBox(),
                ],
              )
            : Column(children: [
                Container(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _getLifeTiles(index);
                    },
                    itemCount: dicDiseaseInfo == null ? 0 : dicDiseaseInfo!.symptomList!.length,
                  ),

                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                  padding: const EdgeInsets.all(30),
                  child: SymptomReport(data: dicDiseaseInfo!),
                ),
                // const SizedBox(height: 12),
                // Container(
                //   width: double.infinity,
                //   height: 300,
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray),
                //   padding: const EdgeInsets.all(30),
                //   child: SymptomReport1(data: dicDiseaseInfo!),
                // ),
              ]));
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
