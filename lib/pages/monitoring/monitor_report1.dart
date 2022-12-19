import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/models/monitor_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/home/report_area.dart';

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
  int page = 0;
  int curCategory = 0;
  List<MonitorListDto>? arrMonitorList = [];

  List<String> CATEGORYS = ["발달영역", "생활습관", "신체"];
  List<String> subCategory = ["대근육", "소근육", "인지", "언어", "사회성","자조"];
  List<String> subCategoryImg = ["monitor_icon1.png","monitor_icon2.png","monitor_icon3.png","monitor_icon4.png","monitor_icon5.png","monitor_icon6.png",];

  int nTabIndex = 0;

  @override
  void initState() {
    super.initState();

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
          nTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: nTabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
        child: Center(
          child: H14(
            text: CATEGORYS[index],
            weight: FW.bold,
            align: TextAlign.center,
            color: nTabIndex == index ? Colors.white : AppColor_BlackText.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget bodyTile(int index) {
    return Container(
      width: 80,
      height: 100,
      margin: EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AppColor_White,
          borderRadius: BorderRadius.all(
              Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              offset: Offset(3, 3),
              color: AppColor_Gray,
              blurRadius: 3.0, // soften the shadow
              spreadRadius: 4.0, //extend the shadow
            )
          ]),
      child: Column(
        children: [
          Image.asset("assets/" + subCategoryImg[index]),
          Text(subCategory[index]),
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H20(text: "우아 발달 모니터링 리포트"),
                  const SizedBox(height: 30),
                  Container(
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
                  Container(
                    height: 360,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return bodyTile(index);
                      },
                      itemCount: subCategory.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1 / 1.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  H20(text: "언어 발달 점수"),
                  // ReportArea(),
                  RangeShow(
                      isInspect: true,
                      start: "",
                      end: "",
                      rate: 20,
                      unit: "",
                      color: AppColor_Primary,
                      cur_value: 20,
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
              ),
            ),
          ),
        ));
  }
}
