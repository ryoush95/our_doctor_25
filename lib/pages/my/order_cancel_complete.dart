import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/tab_main.dart';

class OrderCancelCompletePage extends StatefulWidget {
  @override
  OrderCancelCompletePageState createState() => OrderCancelCompletePageState();
}

class OrderCancelCompletePageState extends BaseState<OrderCancelCompletePage> {
  bool valid = false;

  @override
  void initState() {
    super.initState();

    checkValid();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void checkValid() {
    // if (phone.isEmpty || pwd.isEmpty || name.isEmpty || birth.isEmpty || date.isEmpty || postcode.isEmpty || address1.isEmpty || hosiptalId.isEmpty) {
    //   setState(() {
    //     valid = false;
    //   });
    // } else {
    //   setState(() {
    //     valid = true;
    //   });
    // }
  }

  // Network functions
  //////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("order_cancellation"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 45),
                    H24B(text: LanguageService.trans("order_cancel_success"), maxLine: 2, height: 1.4, align: TextAlign.left),
                    const SizedBox(height: 10),
                    H16(text: LanguageService.trans("see_good_description"), maxLine: 2, height: 1.4, weight: FW.medium, align: TextAlign.left),
                    Expanded(
                      child: Container(
                        child: Image.asset("assets/ic_order_cancel.png"),
                      ),
                    ),
                    MainTextButton(
                      text: LanguageService.trans("go_to_main"),
                      backgroundColor: AppColor_Primary,
                      style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                      onPressed: () {
                        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => TabMainPage()));
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
