import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/product_show.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/community_area.dart';
import 'package:ourdoctor/pages/home/developmental_class_area.dart';
import 'package:ourdoctor/pages/home/growth_store_area.dart';
import 'package:ourdoctor/pages/home/news_area.dart';
import 'package:ourdoctor/pages/home/report_area.dart';
import 'package:ourdoctor/pages/home/review_dialog.dart';
import 'package:ourdoctor/pages/home/school_area.dart';
import 'package:ourdoctor/pages/home/top_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

import 'circular_progress.dart';
import 'community_area_monitor.dart';
import 'info_area.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends BaseState<HomeFragment> {
  final HttpService httpService = HttpService();
  HomeMonitorDto? dicHomeDataInfo;
  int curCategory = 0; //홈, 모니터링
  int category = 1; //성장,발달
  List<PdtLikeDto>? arrLikeList = [];
  List<PdtLikeDto>? arrNewList = [];
  final tooltip = GlobalKey();

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: LanguageService.trans("report_guie"),
        textStyle: AppTextStyle.PD(AppColor_BlackText, 12),
        height: 87,
        width: 200,
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        borderRadius: BorderRadius.circular(10.0),
        onDismiss: () {
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
    getHomeDataInfo();
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
            () =>
        {
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
      category = index;
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

  //홈케어 홈 데이터 얻기
  Future<void> getHomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeCareDataResModel> info =
    httpService.homecareDataInfo(category == 0 ? "GROWTH" : "DEVELOPMENT");
    info.then((HomeCareDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrLikeList = value.data!.pdtLikeList;
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

                   /* const SizedBox(height: 30),
                    NewsArea(curCategory: 0),*/
                    const SizedBox(height: 30),
                    SchoolArea(curCategory: 2),//교육
                    const SizedBox(height: 30),
                    CommunityArea(curCategory: 0), //우아팁
                    const SizedBox(height: 30),
                    GrowthStoreArea(curCategory: 0),
                    const SizedBox(height: 30),
                    ProductShow(
                        category: category,
                        title: LanguageService.trans("발달클래스 홈케어"),
                        list: arrLikeList),
                    const SizedBox(height: 30),


                  ],
                ),
              ),

            ),
          ],
        ));
  }

}


