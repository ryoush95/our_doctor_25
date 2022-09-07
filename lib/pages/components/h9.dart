import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H9 extends StatelessWidget {
  final String text;
  final color;
  final height;
  H9({
    Key? key,
    required this.text,
    this.color = AppColor_BlackText,
    this.height = 1.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 9, weight: FW.medium, height: height),
    );
  }
}