import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class HeaderText extends StatelessWidget {
  final text;
  final color;
  final height;
  final maxLine;
  final TextAlign? align;
  final weight;
  HeaderText({
    Key? key,
    required this.text,
    this.color = AppColor_BlackText,
    this.height = 1.3,
    this.maxLine,
    this.align = TextAlign.start,
    this.weight = FW.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 18, height: height, weight: weight),
      maxLines: maxLine ?? 2,
      textAlign: align,
    );
  }
}