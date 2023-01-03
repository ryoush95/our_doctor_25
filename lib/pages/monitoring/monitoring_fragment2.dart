import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/final_result_res_model.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/home/circular_progress2.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitor_report1.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_v2.dart';

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


  @override
  void initState(){

    getMonitor2HomeDataInfo();
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

  Widget monitor1() {
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
                  CircularProgress2(type: 1, subType: curCategory1 = 0),
                  Container(
                    height: 90,
                    width: 90,
                    margin: const EdgeInsets.all(5),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(side: BorderSide(color: AppColor_Primary, width: 6)),
                    ),
                    child: Container(
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
                      ),
                      child: Center(
                          child: Column(
                            children: [
                              Image.asset("assets/icon_good.png",height: 40,),
                              const SizedBox(height: 7),
                              H16(
                                text: "좋아요",
                              ),
                            ],
                          ),
                      ),
                    ),
                  ),
                  CircularProgress2(type: 2, subType: curCategory1 = 1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  H16(text: "발달영역", align: TextAlign.center),
                  H16(text: "생활습관", align: TextAlign.center),
                  H16(text: "신체성장", align: TextAlign.center),
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
                          text: "발달",
                          style:
                              AppTextStyle.PD(AppColor_Primary, 16, weight: FW.bold)),
                      TextSpan(
                          text: " 모니터링을 한지 42일 지났어요.",
                          style: AppTextStyle.PD(
                            AppColor_BlackText,
                            16,
                            weight: FW.semi_bold,
                          )),
                    ])),
                    const SizedBox(height: 15),
                    H16(
                      text: "현재 개월 수에 맞는 모니터링을 해야할 시기가 지났어요\n모니터링을 시작해 볼까요?",
                      weight: FW.regular,
                      maxLine: 3,
                      align: TextAlign.start,
                    ),
                  ],
                ),

              ),
              const SizedBox(height: 15),
              Center(
                child: MainTextButton(
                  text: "모니터링 시작하기",
                  style: AppTextStyle.PD(
                      Colors.white, 16,
                      weight: FW.medium),
                  width: 185,
                  height: 40,
                  radius: 6,
                  onPressed: () {
                    Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitorReport1(),));
                    // Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringTestForm(),));
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget monitor2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H18(text: "우아 생활 모니터링"),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          height: 400,
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
                      height: 130,
                      width: MediaQuery.of(context).size.width - 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H16(text: "영양", weight: FW.regular,),
                              H16(text: "충분",color: AppColor_Primary,),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H16(text: "수면", weight: FW.regular,),
                              H16(text: "충분",color: AppColor_Primary,),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H16(text: "체온", weight: FW.regular,),
                              Row(
                                children: [
                                  H16(text: "충분",color: AppColor_Primary,),
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
                                  H16(text: "처방전+ "),
                                  H16(text: "0",color: AppColor_Primary,),
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
              Spacer(),
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "발달",
                              style:
                              AppTextStyle.PD(AppColor_Primary, 16, weight: FW.bold)),
                          TextSpan(
                              text: " 모니터링 기록을 완료했어요",
                              style: AppTextStyle.PD(
                                AppColor_BlackText,
                                16,
                                weight: FW.semi_bold,
                              )),
                        ])),
                    const SizedBox(height: 15),
                    H16(
                      text: "현재 개월 수에 맞는 모니터링을 해야할 시기가 지났어요\n모니터링을 시작해 볼까요?",
                      weight: FW.regular,
                      maxLine: 3,
                      align: TextAlign.start,
                    ),
                  ],
                ),

              ),
              const SizedBox(height: 15),
              Center(
                child: MainTextButton(
                  text: "모니터링 시작하기",
                  style: AppTextStyle.PD(
                      Colors.white, 16,
                      weight: FW.medium),
                  width: 185,
                  height: 40,
                  radius: 6,
                  onPressed: () {
                    Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringMain2(),));
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
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                monitor1(),
                const SizedBox(height: 55),
                monitor2(),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ));
  }
}
