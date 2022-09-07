import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';

class RoundInput extends StatelessWidget {
  final controller;
  final keyboardType;
  final textInputAction;
  final onEditingComplete;
  final placeholder;
  final onChanged;
  final borderColor;
  final hintColor;
  bool? suffix;
  bool? isSecure;
  int? maxLine;
  int? maxLength;
  double? height;

  RoundInput(
      {Key? key,
      this.controller,
      this.keyboardType,
      this.placeholder,
      this.textInputAction,
      this.onEditingComplete,
      this.onChanged,
      this.suffix,
      this.borderColor,
      this.hintColor,
      this.maxLine,
      this.maxLength,
      this.height,
      this.isSecure})
      : super(key: key) {
    suffix ??= false;
    isSecure ??= false;
    maxLine ??= 1;
    height ??= 40;
    maxLength ??= -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: borderColor ?? AppColor_BlackText)),
      child: Center(
        child: TextField(
          style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
          maxLength: maxLength,
          controller: controller,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          obscureText: isSecure!,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: textInputAction,
          maxLines: maxLine,
          decoration: InputDecoration(
            counterText: "",
            suffixIcon: suffix != false
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, color: AppColor_Icon),
                    onPressed: () => {controller.text = ""},
                  )
                : null,
            hintText: placeholder,
            hintStyle: AppTextStyle.PD(hintColor ?? AppColor_Hint, 16, weight: FW.medium),
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
