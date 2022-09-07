import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class H16 extends StatelessWidget {
  final String text;
  final color;
  final FW? weight;
  final TextAlign? align;
  final height;
  final maxLine;
  final bool isEllipsis;
  final bool softWrap;

  H16({
    Key? key,
    required this.text,
    this.color = AppColor_BlackText,
    this.weight = FW.bold,
    this.align = TextAlign.center,
    this.height = 1.0,
    this.maxLine,
    this.isEllipsis = true,
    this.softWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: isEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
      style: AppTextStyle.PD(color, 16, weight: weight, height: height),
      textAlign: align,
      maxLines: maxLine ?? 1,
      softWrap: softWrap ? true : false,
    );
  }
}