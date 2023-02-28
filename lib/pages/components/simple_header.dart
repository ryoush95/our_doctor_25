import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';

import 'h18.dart';

class SimpleHeader extends StatelessWidget {
  final title;
  final onBackPressed;

  SimpleHeader({Key? key, this.title, this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset('assets/path_12225.png', width: 10,),
                ),
                onTap: onBackPressed,
              )),
          Center(
            child: H18(text: title, weight: FW.medium, maxLine: 2),
          ),
        ],
      ),
    );
  }
}
