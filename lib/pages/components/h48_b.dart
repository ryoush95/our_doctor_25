import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H48B extends StatelessWidget {
  final text;
  final color;

  const H48B({
    Key? key,
    this.text,
    this.color = AppColor_BlackText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.PD(color, 48),
    );
  }
}