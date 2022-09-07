import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H20 extends StatelessWidget {
  final text;
  final color;
  final weight;
  final TextAlign? align;
  final height;
  final maxLine;
  H20({
    Key? key,
    this.text,
    this.color = AppColor_BlackText,
    this.weight = FW.bold, // or 'semi_bold'
    this.align = TextAlign.center,
    this.height = 1.0,
    this.maxLine
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 20, weight: weight, height: height),
      textAlign: align,
      maxLines: maxLine ?? 1,
    );
  }
}