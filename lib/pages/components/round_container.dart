import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class RoundContainer extends StatelessWidget {
  final Widget? child;
  final Color? bgColor;
  final double radius;
  final double? width;
  final double? height;
  RoundContainer({
    Key? key,
    this.child,
    this.bgColor = AppColor_Light_Gray,
    this.radius = 24.0,
    this.width = double.infinity,
    this.height = double.infinity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: child,
    );
  }
}