import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/global.dart';

class AppFloatingButton extends StatelessWidget {
  final onPressed;

  AppFloatingButton({
    Key? key,
    this.onPressed,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Platform.isAndroid || Platform.isIOS && !gReview,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 85,
          height: 85,
          child: FloatingActionButton(
            highlightElevation: 0,
            focusElevation: 0,
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            onPressed: onPressed,
            child: Image.asset("assets/group_19993.png"),
          ),
        ),
      ),
    );
  }
}
