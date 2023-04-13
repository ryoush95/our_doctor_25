import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:sprintf/sprintf.dart';

class RangeShow extends StatefulWidget {
  RangeShow(
      {Key? key,
      required this.start,
      required this.end,
      required this.rate,
      required this.unit,
      required this.cur_value,
      this.title = "",
      this.color = AppColor_Primary,
      this.isInspect = false})
      : super(key: key);

  final String start;
  final String end;
  final double rate;
  final String unit;
  final double cur_value;
  final String title;
  final Color color;
  final bool isInspect;

  @override
  RangeShowState createState() => RangeShowState();
}

class RangeShowState extends BaseState<RangeShow> {
  DateTime now = DateTime.now();

  // double rate = 0;
  @override
  void initState() {
    super.initState();
    // rate = (widget.cur_value - widget.start) / (widget.end - widget.start);
    // rate = rate < 0.01 ? 0.01 : rate;
    // rate = rate > 1 ? 1 : rate;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var customPadding = 40.0;
    var slideWidth = screenSize.width - 60 - customPadding * 2;
    var customTop = 85.0;
    return Container(
        height: 130,
        child: Stack(
          children: [
            Positioned(
              top: customTop,
              left: customPadding,
              child: Container(
                width: slideWidth,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColor_Light_Gray,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
            Positioned(
              top: customTop,
              left: customPadding,
              child: Container(
                width: slideWidth * (widget.rate / 100),
                height: 10,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
            Positioned(
              left: customPadding + slideWidth * (widget.rate / 100) - 10,
              top: customTop - 5,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            Positioned(
              left: customPadding/2,
              top: customTop + 20,
              child: H14(
                text: sprintf("%s%s", [widget.start, widget.unit]),
                color: AppColor_Table_DateTime,
                weight: FW.semi_bold,
              ),
            ),
            Positioned(
                right: customPadding/2,
                top: customTop + 20,
                child: H14(
                  text: sprintf("%s%s", [widget.end, widget.unit]),
                  color: AppColor_Table_DateTime,
                  weight: FW.semi_bold,
                )),
            Visibility(
              visible: !widget.isInspect,
              child: Positioned(
                  left: customPadding + slideWidth * (widget.rate / 100) - 40,
                  top: customTop - 25,
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: H14(
                      text: widget.cur_value.toStringAsFixed(1) + widget.unit,
                      color: widget.color,
                      weight: FW.semi_bold,
                    ),
                  )),
            ),
            Positioned(
                left: customPadding + slideWidth * (widget.rate / 100) - 40,
                top: !widget.isInspect ? customTop - 90 : customTop - 70,
                child: Image.asset('assets/Path 12612.png', width: 80)),
            Positioned(
                left: customPadding + slideWidth * (widget.rate / 100) - 40,
                top: !widget.isInspect ? customTop - 73 : customTop - 48,
                child: Container(
                  width: 80,
                  height: 30,
                  alignment: Alignment.center,
                  child: H18(
                    text: !widget.isInspect ? sprintf("%.0f%", [widget.rate, widget.unit]) : "${widget.cur_value.toInt()}점",
                    color: widget.color,
                    weight: FW.bold,
                  ),
                )),
            Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(height: 40),
              H22(text: widget.title, color: AppColor_Primary),
            ]))
          ],
        ));
  }

  int getWeight() {
    return 25;

    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    // String date = dateFormat.format(now);
    // int hour = now.hour;
    // for (int i = 0; i < widget.data.length; i++) {
    //   if (hour >= 12) {
    //     if (widget.data.elementAt(i).pm_time.contains(date)) {
    //       String data = widget.data.elementAt(i).afternoon_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   } else {
    //     if (widget.data.elementAt(i).am_time.contains(date)) {
    //       String data = widget.data.elementAt(i).morning_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   }
    // }
    // return "미측정";
  }

  String getCurTime() {
    int hour = now.hour;
    if (hour < 12) {
      return "오늘 오전";
    } else {
      return "오늘 오후";
    }
  }
}
