import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H18 extends StatelessWidget {
  final String text;
  final color;
  final FW? weight;
  final TextAlign? align;
  final height;
  final maxLine;
  H18({
    Key? key,
    required this.text,
    this.color = AppColor_BlackText,
    this.weight = FW.bold,
    this.align = TextAlign.center,
    this.height = 1.0,
    this.maxLine
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 18, weight: weight, height: height),
      textAlign: align,
      maxLines: maxLine ?? 1,
    );
  }
}