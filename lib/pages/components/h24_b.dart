import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H24B extends StatelessWidget {
  final text;
  final color;
  final height;
  final maxLine;
  final TextAlign? align;
  H24B({
    Key? key,
    this.text,
    this.color = AppColor_BlackText,
    this.height = 1.0,
    this.maxLine,
    this.align = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 24, height: height),
      maxLines: maxLine ?? 1,
      textAlign: align,
    );
  }
}