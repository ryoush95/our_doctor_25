import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/order_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/dialog/dlg_title_two_btn.dart';
import 'package:ourdoctor/pages/my/order_cancel_complete.dart';
import 'package:sprintf/sprintf.dart';

class OrderCancelPage extends StatefulWidget {
  final OrderDto order;

  OrderCancelPage({Key? key, required this.order}) : super(key: key);

  @override
  OrderCancelPageState createState() => OrderCancelPageState();
}

class OrderCancelPageState extends BaseState<OrderCancelPage> {
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> orderCancel() async {
    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> info = httpService.cancelOrder(widget.order.id!);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => OrderCancelCompletePage()));
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {}
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: H18(
                            text: LanguageService.trans('ask_order_cancel'),
                            weight: FW.bold,
                            align: TextAlign.start,
                            height: 1.2,
                          )),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: _itemBuilder,
                        itemCount: widget.order.productList!.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: MainTextButton(
                text: LanguageService.trans('do_order_cancel'),
                backgroundColor: Colors.white,
                showBorder: true,
                borderColor: AppColor_Gray,
                style: AppTextStyle.PD(Colors.black, 16, weight: FW.semi_bold),
                height: 55,
                onPressed: () async {
                  var _result = await showDialog(context: context, builder: (_) => TwoBtnTitleDialog(title: "알 림", content: "주문을 취소하시겠습니까?", btn1: "아니요", btn2: "네"));
                  if (_result != null && _result == "100") {
                    orderCancel();
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            width: screenSize.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    ExtendedImage.network(widget.order.productList![index].mainImage!, width: 75, height: 75, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(12))),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: widget.order.productList![index].optionName!, weight: FW.regular, color: AppColor_414141),
                        const SizedBox(height: 5),
                        H16(text: widget.order.productList![index].name!, weight: FW.regular, color: AppColor_Table_DateTime),
                        const SizedBox(height: 15),
                        H16(text: sprintf("%s원 | %s개", [widget.order.productList![index].optionPrice, widget.order.productList![index].optionCnt]), weight: FW.bold, color: AppColor_414141),
                      ],
                    )
                    //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
                  ],
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: index < 2,
                  child: const Divider(thickness: 1, color: AppColor_Light_Gray),
                )
              ],
            ))
      ],
    );
  }
}
