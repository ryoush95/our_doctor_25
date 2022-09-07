import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/monitor_write_res_model.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/login1.dart';

import '../tab_main.dart';

class DeliveryTrackingDialog extends StatefulWidget {
  final String deliverCompany;
  final String deliverNumber;

  const DeliveryTrackingDialog({Key? key, required this.deliverCompany, required this.deliverNumber}) : super(key: key);

  @override
  DeliveryTrackingDialogState createState() => DeliveryTrackingDialogState();
}

class DeliveryTrackingDialogState extends State<DeliveryTrackingDialog> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  // Network functions
  //////////////////////////////////
  //모니터 쓰기

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: screenSize.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colors.white),
                  //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.25),
                  child: Column(
                    children: [
                      const SizedBox(height: 45),
                      SizedBox(
                        width: screenSize.width - 60,
                        child: H24B(
                          text: LanguageService.trans("delivery_tracking"),
                          color: AppColor_BlackText,
                          maxLine: 2,
                          height: 1.3,
                          align: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: screenSize.width - 60,
                        child: H16(
                          text: sprintf("%s: %s", [LanguageService.trans("courier"), widget.deliverCompany]),
                          weight: FW.regular,
                          align: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: screenSize.width - 60,
                          child: Row(
                            children: [
                              H16(text: LanguageService.trans("invoice_number") + ": ", weight: FW.regular),
                              InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: widget.deliverNumber));
                                    showToast('송장번호가 클립보드에 복사되었습니다.');
                                  },
                                  child: H16(
                                    text: widget.deliverNumber,
                                    weight: FW.bold,
                                    color: AppColor_Primary,
                                  ))
                            ],
                          )),
                      const SizedBox(height: 70),
                    ],
                  ))
            ],
          ),
          onWillPop: onBackPressed);
    });
  }
}
