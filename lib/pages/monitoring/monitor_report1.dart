import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitor_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/lifestyle_report.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_test_result.dart';
import 'package:sprintf/sprintf.dart';

class MonitorReport1 extends StatefulWidget {
  const MonitorReport1({Key? key}) : super(key: key);

  @override
  State<MonitorReport1> createState() => _MonitorReport1State();
}

class _MonitorReport1State extends BaseState<MonitorReport1> {
// List<MonitoringDto> monitoringList = [];
  // static const platform = MethodChannel('doctor.flutter.dev');
  final HttpService httpService = HttpService();
  bool isLast = false;
  int subTabIndex = 0;
  int tabIndex = 0;
  List<MonitorListDto>? arrMonitorList = [];

  List<String> CATEGORYS = ["발달영역", "생활습관", "신체"];
  List<String> subCategory = ["대근육", "소근육", "인지", "언어", "사회성","자조"];
  List<String> subCategoryImg = ["monitor_icon1.png","monitor_icon2.png","monitor_icon3.png","monitor_icon4.png","monitor_icon5.png","monitor_icon6.png",];

  //test data
  HomeGraphLifeStyleDto? dicHomeGraphLifeStyleInfo;


  @override
  void initState() {
    super.initState();
    dicHomeGraphLifeStyleInfo = null;
    getHomeGraphLifeStyle();

  }

  //홈 그래프 생활습관 얻기
  Future<void> getHomeGraphLifeStyle() async {
    setState(() {
      isLoading = true;
    });

    String curDate = sprintf("%04d-%02d", [2022, 11]);
    Future<HomeGraphLifeStyleResModel> info = httpService.homeGraphLifeStyle1(curDate);
    info.then((HomeGraphLifeStyleResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        setState(() {
          dicHomeGraphLifeStyleInfo = value.data!;
        });
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          // Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }


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

  Widget _getTiles1(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          tabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: tabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
        child: Center(
          child: H14(
            text: CATEGORYS[index],
            weight: FW.bold,
            align: TextAlign.center,
            color: tabIndex == index ? Colors.white : AppColor_BlackText.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget bodyTile(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          subTabIndex = index;
        });
      },
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 90,
            margin: const EdgeInsets.fromLTRB(10,50,10,10),
            decoration: const BoxDecoration(
                color: AppColor_White,
                borderRadius: BorderRadius.all(
                    Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 3),
                    color: AppColor_Gray,
                    blurRadius: 3.0, // soften the shadow
                    spreadRadius: 4.0, //extend the shadow
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                H16(text: subCategory[index]),
                const SizedBox(height: 5),
                Container(
                  width: 50,
                  height: 20,
                  color: AppColor_Height,
                  child: Center(
                    child: Text("68",
                      style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
              child: Image.asset("assets/" + subCategoryImg[index],width: 80,),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if(tabIndex == 0) {
      return Column(
        children: [
          SizedBox(
            height: 360,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return bodyTile(index);
              },
              itemCount: subCategory.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0
              ),
            ),
          ),
          const SizedBox(height: 30),
          H20(text: "${subCategory[subTabIndex]} 발달 점수"),
          // ReportArea(),
          RangeShow(
            isInspect: true,
            start: "",
            end: "",
            rate: 98,
            unit: "",
            color: AppColor_Primary,
            cur_value: 98,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: AppColor_Light_Gray),
            padding: const EdgeInsets.only(
                left: 30, right: 30, top: 20, bottom: 20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H16(text: "ㅁㄴㅇㅁㄴㅇㅁㄴㅇ"),
                Text(
                  "우리 아이는 대근육 발달이 다소 늦은 편이에요. 대근육을 고르게 사용하는 여러 신체 활동을 꾸준히 한다면 더욱 잘 성장할 수 있어요.",
                  style: TextStyle(
                      color: AppColor_GrayText,
                      fontSize: 16,
                      height: 1.5
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Center(
            child: MainTextButton(
              text: "카카오톡으로 상담하기",
              style: AppTextStyle.PD(
                  Colors.white, 16,
                  weight: FW.medium),
              width: 200,
              height: 40,
              radius: 20,
              onPressed: () {
                // Navigator.push(context, SlideRightTransRoute(builder: (context) => ,));
              },
            ),
          ),
        ],
      );
    } else if (tabIndex == 1){
      return MonitoringTestResult();
    } else if (tabIndex == 2) {
      return Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: LifestyleReport(data: dicHomeGraphLifeStyleInfo!, result: 1));;
    }
    return CircularProgressIndicator();
  }


  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SimpleHeader(
                title: "",
                onBackPressed: onBackPressed,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H20(text: "우아 발달 모니터링 리포트"),
                        const SizedBox(height: 30),
                        //category
                        SizedBox(
                          // width: MediaQuery.of(context).size.width - 64,
                          height: 70,
                          child: GridView.builder(
                            // scrollDirection: Axis.horizontal,
                            // shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return _getTiles1(index);
                            },
                            itemCount: CATEGORYS.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                            ),
                          ),
                        ),
                        //in body
                        _body(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
