import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/final_result_res_model.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/models/monitoring/note_profile_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/home/circular_progress2.dart';
import 'package:ourdoctor/pages/home/circular_progress3.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitor_report1.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_result2.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_main2.dart';
import 'package:ourdoctor/provider/global_provider.dart';
import 'package:provider/provider.dart';

import '../app_event.dart';
import 'monitoring_test_form.dart';

class MonitoringFragment2 extends StatefulWidget {
  MonitoringFragment2({Key? key, this.type = 0, this.pageType = 0})
      : super(key: key);
  int? type;
  int? pageType;

  @override
  MonitoringFragment2State createState() => MonitoringFragment2State();
}

class MonitoringFragment2State extends BaseState<MonitoringFragment2> {
  final HttpService httpService = HttpService();
  int curCategory1 = 0;
  HomeMonitorDto? dicHomeDataInfo;
  MonitoringProfileDto? data;

  String lifeIcon = "assets/icon_normal.png";
  String lifeText = "";


  @override
  void initState(){

    getMonitor2HomeDataInfo();

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getMonitor2HomeDataInfo();
      }
    });
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
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

  Future<void> getNoteInfo() async {
    final p = Provider.of<GlobalProvider>(context, listen: false);
    await p.getNoteInfo(context);
    data = p.profile;
  }

  Color changeColor(String s) {
    if(s == "R"){
      return AppColor_Red;
    } else if(s=="G"){
      return AppColor_Oxygen;
    } else {
      return AppColor_Primary;
    }
  }


  Widget monitor1(MonitoringProfileDto p) {
    final life = Provider.of<GlobalProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H18(text: "우아 발달 모니터링 리포트"),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 370,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
              color: AppColor_White,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: AppColor_Light_Gray,
                  blurRadius: 5.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 85,child: H16(text: "발달영역", align: TextAlign.center, weight: FW.medium)),
                  SizedBox(width: 85,child: H16(text: "신체성장", align: TextAlign.center, weight: FW.medium)),
                  SizedBox(width: 85,child: H16(text: "생활습관", align: TextAlign.center, weight: FW.medium)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgress3(score: p.monitoringProgress != 3 ? 0 : p.development!.score,status: p.development!.status,),
                  Container(margin: EdgeInsets.all(5),child: CircularProgress3(score: p.monitoringProgress != 3 ? 0 : p.health!.score ,status: p.health!.status,)),
                  Container(
                    height: 85,
                    width: 85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(p.monitoringProgress != 3 ? "assets/icon_bad.png" : life.lifeIcon, height: 48,),
                        const SizedBox(height: 7),
                        H12(
                          text: p.monitoringProgress != 3 ? "결과가없어요" : life.lifeText,
                          color: p.monitoringProgress != 3 ? AppColor_Red : changeColor(p.lifestyle!.status!),
                          weight: FW.medium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: " 모니터링을 ",
                              style: AppTextStyle.PD(
                                AppColor_BlackText,
                                16,
                                weight: FW.semi_bold,
                              )),
                      TextSpan(
                          text: p.monitoringProgress != 3? "시작": "완료",
                          style:
                              AppTextStyle.PD(AppColor_Primary, 16, weight: FW.bold)),
                      TextSpan(
                          text: p.monitoringProgress != 3? "해볼까요?": "했어요!",
                          style: AppTextStyle.PD(
                            AppColor_BlackText,
                            16,
                            weight: FW.semi_bold,
                          )),
                    ])),
                    const SizedBox(height: 15),
                    H14(
                      text: p.monitoringProgress != 3
                          ? "현재 개월 수에 맞는 모니터링을 해야할 시기가 지났어요"
                          : "모니터링 결과를 통해 우리 아이 발달을 확인하세요",
                      weight: FW.regular,
                      maxLine: 3,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 10,),
                    Visibility(
                        visible: p.monitoringProgress == 3,
                        child: H12(
                          text: "본 모니터링 결과는 의학적인 진단을 의미하지는 않으며 경우에 따라 전문의의 진료가 필요합니다.",
                          maxLine: 2,
                          align: TextAlign.left,
                          weight: FW.medium,
                          color: AppColor_GrayText,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: MainTextButton(
                  text: p.monitoringProgress != 3 ?"모니터링 시작하기":"모니터링 결과보기",
                  style: AppTextStyle.PD(
                      Colors.white, 16,
                      weight: FW.medium),
                  width: 185,
                  height: 40,
                  radius: 6,
                  onPressed: () {
                    if (p.monitoringProgress! == 3) {
                      Navigator.push(context, SlideRightTransRoute(
                          builder: (context) => MonitorReport1(),
                      ));
                    } else if (p.monitoringProgress! == 0) {
                      Navigator.push(context, SlideRightTransRoute(
                        builder: (context) => MonitoringTestForm(type: p.monitoringProgress!),
                          ));
                    } else {
                      showNewDialog(context,p);
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<bool?> showNewDialog(BuildContext context, MonitoringProfileDto p) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("모니터링 계속하기"),
          content: const Text("지난 기록이 있습니다.\n계속하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("아니오"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, SlideRightTransRoute(builder: (context) =>
                    MonitoringTestForm(type: 0),));
              },
            ),
            TextButton(
              child: Text("예"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, SlideRightTransRoute(builder: (context) =>
                    MonitoringTestForm(type: p.monitoringProgress!),));
              },
            ),
          ],
        );
      },
    );
  }

  Widget monitor2(MonitoringProfileDto p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            H18(text: "우아 성장 노트"),
            InkWell(
              onTap: () {
                Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringResult2()));
              },
              child: H14(text: "지난기록", weight: FW.regular,),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
              color: AppColor_White,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: AppColor_Light_Gray,
                  blurRadius: 5.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                )
              ]),
          child: Column(
            children: [
              Container(
                height: 170,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 18),
                        InkWell(
                          //onTap: onSelectPhoto,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: (dicHomeDataInfo == null ||
                                      dicHomeDataInfo!.profileImgUrl!.isEmpty) ||
                                      dicHomeDataInfo!.profileImgUrl!
                                          .contains("img_photo_default"),
                                  child: Center(
                                    child: RoundContainer(
                                      width: 100.0,
                                      height: 100.0,
                                      bgColor: Colors.white,
                                      child: Center(
                                        child: Image.asset(
                                            (dicHomeDataInfo == null ||
                                                dicHomeDataInfo!.gender == 1)
                                                ? 'assets/ic_default_male.png'
                                                : 'assets/ic_default_female.png',
                                            width: 45),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: dicHomeDataInfo != null &&
                                      dicHomeDataInfo!.profileImgUrl!.isNotEmpty &&
                                      !dicHomeDataInfo!.profileImgUrl!
                                          .contains("img_photo_default"),
                                  child: ExtendedImage.network(
                                    dicHomeDataInfo == null
                                        ? ""
                                        : dicHomeDataInfo!.profileImgUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    cache: true,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(
                                        'assets/add_circle_black_24dp.png',
                                        width: 22),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.gender == 1)
                                    ? 'assets/ic_male.png'
                                    : 'assets/ic_female.png',
                                width: 15),
                            const SizedBox(width: 2),
                            H18(
                              text: dicHomeDataInfo == null
                                  ? ""
                                  : dicHomeDataInfo!.name!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        H16(
                            text: dicHomeDataInfo == null
                                ? "0"
                                : dicHomeDataInfo!.age.toString() +
                                LanguageService.trans('sae'),
                            weight: FW.regular),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      // height: 130,
                      height: 100,
                      width: MediaQuery.of(context).size.width - 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     H16(text: "영양", weight: FW.regular,),
                          //     H16(text: food, color: AppColor_Primary,),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H16(text: "수면", weight: FW.regular,),
                              H16(text: p.sleep!.status! =="Y" ? "부족": p.sleep!.status! =="N" ? "-"
                              : "충분", color: changeColor(p.sleep!.status!),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H16(text: "체온", weight: FW.regular,),
                              Row(
                                children: [
                                  H16(
                                    text: p.temperature!.temperature == null ? "-" : p.temperature!.temperature.toString(),
                                    color: changeColor(p.temperature!.status!),),
                                  H16(text: " °C"),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H16(text: "질병", weight: FW.regular,),
                              Row(
                                children: [
                                  H16(text: "처방전 + "),
                                  H16(text: p.symptomList!.length.toString(), color: AppColor_Primary,),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                child: H16(
                  text: "아이의 건강한 성장을 위해 성장 기록을 시작해 볼까요?",
                  weight: FW.regular,
                  maxLine: 3,
                  align: TextAlign.start,
                ),

              ),
              const SizedBox(height: 30),
              Center(
                child: MainTextButton(
                  text: p.todayNote == false ? "성장 노트 기록하기" : "지난 기록 보기",
                  style: AppTextStyle.PD(
                      Colors.white, 16,
                      weight: FW.medium),
                  width: 185,
                  height: 40,
                  radius: 6,
                  onPressed: () {
                    if(p.todayNote == false) {
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringMain2(),));
                    } else {
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringResult2(),));
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<GlobalProvider>(context, listen: false).profile;
    getNoteInfo();
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                monitor1(p!),
                const SizedBox(height: 55),
                monitor2(p),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ));
  }
}
