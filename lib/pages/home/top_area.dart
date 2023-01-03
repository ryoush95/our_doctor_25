import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/date_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/final_result_res_model.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_result.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_start.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_test_form.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:sprintf/sprintf.dart';

class TopArea extends StatefulWidget {
  final name;
  final type;

  TopArea({Key? key, this.name, this.type}) : super(key: key);

  @override
  TopAreaState createState() => TopAreaState();
}

class TopAreaState extends BaseState<TopArea> {
  final tooltip = GlobalKey();
  final HttpService httpService = HttpService();
  FinalresultDto? dicInfo;
  String titleMsg = "";
  String titleMsg1 = "";
  HomeMonitorDto? dicHomeDataInfo;

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("monitoring_guie"),
        textStyle: AppTextStyle.PD(AppColor_BlackText, 12),
        height: 87,
        width: 140,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        borderRadius: BorderRadius.circular(10.0), onDismiss: () {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Dismiss callback!")));
    });

    /// show the popup for specific widget
    popup.show(
      widgetKey: tooltip,
    );
  }

  @override
  void initState() {
    super.initState();
    // titleMsg = sprintf(LanguageService.trans("childrens") + " \n" + LanguageService.trans("what_future_height"), [isMorning() ? LanguageService.trans("am") : LanguageService.trans("pm")]);
    // titleMsg1 = sprintf(LanguageService.trans("childrens_growing_rapidly"), [95]);
    titleMsg = "어린이는 폭풍성장중 \n 종합 발달스코어 ";
    titleMsg1 =
        sprintf(LanguageService.trans("childrens_growing_rapidly"), [95]);
    //getFinalResultInfo();
    getMonitor2HomeDataInfo();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (gSignupMonitoring) {
        gSignupMonitoring = false;
        Navigator.push(context,
            SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
      }
    });

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getMonitor2HomeDataInfo();
      }
    });

    eventBus.on<MonitoringFinishEvent>().listen((event) {
      if (mounted) {
        getMonitor2HomeDataInfo();
      }
    });
  }

  var days = [
    LanguageService.trans('sunday'),
    LanguageService.trans('monday'),
    LanguageService.trans('tuesday'),
    LanguageService.trans('wednesday'),
    LanguageService.trans('thursday'),
    LanguageService.trans('friday'),
    LanguageService.trans('saturday'),
  ];
  var weekday = DateTime.now().weekday;
  String month = DateTime.now().month.toString();
  String day = DateTime.now().day.toString();

  String getButtonName() {
    String result = "";

    if (dicHomeDataInfo == null || dicHomeDataInfo!.todayResult == null) {
      result = LanguageService.trans('start_monitoring');
    } else {
      result = LanguageService.trans('checking_the_diagnosis_result');
    }
    return result;

/*    if (dicInfo == null || dicInfo!.regtime! == "") {
      result = LanguageService.trans(isMorning()
          ? 'home_start_am_monitoring'
          : 'home_start_pm_monitoring');
      return result;
    }

    String regtime = dicInfo!.regtime!;
    String oldDate = regtime.substring(0, 10);
    int oldHour = int.parse(regtime.substring(11, 13));
    String currentDate = getCurrentDate();
    if (oldDate != currentDate) {
      result = LanguageService.trans(isMorning()
          ? 'home_start_am_monitoring'
          : 'home_start_pm_monitoring');
    } else {
      result = LanguageService.trans(isMorning()
          ? 'home_start_am_monitoring'
          : 'home_start_pm_monitoring');
      var dt = DateTime.now();
      int curHour = dt.hour;
      if (curHour < 12) {
        //오전 시간
        if (oldHour < 12) {
          result = LanguageService.trans('home_restart_am_monitoring');
        }
      } else {
        //오후 시간
        if (oldHour > 12) {
          result = LanguageService.trans('home_restart_pm_monitoring');
        }
      }
    }

    return result;*/
  }

  void goMonitorStart() {

    // if (dicHomeDataInfo == null || dicHomeDataInfo!.todayResult == null) {
    //   monitoringData = null;
      Navigator.push(context,
          SlideRightTransRoute(builder: (context) => MonitoringTestForm()));
    // } else {
    //   //모니터링 리스트페이지로
    //   Navigator.push(context,
    //       SlideRightTransRoute(builder: (context) => MonitoringResultPage()));
    // }
  }

  // Network functions
  //////////////////////////////////
  //최종 모니터 정보 얻기
  Future<void> getFinalResultInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<FinalResultResModel> info = httpService.finalResult();
    info.then((FinalResultResModel value) async {
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

  //홈 발달 리포트 얻기
  Future<void> getMonitor2HomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeMonitorResModel> info = httpService.homeMonitorInfo();
    info.then((HomeMonitorResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeDataInfo = value.data!;
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

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            height: 330,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor_Gray,
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 5 Vertically
                    ),
                  )
                ]),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H18(
                            text: month +
                                LanguageService.trans('month') +
                                ' ' +
                                day +
                                LanguageService.trans('day') +
                                ' ' +
                                days[weekday % 7], weight: FW.bold,),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            dicHomeDataInfo!.profileImgUrl! != ""
                                ? CachedNetworkImage(
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    imageUrl: dicHomeDataInfo!.profileImgUrl!,
                                    imageBuilder: (context, image) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: image,
                                      radius: 64,
                                    ),
                                  )
                                : RoundContainer(
                                    width: 128,
                                    height: 128,
                                    bgColor: Colors.white,
                                    child: Center(
                                      child: Image.asset(
                                          (dicHomeDataInfo == null ||
                                                  dicHomeDataInfo!.gender ==
                                                      1)
                                              ? 'assets/ic_default_male.png'
                                              : 'assets/ic_default_female.png',
                                          width: 45),
                                    ),
                                  ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "100",
                                            style: AppTextStyle.PD(
                                                AppColor_Primary, 16,
                                                weight: FW.bold)),
                                        TextSpan(
                                            text: " 일째",
                                            style: AppTextStyle.PD(
                                              AppColor_BlackText,
                                              16,
                                              weight: FW.regular,
                                            )),
                                      ])),
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: widget.name,
                                            style: AppTextStyle.PD(
                                                AppColor_Primary, 16,
                                                weight: FW.bold)),
                                        TextSpan(
                                            text: " 어린이는 폭풍성장중!!",
                                            style: AppTextStyle.PD(
                                              AppColor_BlackText,
                                              16,
                                              weight: FW.regular,
                                            )),
                                      ])),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      H16(
                                        text: "키",
                                        weight: FW.regular,
                                      ),
                                      // Expanded(child: SizedBox()),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "100",
                                            style: AppTextStyle.PD(
                                                AppColor_Primary, 16,
                                                weight: FW.bold)),
                                        TextSpan(
                                            text: " cm",
                                            style: AppTextStyle.PD(
                                              AppColor_BlackText,
                                              16,
                                              weight: FW.regular,
                                            )),
                                      ])),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      H16(
                                        text: "체중",
                                        weight: FW.regular,
                                      ),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "100",
                                            style: AppTextStyle.PD(
                                                AppColor_Primary, 16,
                                                weight: FW.bold)),
                                        TextSpan(
                                            text: " kg",
                                            style: AppTextStyle.PD(
                                              AppColor_BlackText,
                                              16,
                                              weight: FW.regular,
                                            )),
                                      ])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "생활 ",
                                  style: AppTextStyle.PD(
                                      AppColor_Primary, 16,
                                      weight: FW.bold)),
                                TextSpan(
                                    text: "모니터링 기록 ",
                                    style: AppTextStyle.PD(
                                      AppColor_BlackText,
                                      16,
                                      weight: FW.regular,
                                    )),
                                TextSpan(
                                    text: "+12일 ",
                                    style: AppTextStyle.PD(
                                      AppColor_BlackText,
                                      16,
                                    )),
                              ]
                            )),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "다음검사 ",
                                      style: AppTextStyle.PD(
                                        AppColor_BlackText,
                                        16,
                                        weight: FW.regular,
                                      )),
                                  TextSpan(
                                      text: " 40일 후",
                                      style: AppTextStyle.PD(
                                          AppColor_Primary, 16,
                                          weight: FW.bold)),
                                ]
                            )),
                          ],
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Container(
                                width: 284,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: MainTextButton(
                                        text: getButtonName(),
                                        style: AppTextStyle.PD(
                                            Colors.white, 16,
                                            weight: FW.medium),
                                        width: 185,
                                        height: 40,
                                        radius: 6,
                                        onPressed: () {
                                          goMonitorStart();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
