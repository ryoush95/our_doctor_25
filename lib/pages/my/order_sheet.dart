import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/date_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/order_detail_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';

import 'profile_item1.dart';

class OrderSheetPage extends StatefulWidget {
  OrderSheetPage({Key? key, required this.orderId}) : super(key: key);
  String? orderId;

  @override
  OrderSheetPageState createState() => OrderSheetPageState();
}

class OrderSheetPageState extends BaseState<OrderSheetPage> {
  final HttpService httpService = HttpService();
  late ScrollController _listController;

  bool showInformation = false;
  bool showProduct = true;
  OrderDto? order;
  List<String> pay_method = ["Card", "Deposit", "Phone"];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    getOrder();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  Future<void> getOrder() async {
    setState(() {
      isLoading = true;
    });
    Future<OrderDetailResModel> info = httpService.getOrderDetail(widget.orderId!);
    info.then((OrderDetailResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        order = value.data;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {}
        Navigator.pop(context);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  int getPayPoint(double total_price, String type) {
    for (int i = 0; i < gReviewPoint!.length; i++) {
      if (type == gReviewPoint!.elementAt(i).TYPE) {
        double ua_point = total_price / 100 * doubleParse(gReviewPoint!.elementAt(i).value);
        return ua_point.toInt();
      }
    }
    return total_price.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("order_sheet"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(children: [
                          const SizedBox(height: 25),
                          Row(children: [
                            H16(
                              text: order != null ? convertDateFromStr(order!.updatedAt.toString(), "yyyy-MM-dd HH:mm:ss", "yyyy.MM.dd") : "",
                            ),
                            Expanded(child: Container()),
                            H16(text: LanguageService.trans("order_no") + (order != null ? order!.id! : ""), weight: FW.regular, color: AppColor_707071)
                          ]),
                          const SizedBox(height: 35),
                          InkWell(
                              onTap: () {
                                showProduct = !showProduct;
                                setState(() {});
                              },
                              child: Row(children: [
                                H16(
                                  text: LanguageService.trans("order_product"),
                                ),
                                Expanded(child: Container()),
                                Image.asset(showProduct ? 'assets/group_20046.png' : 'assets/Down-Small.png', width: 15),
                              ])),
                          const SizedBox(height: 10),
                          Visibility(visible: showProduct, child: ListView.builder(shrinkWrap: true, itemBuilder: _itemBuilder, itemCount: order != null ? order!.productList!.length : 0, controller: _listController))
                        ])),
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            InkWell(
                                child: Row(children: [
                              H16(
                                text: LanguageService.trans("orderer_information"),
                              ),
                              Expanded(child: Container()),
                            ])),
                            const SizedBox(height: 15),
                            ProfileItem1(title: LanguageService.trans("orderer"), content: gUserInfo!.nickname!),
                            const SizedBox(height: 15),
                            ProfileItem1(title: LanguageService.trans("mobile"), content: gUserInfo!.phone!),
                            const SizedBox(height: 15),
                          ],
                        )),
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            H16(
                              text: LanguageService.trans("shipping_address"),
                            ),
                            const SizedBox(height: 15),
                            H16(
                              text: sprintf("%s, %s", [gUserInfo!.nickname, gUserInfo!.phone]),
                              weight: FW.regular,
                              color: AppColor_BlackText,
                              align: TextAlign.left,
                            ),
                            const SizedBox(height: 20),
                            const Divider(thickness: 2, color: AppColor_Light_Gray),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Image.asset('assets/ic_loctaion.png', width: 15),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: H16(
                                    text: order != null ? (order!.deliverAddress! + " " + order!.deliverAddressDetail!) : "",
                                    weight: FW.regular,
                                    color: AppColor_BlackText,
                                    align: TextAlign.left,
                                    maxLine: 2,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 40)
                          ],
                        )),
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            H16(
                              text: LanguageService.trans("payment_method"),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                H16(
                                  text: LanguageService.trans("payment_way"),
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                  align: TextAlign.left,
                                ),
                                const SizedBox(width: 10),
                                H16(
                                  text: order != null ? (order!.payMethod!.toUpperCase() == "CARD" ? "신용카드" : (order!.payMethod!.toUpperCase() == "TRANS" ? "실시간 계좌이체" : "휴대폰")) + ' 우아 포인트 / 일시불' : "",
                                  weight: FW.semi_bold,
                                  color: AppColor_BlackText,
                                  align: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        )),
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            H16(
                              text: LanguageService.trans("final_payment_information"),
                            ),
                            const SizedBox(height: 20),
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
                                  text: order != null ? sprintf("%s %s", [ValidPrice((double.parse(order!.totalPrice!) + int.parse(order!.point!) - int.parse(order!.deliverPrice!) + double.parse(order!.discountPrice!)).toString()), "원"]) : "",
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H16(
                                  text: LanguageService.trans("product_discount_amount"),
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                ),
                                const SizedBox(width: 20),
                                H16(
                                  text: order != null ? sprintf("- %s %s", [ValidPrice(order!.discountPrice!), "원"]) : "",
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
                                  text: order != null ? sprintf("+ %s %s", [ValidPrice(order!.deliverPrice!), "원"]) : "",
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H16(
                                  text: LanguageService.trans("use_ua_point"),
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                ),
                                const SizedBox(width: 20),
                                H16(
                                  text: order != null ? sprintf("- %s %s", [ValidPrice(order!.point!), "원"]) : "",
                                  weight: FW.regular,
                                  color: AppColor_BlackText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(thickness: 2, color: AppColor_Light_Gray),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H16(
                                  text: LanguageService.trans("final_payment_amount"),
                                  weight: FW.medium,
                                  color: AppColor_BlackText,
                                ),
                                const SizedBox(width: 20),
                                H18(
                                  text: order != null ? sprintf("%s %s", [ValidPrice(order!.totalPrice!), "원"]) : "",
                                  weight: FW.bold,
                                  color: AppColor_BlackText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                H14(
                                  text: order != null ? sprintf("%d %s", [getPayPoint(double.parse(order!.totalPrice!), "PAY_POINT"), "우아포인트 적립"]) : "",
                                  weight: FW.bold,
                                  color: AppColor_707071,
                                ),
                              ],
                            ),
                            const SizedBox(height: 55)
                          ],
                        )),
                  ],
                ),
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
                    ExtendedImage.network(order!.productList![index].mainImage!, width: 75, height: 75, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(12))),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: order != null ? order!.productList![index].optionName! : "", weight: FW.regular, color: AppColor_414141),
                        const SizedBox(height: 5),
                        H16(text: order != null ? order!.productList![index].name! : "", weight: FW.regular, color: AppColor_Table_DateTime),
                        const SizedBox(height: 15),
                        H16(text: order != null ? sprintf("%s원 | %s개", [ValidPrice(order!.productList![index].optionPrice!), order!.productList![index].optionCnt]) : "", weight: FW.bold, color: AppColor_414141),
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
