import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';

class MainTextButton extends StatelessWidget {
  final text;
  final onPressed;
  final style;
  double? width;
  double? height;
  Color? backgroundColor;
  Color? borderColor;
  Color? disableBackground;
  Color? textColor;
  bool? showBorder;
  double? radius;
  bool? disable;

  MainTextButton({
    Key? key,
    this.text,
    this.onPressed,
    this.style,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.disableBackground,
    this.showBorder,
    this.radius,
    this.disable,
  }) : super(key: key) {
    this.width ??= double.infinity;
    this.height ??= 53;
    this.showBorder ??= false;
    this.backgroundColor ??= AppColor_Primary;
    this.disableBackground ??= AppColor_Primary;
    this.radius ??= 10;
    this.disable ??= false;
    this.borderColor ??= AppColor_BlackText;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            border: showBorder == false
                ? Border.all(color: Colors.transparent)
                : Border.all(width: 1, color: borderColor!),
            borderRadius: BorderRadius.circular(radius!),
            color: disable == null || !disable! ? backgroundColor: disableBackground),
        child: Center(
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
