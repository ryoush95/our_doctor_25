import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/order_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/my/order_exchange_complete.dart';
import 'package:sprintf/sprintf.dart';

import 'edit_shipping_address.dart';

class OrderExchangeRequestPage extends StatefulWidget {
  final OrderDto order;
  final List<bool> checkStatus;
  final List<int> selectCount;
  final String reason1;
  final String reason2;

  OrderExchangeRequestPage({Key? key, required this.order, required this.checkStatus, required this.selectCount, required this.reason1, required this.reason2}) : super(key: key);

  @override
  OrderExchangeRequestPageState createState() => OrderExchangeRequestPageState();
}

class OrderExchangeRequestPageState extends BaseState<OrderExchangeRequestPage> {
  final HttpService httpService = HttpService();

  int method = 0;
  String product_addr = '';
  String deliver_addr = '';
  String json_product_addr = '';
  String json_deliver_addr = '';
  double amount = 0;

  @override
  void initState() {
    super.initState();

    product_addr = widget.order.deliverAddress! + ' ' + widget.order.deliverAddressDetail!;
    deliver_addr = widget.order.deliverAddress! + ' ' + widget.order.deliverAddressDetail!;
    Map<String, String> deliver_address = {'addr': widget.order.deliverAddress!, 'detail': widget.order.deliverAddressDetail!, 'postcode': widget.order.deliverPostcode!};
    json_product_addr = json.encode(deliver_address);
    json_deliver_addr = json.encode(deliver_address);
    calcPrice();
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

  void calcPrice() {
    amount = 0;
    for (int i = 0; i < widget.order.productList!.length; i++) {
      if (widget.checkStatus[i]) {
        amount = amount + doubleParse(widget.order.productList![i].optionPrice) * widget.selectCount[i];
      }
    }
    setState(() {});
  }

  Future<void> request() async {
    if (method == 0) {
      showToast('해결방법을 선택 해주세요.');
      return;
    }
    List<Map<String, int>> productList = [];
    for (int i = 0; i < widget.order.productList!.length; i++) {
      if (widget.checkStatus[i]) {
        Map<String, int> info = {
          'id': int.parse(widget.order.productList![i].orderProductId!),
          'count': widget.selectCount[i],
        };
        productList.add(info);
      }
    }
    String plist = json.encode(productList);

    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> offInfo = httpService.requestExchangeReturn(widget.order.id!, method == 1 ? "EXCHANGE" : "RETURN", widget.reason1, widget.reason2, plist, json_product_addr, json_deliver_addr);
    offInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        eventBus.fire(OrderHistoryEvent());
        showToast('교환/반품이 신청되었습니다.');
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => OrderExchangeCompletePage()));
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
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("Exchange/Return"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      H14(
                        text: sprintf(LanguageService.trans('Exchange/Return product count'), [widget.checkStatus.where((element) => element).toList().length]),
                        weight: FW.medium,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      const SizedBox(height: 2),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: _itemBuilder,
                        itemCount: widget.checkStatus.where((element) => element).toList().length,
                      ),
                      const SizedBox(height: 40),
                      H14(
                        text: LanguageService.trans('exchange_reason'),
                        weight: FW.medium,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      H14(
                        text: widget.reason1 + (widget.reason2.isEmpty ? '' : '\n${widget.reason2}'),
                        weight: FW.medium,
                        align: TextAlign.start,
                        color: AppColor_GrayText,
                        height: 1.2,
                        maxLine: 100,
                      ),
                      const SizedBox(height: 50),
                      H18(
                        text: LanguageService.trans('want_which_method'),
                        weight: FW.bold,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      const SizedBox(height: 15),
                      Row(children: [
                        InkWell(
                          onTap: () {
                            method = 1;
                            setState(() {});
                          },
                          child: Container(
                              height: 60,
                              width: (screenSize.width - 65) / 2,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor_Gray), borderRadius: BorderRadius.circular(16), color: AppColor_White),
                              child: Row(
                                children: [
                                  SizedBox(width: 16),
                                  Image.asset(method == 1 ? "assets/radio_button_checked_black_24dp.png" : "assets/radio_button_unchecked_black_24dp.png", width: 24, height: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    LanguageService.trans("exchange"),
                                    style: AppTextStyle.PD(Colors.black, 16, weight: FW.medium),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            method = 2;
                            setState(() {});
                          },
                          child: Container(
                              height: 60,
                              width: (screenSize.width - 65) / 2,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor_Gray), borderRadius: BorderRadius.circular(16), color: AppColor_White),
                              child: Row(
                                children: [
                                  SizedBox(width: 16),
                                  Image.asset(method == 2 ? "assets/radio_button_checked_black_24dp.png" : "assets/radio_button_unchecked_black_24dp.png", width: 24, height: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    LanguageService.trans("refund"),
                                    style: AppTextStyle.PD(Colors.black, 16, weight: FW.medium),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        ),
                      ]),
                      const SizedBox(height: 60),
                      H18(
                        text: LanguageService.trans('delivery_collect_info_check'),
                        weight: FW.bold,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      Visibility(
                        visible: method == 1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.only(top: 12),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LanguageService.trans("exchange_address"),
                                    style: AppTextStyle.PD(Colors.black, 16, weight: FW.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideRightTransRoute(
                                              builder: (context) => EditShippingAddressPage(onChanged: (address1, address2, postcode) {
                                                    setState(() {
                                                      product_addr = address1 + ' ' + address2;

                                                      Map<String, String> deliver_address = {'addr': address1, 'detail': address2, 'postcode': postcode};
                                                      json_product_addr = json.encode(deliver_address);
                                                    });
                                                  })));
                                    },
                                    child: Text(
                                      LanguageService.trans("change"),
                                      style: AppTextStyle.PD(AppColor_Primary, 16, weight: FW.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              H16(text: sprintf("%s, %s", [gUserInfo!.nickname, gUserInfo!.phone]), weight: FW.regular),
                              const SizedBox(height: 20),
                              H16(
                                text: product_addr,
                                weight: FW.regular,
                                color: AppColor_BlackText,
                                align: TextAlign.left,
                                maxLine: 2,
                              ),
                              const SizedBox(height: 10),
                              const Divider(thickness: 1, color: AppColor_Gray),
                              const SizedBox(height: 10),
                              Text(
                                LanguageService.trans("exchange_date"),
                                style: AppTextStyle.PD(Colors.black, 16, weight: FW.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '안내문자를 발송 해드립니다',
                                style: AppTextStyle.PD(AppColor_Green, 16, weight: FW.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LanguageService.trans("collect_address"),
                                  style: AppTextStyle.PD(Colors.black, 16, weight: FW.bold),
                                  textAlign: TextAlign.center,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlideRightTransRoute(
                                            builder: (context) => EditShippingAddressPage(onChanged: (address1, address2, postcode) {
                                                  setState(() {
                                                    deliver_addr = address1 + ' ' + address2;

                                                    Map<String, String> deliver_address = {'addr': address1, 'detail': address2, 'postcode': postcode};
                                                    json_deliver_addr = json.encode(deliver_address);
                                                  });
                                                })));
                                  },
                                  child: Text(
                                    LanguageService.trans("change"),
                                    style: AppTextStyle.PD(AppColor_Primary, 16, weight: FW.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            H16(text: sprintf("%s, %s", [gUserInfo!.nickname, gUserInfo!.phone]), weight: FW.regular),
                            const SizedBox(height: 20),
                            H16(
                              text: deliver_addr,
                              weight: FW.regular,
                              color: AppColor_BlackText,
                              align: TextAlign.left,
                              maxLine: 2,
                            ),
                            const SizedBox(height: 10),
                            const Divider(thickness: 1, color: AppColor_Gray),
                            const SizedBox(height: 10),
                            Text(
                              LanguageService.trans("collect_date"),
                              style: AppTextStyle.PD(Colors.black, 16, weight: FW.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '안내문자를 발송 해드립니다',
                              style: AppTextStyle.PD(AppColor_Green, 16, weight: FW.bold),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: method == 2,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.only(top: 12),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LanguageService.trans("refund_guide"),
                                    style: AppTextStyle.PD(Colors.black, 16, weight: FW.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      H16(
                                        text: LanguageService.trans("product_amount"),
                                        weight: FW.regular,
                                        color: AppColor_BlackText,
                                      ),
                                      const SizedBox(width: 20),
                                      H16(
                                        text: '${ValidPrice(amount.toString())}원',
                                        weight: FW.regular,
                                        color: AppColor_BlackText,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      H16(
                                        text: LanguageService.trans("shipping_fee"),
                                        weight: FW.regular,
                                        color: AppColor_BlackText,
                                      ),
                                      const SizedBox(width: 20),
                                      H16(
                                        text: '${ValidPrice(widget.order.deliverPrice!)}원',
                                        weight: FW.regular,
                                        color: AppColor_BlackText,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      H16(
                                        text: LanguageService.trans("refund_ua_point"),
                                        weight: FW.regular,
                                        color: AppColor_BlackText,
                                      ),
                                      const SizedBox(width: 20),
                                      H16(
                                        text: '+${widget.order.point}원',
                                        weight: FW.regular,
                                        color: AppColor_BlackText,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(color: AppColor_Gray, height: 1),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      H18(
                                        text: LanguageService.trans("refund_amount"),
                                        weight: FW.bold,
                                        color: AppColor_BlackText,
                                      ),
                                      const SizedBox(width: 20),
                                      H18(
                                        text: '${ValidPrice((amount + doubleParse(widget.order.deliverPrice!) + doubleParse(widget.order.point!)).toString())}원',
                                        weight: FW.bold,
                                        color: AppColor_Red,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: MainTextButton(
                text: LanguageService.trans('exchange_refund_request'),
                backgroundColor: AppColor_Primary,
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.semi_bold),
                height: 55,
                onPressed: () {
                  request();
                },
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    var realIndex = 0;

    int cnt = -1;
    for (int i = 0; i < widget.order.productList!.length; i++) {
      if (widget.checkStatus[i]) {
        cnt++;
        if (cnt == index) {
          realIndex = i;
          break;
        }
      }
    }

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
                    widget.order.productList![realIndex].mainImage!.isNotEmpty
                        ? ExtendedImage.network(widget.order.productList![realIndex].mainImage!, width: 75, height: 75, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(12)))
                        : Container(
                            width: 75,
                            height: 75,
                            decoration: const BoxDecoration(color: AppColor_f4f5f7, borderRadius: BorderRadius.all(Radius.circular(12))),
                          ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: widget.order.productList![realIndex].name!, weight: FW.regular, color: AppColor_414141),
                        const SizedBox(height: 5),
                        H16(text: widget.order.productList![realIndex].optionName!, weight: FW.regular, color: AppColor_Table_DateTime),
                        const SizedBox(height: 15),
                        H16(text: sprintf("%s원 | %s개", [ValidPrice(widget.order.productList![realIndex].optionPrice!), widget.selectCount[realIndex]]), weight: FW.bold, color: AppColor_414141),
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
