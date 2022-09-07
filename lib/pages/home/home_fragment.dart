import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/community_area.dart';
import 'package:ourdoctor/pages/home/developmental_class_area.dart';
import 'package:ourdoctor/pages/home/growth_store_area.dart';
import 'package:ourdoctor/pages/home/report_area.dart';
import 'package:ourdoctor/pages/home/review_dialog.dart';
import 'package:ourdoctor/pages/home/top_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

import 'circular_progress.dart';
import 'info_area.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends BaseState<HomeFragment> {
  final HttpService httpService = HttpService();
  HomeMonitorDto? dicHomeDataInfo;
  int curCategory = 0;
  int page = 0;

  final tooltip = GlobalKey();

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"),
        textStyle: AppTextStyle.PD(AppColor_BlackText, 12),
        height: 87, width: 200,
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
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
    // if (getLeffDay() == 0 && isFirstApp) {
    //   showReviewDialog();
    // }
    print(gUserInfo!.accessToken);
    // getMonitor2HomeDataInfo();
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

  void onChooseCategory(int index) {
    setState(() {
      curCategory = index;
    });
  }

  // Network functions
  //////////////////////////////////
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopArea(name: gSelChildInfo!.name!, type: 0),
                    const SizedBox(height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 32),
                        H20(text: LanguageService.trans('compre_dev_score')),
                      ],
                    ),
                    CircularProgress(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              Container(
                                // width: 110,
                                child: H20(text: LanguageService.trans('development_report'), maxLine: 2, align: TextAlign.start),
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
                    ReportArea(type: curCategory),
                    const SizedBox(height: 60),
                    GrowthStoreArea(curCategory: 0),
                    const SizedBox(height: 60),
                    DevelopmentalClassArea(curCategory: 0),
                    const SizedBox(height: 30),
                    CommunityArea(curCategory: 0),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
