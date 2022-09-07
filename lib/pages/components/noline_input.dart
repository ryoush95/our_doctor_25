import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class NolineInput extends StatelessWidget {
  final TextEditingController controller;
  final keyboardType;
  final textInputAction;
  final onEditingComplete;
  final placeholder;
  final onChanged;
  final borderColor;
  final hintColor;
  bool canClear;
  VoidCallback? onClear;
  bool? isSecure;
  int? maxLine;
  int? maxLength;
  double? height;
  final weight;
  final size;
  final textAlign;
  FocusNode? focus;

  NolineInput({
    Key? key, 
    required this.controller, 
    this.keyboardType, 
    this.placeholder, 
    this.textInputAction, 
    this.onEditingComplete, 
    this.onChanged, 
    this.borderColor, 
    this.hintColor,
    this.canClear = false,
    this.onClear,
    this.maxLine, 
    this.maxLength, 
    this.height, 
    this.weight, 
    this.size, 
    this.textAlign, 
    this.isSecure, 
    this.focus})
      : super(key: key) {
    isSecure ??= false;
    maxLine ??= 1;
    height ??= 40;
    maxLength ??= -1;
    focus ??= FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Center(
        child: TextField(
          style: AppTextStyle.PD(AppColor_BlackText, size ?? 14, weight: weight ?? FW.medium),
          maxLength: maxLength,
          controller: controller,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          obscureText: isSecure!,
          textAlignVertical: TextAlignVertical.center,
          textAlign: textAlign ?? TextAlign.start,
          textInputAction: textInputAction,
          maxLines: maxLine,
          // focusNode: focus,
          decoration: InputDecoration(
            counterText: "", 
            hintText: placeholder, 
            hintStyle: AppTextStyle.PD(hintColor ?? AppColor_Hint, 14, weight: FW.medium), 
            isDense: true, 
            contentPadding: const EdgeInsets.symmetric(vertical: 0), 
            border: InputBorder.none,
            suffixIconConstraints: const BoxConstraints(maxHeight: 16, maxWidth: 16),
            suffixIcon: canClear && controller.text != "" && controller.text != null
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClear ?? () => controller.clear(),
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/ic_clear.svg',
                    ),
                  ),
                )
              : const SizedBox() ,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
