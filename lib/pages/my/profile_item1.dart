import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';

class ProfileItem1 extends StatelessWidget {
  final String title;
  final String content;
  final maxLine;

  ProfileItem1({Key? key, required this.title, required this.content,  this.maxLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: H16(
            text: title,
            weight: FW.regular,
            color: AppColor_BlackText,
            align: TextAlign.left,
          ),
        ),
        const SizedBox(width: 20),
        H16(
          text: content,
          weight: FW.medium,
          color: AppColor_BlackText,
        ),
      ],
    );
  }
}
