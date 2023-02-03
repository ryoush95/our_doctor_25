import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/models/monitoring/temp_graph_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/line_chart_temp.dart';
import 'package:ourdoctor/pages/components/price_point.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:sprintf/sprintf.dart';

class LifestyleLineChart2 extends StatefulWidget {
  LifestyleLineChart2({Key? key, required this.data}) : super(key: key);

  final Data data;

  @override
  LifestyleLineChart2State createState() => LifestyleLineChart2State();
}

class LifestyleLineChart2State extends BaseState<LifestyleLineChart2> {
  DateTime now = DateTime.now();
  List<PricePoint> tempList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // for (var i = 0; i <= DateTime(now.year, now.month + 1, 0).day - 1; i++) {
    //   tempList.add(PricePoint(x: i.toDouble(), y: 0));
    // }

    for (var element in widget.data.graphTemperature!) {
      String s = element.date!.substring(element.date!.length-2, element.date!.length);
      tempList.add(PricePoint(x: double.parse(s), y: element.temperature!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundContainer(
        height: 260,
        radius: 30,
        bgColor: AppColor_Light_Gray,
        child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Image.asset('assets/home_temp.png', height: 24,width: 24,),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.start,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: '체온 기록',
                                    style: AppTextStyle.PD(
                                      AppColor_BlackText,
                                      16,
                                    )),
                              ]),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        H18(text: widget.data.avgTemperature! + " °C", color: AppColor_BlackText, weight: FW.semi_bold),
                        const SizedBox(height: 5),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    color: Colors.white,
                    // 체온 그래프
                    child: LineChartTemp(points: tempList, points2 : pricePoints2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 30,),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColor_Green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    H12(
                      text: "정상 체온",
                      weight: FW.medium,
                      height: 1.5,
                      color: AppColor_Input_Title,
                    ),
                  ],
                ),
              ],
            )));
  }

}
