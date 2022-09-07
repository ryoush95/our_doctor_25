import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

import 'h14.dart';
import 'h16.dart';

class AppCheckbox extends StatefulWidget {
  final padding;
  AppCheckbox({
    Key? key, 
    required this.text, 
    required this.checked, 
    required this.onChecked, 
    this.padding, 
    this.withBorder = false,
    this.fontSize = 16,
    }) : super(key: key);

  String text;
  bool checked = false;
  final void Function(bool? checked) onChecked;
  bool withBorder = false;
  double fontSize;

  @override
  AppCheckboxState createState() => AppCheckboxState();
}

class AppCheckboxState extends State<AppCheckbox> {
  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    checkStatus = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    checkStatus = widget.checked;
    if (widget.withBorder) {
      return InkWell(
        child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: checkStatus ? AppColor_Primary : AppColor_Selector_Border)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(checkStatus ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', height: 22),
                  const SizedBox(width: 8),
                  //FIXME: 4th modification
                  Expanded(
                    child: AutoSizeText(
                      widget.text,
                      style:  TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColor_BlackText,
                        fontSize: widget.fontSize,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                    // H16(
                    //   text: widget.text,
                    //   weight: FW.medium,
                    // ),
                  ),
                ],
              ),
            )),
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
            Image.asset(checkStatus ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', height: 22), 
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
