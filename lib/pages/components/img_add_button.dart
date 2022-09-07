import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';

import 'h10.dart';

class ImgAddButton extends StatelessWidget {
  final text;
  final onPressed;

  ImgAddButton({
    Key? key,
    this.text,
    this.onPressed,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black)
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/ic_monitor_on.png", width: 25),
              const SizedBox(height: 3),
              H10(text: text)
            ],
          ),
        ),
      ),
    );
  }
}
