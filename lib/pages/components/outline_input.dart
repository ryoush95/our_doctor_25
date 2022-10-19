import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class OutlineInput extends StatelessWidget {
  final controller;
  final keyboardType;
  final textInputAction;
  final onEditingComplete;
  final placeholder;
  final onChanged;
  final borderColor;
  final hintColor;
  bool? isSecure;
  int? maxLine;
  int? maxLength;
  double? height;
  final weight;
  final size;
  final textAlign;
  FocusNode? focus;
  bool? readOnly;
  List<TextInputFormatter>? inputFomatter;

  OutlineInput({Key? key, this.controller, this.keyboardType, this.placeholder, this.textInputAction, this.onEditingComplete, this.onChanged, this.borderColor, this.hintColor, this.maxLine, this.maxLength, this.height, this.weight, this.size, this.textAlign, this.isSecure, this.focus, this.readOnly, this.inputFomatter})
      : super(key: key) {
    isSecure ??= false;
    maxLine ??= 1;
    height ??= 55;
    maxLength ??= -1;
    focus ??= FocusNode();
    readOnly ??= false;
    inputFomatter ??= [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Center(
        child: TextField(
          style: AppTextStyle.PD(AppColor_BlackText, size ?? 16, weight: weight ?? FW.medium),
          maxLength: maxLength,
          controller: controller,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          obscureText: isSecure!,
          textAlignVertical: TextAlignVertical.center,
          textAlign: textAlign ?? TextAlign.start,
          textInputAction: textInputAction,
          maxLines: maxLine,
          readOnly: readOnly!,
          inputFormatters: inputFomatter,
          focusNode: focus,
          decoration: InputDecoration(
            counterText: "",
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor_Selector_Border),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor_BlackText),
              borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
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
