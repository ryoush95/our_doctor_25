import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';

/**
 * 날짜 선택 팝업
 */
class SelectDateDialog extends StatefulWidget {
  SelectDateDialog({Key? key, required this.type}) : super(key: key);
  int? type;
  @override
  _SelectDateDialogState createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDateDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  String selectDate = "19800101";
  int year = 0;
  int month = 0;
  int day = 0;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    if (widget.type == 1) {
      //생년월일
      // year = 1980;
      // month = 01;
      // day = 01;
      // selectDate = "1980-01-01";
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectDate = formatter.format(now);
      var arr = selectDate.split("-");
      year = int.parse(arr[0]);
      month = int.parse(arr[1]);
      day = int.parse(arr[2]);
    } else {
      //PCR 검사일
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      selectDate = formatter.format(now);
      var arr = selectDate.split("-");
      year = int.parse(arr[0]);
      month = int.parse(arr[1]);
      day = int.parse(arr[2]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          color: Colors.transparent,
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: Center(
                          child: H20(
                            text: LanguageService.trans("select_date"),
                            weight: FW.regular,
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 25.0),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(year, month, day),
                          onDateTimeChanged: (DateTime newDateTime) {
                            selectDate = DateFormat('yyyy-MM-dd').format(newDateTime);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        height: 1,
                        color: const Color(0xFFF4F5F7),
                      ),
                      SizedBox(
                        height: 55,
                        child: Row(
                          children: [
                            MainTextButton(
                              text: LanguageService.trans("cancel1"),
                              backgroundColor: Colors.white,
                              style: AppTextStyle.PD(AppColor_BlackText, 15),
                              width: (MediaQuery.of(context).size.width - 80 - 1) / 2,
                              height: 55,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Container(
                              width: 1,
                              height: 55,
                              color: const Color(0xFFF4F5F7),
                            ),
                            MainTextButton(
                              text: LanguageService.trans("confirm1"),
                              backgroundColor: Colors.white,
                              style: AppTextStyle.PD(AppColor_Primary, 15),
                              width: (MediaQuery.of(context).size.width - 80 - 1) / 2,
                              height: 55,
                              onPressed: () {
                                int days = checkSelDate(selectDate);
                                if (days < 0) {
                                  if (widget.type == 1) {
                                    showToast(LanguageService.trans("incorrect_birthday"));
                                  } else {
                                    showToast(LanguageService.trans("incorrect_pcr_date"));
                                  }
                                  return;
                                }
                                Navigator.pop(context, selectDate);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
        ),
      ),
    );
  }
}
