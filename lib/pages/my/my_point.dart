import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/live_res_model.dart';
import 'package:ourdoctor/models/point_his_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h28.dart';
import 'package:ourdoctor/pages/components/point_list_item.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class MyPointPage extends StatefulWidget {
  const MyPointPage({Key? key}) : super(key: key);

  @override
  MyPointPageState createState() => MyPointPageState();
}

class MyPointPageState extends BaseState<MyPointPage> {
  List<PointHisDto> pointList = [];
  ScrollController controller = ScrollController();
  final HttpService httpService = HttpService();
  bool isLast = false;
  int page = 0;
  String myPoint = "";

  @override
  void initState() {
    controller = ScrollController()..addListener(onScroll);
    super.initState();

    getLiveInfo();
    loadPointHistory();
  }

  void onScroll() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        page = page + 1;
        loadPointHistory();
      }
    }
  }

  Future<void> refresh() async {
    page = 0;
    loadPointHistory();
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void loadPointHistory() {
    setState(() {
      isLoading = true;
    });

    Future<PointHisResModel> info = httpService.pointHistory(page);
    info.then((PointHisResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (page == 0) {
          pointList.clear();
        }
        pointList.addAll(value.data!.list!);
        isLast = value.data!.isLast!;
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

  //라이브 데이터 얻기
  Future<void> getLiveInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<LiveResModel> info = httpService.liveInfo();
    info.then((LiveResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        myPoint = value.data!.point!;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleHeader(
              title: "우아포인트",
              onBackPressed: onBackPressed,
            ),
            const SizedBox(height: 31),
            //email
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: H14(
                text: "내 우아포인트",
                weight: FW.medium,
                align: TextAlign.start,
                color: AppColor_BlackText.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 13),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  H28(
                    text: ValidPrice(myPoint),
                    weight: FW.bold,
                    align: TextAlign.start,
                    color: AppColor_BlackText,
                  ),
                  H20(
                    text: " " + LanguageService.trans("point"),
                    weight: FW.bold,
                    align: TextAlign.start,
                    color: AppColor_BlackText,
                  ),
                  //const SizedBox(width: 150),
                  Expanded(child: Container()),
                  Image.asset('assets/ic_ua_point.png', width: 25, height: 25),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: AppColor_BlackText,
                ),
              ),
            ),
            const SizedBox(height: 50),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
              child: H18(
                text: "이용 내역",
                weight: FW.bold,
                align: TextAlign.start,
                color: AppColor_BlackText,
              ),
            ),
            Expanded(
              //child: Container(
              //height: double.infinity,
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    return PointHistoryItem(
                      item: pointList[index],
                    );
                  },
                  itemCount: pointList.length,
                ),
              ),
            ),
            //),
          ],
        ));
  }
}
