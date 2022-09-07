import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/final_result_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_floating_button.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/community_area.dart';
import 'package:ourdoctor/pages/home/report_area.dart';
import 'package:ourdoctor/pages/home/review_dialog.dart';
import 'package:ourdoctor/pages/home/top_area.dart';
import 'package:ourdoctor/pages/home/woo_story_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';

import 'circular_progress.dart';
import 'info_area.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends BaseState<HomeFragment> {
  static const platform = const MethodChannel('doctor.flutter.dev');
  final HttpService httpService = HttpService();
  FinalresultDto? dicFinalResultInfo;

  @override
  void initState() {
    super.initState();
    startChannel();
    if (getLeffDay() == 0 && isFirstApp) {
      showReviewDialog();
    }
    getFinalResultInfo();
    isFirstApp = false;
  }

  void showReviewDialog() async {
    Future.delayed(
        const Duration(seconds: 1),
            () => {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const ReviewDialog();
              })
        });
  }

  Future<void> goChatting() async {
    try {
      final int result = await platform.invokeMethod('talk', {"uid": gUserInfo!.id, "name": gUserInfo!.name});
    } on PlatformException catch (e) {
      showToast("'${e.message}'.");
    }
  }

  Future<void> startChannel() async {
    String batteryLevel;
    try {
      String result = await platform.invokeMethod('startchanneltalk');
      print(result);
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
  }

  // Network functions
  //////////////////////////////////
  //최종 모니터 정보 얻기
  Future<void> getFinalResultInfo() async {
    // setState(() {
    //   isLoading = true;
    // });

    Future<FinalResultResModel> info = httpService.finalResult();
    info.then((FinalResultResModel value) async {
      // setState(() {
      //   isLoading = false;
      // });
      if (value.result == 0) {
        dicFinalResultInfo = value.data!;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopArea(name: gSelChildInfo!.name!),
                    const SizedBox(height: 30),
                    InfoArea(),
                    const SizedBox(height: 56),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        H20(text: LanguageService.trans('home_treat_report')),
                      ],
                    ),
                    CircularProgress(),
                    ReportArea(),
                    const SizedBox(height: 40),
                    CommunityArea(),
                    const SizedBox(height: 40),
                    WooStoryArea(),
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
