import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'h14.dart';
import 'h16.dart';

class AppCheckboxFill extends StatefulWidget {
  final padding;
  AppCheckboxFill(
      {Key? key,
        required this.text,
        required this.checked,
        required this.onChecked,
        this.padding,
        this.withBorder = false})
      : super(key: key);

  String text;
  bool checked = false;
  final void Function(bool? checked) onChecked;
  bool withBorder = false;

  @override
  AppCheckboxFillState createState() => AppCheckboxFillState();
}

class AppCheckboxFillState extends State<AppCheckboxFill> {

  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    checkStatus = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.withBorder) {
      return InkWell(
        child: Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: checkStatus?AppColor_Primary:AppColor_BlackText.withOpacity(0.05)
            ),
            child: Center(
              child: H16(text: widget.text, weight: FW.medium, color: checkStatus?AppColor_White:AppColor_BlackText.withOpacity(0.5))
            )
        ),
        onTap: () {
          setState(() {
            checkStatus = !checkStatus;
          });
          widget.onChecked(checkStatus);
        },
      );
    } else {
      return InkWell(
        child: Row(
          children: [
            Image.asset(
                checkStatus
                    ? 'assets/ic_check_on.png'
                    : 'assets/ic_check_off.png',
                height: 22),
            const SizedBox(width: 8),
            H14(text: widget.text, weight: FW.medium)
          ],
        ),
        onTap: () {
          setState(() {
            checkStatus = !checkStatus;
          });
          widget.onChecked(checkStatus);
        },
      );
    }
  }
}
