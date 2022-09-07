import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/h14.dart';

class TitleInput extends StatelessWidget {
  final String title;
  final onChange;
  final controller;
  final onEditComplete;
  final textType;
  final String hint;
  bool? isSecure;
  bool? isEnable;

  TitleInput({Key? key, required this.title, required this.onChange, required this.controller, required this.onEditComplete, required this.hint, this.textType, this.isSecure, this.isEnable}) : super(key: key) {
    isSecure ??= false;
    isEnable ??= true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H14(
            text: title,
            weight: FW.medium,
            color: AppColor_Input_Title,
          ),
          const SizedBox(height: 15),
          Container(
              height: 45,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColor_Gray), color: Colors.white),
              child: Container(
                padding: const EdgeInsets.only(bottom: 7, left: 20, right: 20),
                child: TextField(
                  style: AppTextStyle.PD(Colors.black, 14, weight: FW.regular),
                  maxLength: 100,
                  controller: controller,
                  onEditingComplete: onEditComplete,
                  keyboardType: textType ?? TextInputType.text,
                  obscureText: isSecure!,
                  enabled: isEnable,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: hint,
                    hintStyle: AppTextStyle.PD(AppColor_Gray, 14, weight: FW.medium),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    onChange(text);
                  },
                ),
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
