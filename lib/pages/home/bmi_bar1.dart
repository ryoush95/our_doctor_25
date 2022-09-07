import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h32_b.dart';

class BMIBar1 extends StatefulWidget {
  BMIBar1({Key? key, required this.weight, this.res = 0, this.color = AppColor_Primary, this.text = "", this.subtext = ""}) : super(key: key);

  final int res;
  final Color color;
  final double weight;
  final String text;
  final String subtext;
  @override
  BMIBar1State createState() => BMIBar1State();
}

class BMIBar1State extends BaseState<BMIBar1> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var customPadding = 10.0;
    return Column(
      children: [
        Stack(
          children: [
            Center(child: Image.asset('assets/height_bar_' + widget.res.toString() + '.png', width: screenSize.width - 120)),
            SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    H16(text: widget.text, weight: FW.regular, maxLine: 2),
                    const SizedBox(height: 3),
                    H16(text: widget.subtext, weight: FW.regular, color: AppColor_GrayText),
                    const SizedBox(height: 8),
                    H32B(text: widget.weight.toStringAsFixed(1) /*+ "cm"*/, color: widget.color),
                  ],
                ))
          ],
        )
      ],
    );
  }

  int getWeight() {
    return 25;
  }
}
