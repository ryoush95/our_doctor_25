import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';

import '../app_event.dart';

class PurchaseConfirmDialog extends StatefulWidget {
  PurchaseConfirmDialog({Key? key, required this.orderId}) : super(key: key);
  String? orderId;
  @override
  PurchaseConfirmDialogState createState() => PurchaseConfirmDialogState();
}

class PurchaseConfirmDialogState extends BaseState<PurchaseConfirmDialog> {
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  Future<void> reqChangeStatus() async {
    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> offInfo = httpService.changeOrderStatus(widget.orderId!, "1");
    offInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        eventBus.fire(OrderHistoryEvent());
        showToast('구매가 확정되었습니다.');
        onBackPressed();
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
      //showToast(onError);
    });
  }

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
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colors.white),
                  //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.25),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      SizedBox(
                        width: screenSize.width - 40,
                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          InkWell(
                            child: Image.asset('assets/clear_black_24dp.png', height: 24),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                        ]),
                      ),
                      H24B(text: LanguageService.trans("purchase_confirm_title"), color: AppColor_BlackText, maxLine: 2, height: 1.3),
                      //const SizedBox(height: 10),
                      H16(
                        text: LanguageService.trans("purchase_confirm_description"),
                        color: AppColor_BlackText,
                        weight: FW.medium,
                        maxLine: 3,
                        height: 1.5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MainTextButton(
                        text: LanguageService.trans("confirm_purchase"),
                        backgroundColor: AppColor_Primary,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        width: screenSize.width - 60,
                        onPressed: () {
                          reqChangeStatus();
                        },
                      ),
                      const SizedBox(height: 45)
                    ],
                  ))
            ],
          ),
          onWillPop: onBackPressed);
    });
  }
}
