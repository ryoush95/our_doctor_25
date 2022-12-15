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
  final ScrollController _scrController = ScrollController();
  ScrollController scrollController = ScrollController();
  static const platform = MethodChannel('doctor.flutter.dev');
  final HttpService httpService = HttpService();
  bool isLast = false;
  int page = 0;
  int curCategory = 0;
  List<MonitorListDto>? arrMonitorList = [];

  List<String> CATEGORYS = ["발달영역", "생활습관", "신체"];
  List<String> subCategory = ["대근육", "소근육", "인지", "언어", "사회성","자조"];
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

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            controller: _scrController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H20(text: "우아 발달 모니터링 리포트"),
                  const SizedBox(height: 35),
                  Container(
                    width: MediaQuery.of(context).size.width - 64,
                    height: 80,
                    margin: const EdgeInsets.only(top: 16),
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
                          mainAxisSpacing: 10
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 64,
                    height: 80,
                    margin: const EdgeInsets.only(top: 16),
                    child: GridView.builder(
                      // scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Text(subCategory[index]);
                      },
                      itemCount: subCategory.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3 / 1,
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
                      color: AppColor_Height,
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
                          "Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), color: AppColor_Light_Gray), padding: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50), margin: const EdgeInsets.symmetric(horizontal: 30), child: PrevMonitoring());",
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
