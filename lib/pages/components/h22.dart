import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H22 extends StatelessWidget {
  final text;
  final height;
  final FW? weight;
  final color;
  final align;
  final maxLine;
  const H22({
    Key? key,
    this.text,
    this.color = AppColor_BlackText,
    this.height = 1.0,
    this.weight = FW.bold,
    this.align = TextAlign.center,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 22, height: height, weight: weight,),
      textAlign: align,
      maxLines: maxLine,
    );
  }
}