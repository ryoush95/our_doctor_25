import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/radar_chart.dart';

class MonitoringFoodResult extends StatefulWidget {
  const MonitoringFoodResult({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodResult> createState() => _MonitoringFoodResultState();
}

class _MonitoringFoodResultState extends State<MonitoringFoodResult> {
  List<String> cateList = ["종합", "식단", "식습관"];
  int cateIndex = 0;

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    print("back");
    return true;
  }

  Widget _getTiles1(int index) {
    double mWidth = (MediaQuery.of(context).size.width) / cateList.length;
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            cateIndex = index;
          });
        },
        child: SizedBox(
          width: mWidth,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: H14(
                  text: cateList[index],
                  weight: FW.medium,
                  align: TextAlign.center,
                  maxLine: 2,
                  color: cateIndex == index ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                ),
              ),
              Positioned(
                child: SizedBox(
                    width: mWidth,
                    height: 2,
                    child: Container(
                      width: 80,
                      height: MediaQuery.of(context).size.width,
                      color: cateIndex == index ? AppColor_Primary : AppColor_BlackText.withOpacity(0.1),
                    )),
                bottom: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget monitor1() {
    return  SizedBox(
        height: 700,child: RadarChartWidget());
  }

  Widget monitor2() {
    return  SizedBox(
        height: 700,child: RadarChartWidget());
  }

  Widget monitor3() {
    return  SizedBox();
  }

  Widget _body() {
    if (cateIndex == 0) {
      return monitor1();
    } else if (cateIndex == 1) {
      return monitor2();
    } else {
      return monitor3();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      onBack: onBackPressed,
      child: Column(
        children: [
          SimpleHeader(title:"영양모니터링",onBackPressed: onBackPressed,),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _getTiles1(index);
              },
              itemCount: cateList.length,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(child: _body()),
        ],
      ),
    );
  }
}
