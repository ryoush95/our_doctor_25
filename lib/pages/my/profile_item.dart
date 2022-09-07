import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String content;
  final int type; // 0 : view, 1: edit
  final maxLine;

  ProfileItem({Key? key, required this.title, required this.content, required this.type, this.maxLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H14(
            text: title,
            weight: FW.bold,
            color: AppColor_BlackText.withOpacity(0.8),
          ),
          const SizedBox(height: 7),
          H16(
            text: content,
            weight: FW.medium,
            color: AppColor_BlackText.withOpacity(0.6),
            maxLine: maxLine ?? 1,
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
