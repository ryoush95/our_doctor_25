import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/basket_add_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/pages/care/product_dialog.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/order.dart';
import 'package:sprintf/sprintf.dart';

class BuyingDialog extends StatefulWidget {
  BuyingDialog({Key? key, required this.info}) : super(key: key);

  final ProductDetailDto info;

  @override
  BuyingDialogState createState() => BuyingDialogState();
}

class BuyingDialogState extends State<BuyingDialog> {
  List<int> thingCount = [];
  int totalCount = 0;
  bool isLoading = false;

  BuyingDialogState() {}

  List<Options> arrOptionList = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    thingCount.add(0); //default으로 상품을 넣아야 함
    Options info = Options();
    info.productId = widget.info.id;
    info.name = widget.info.name;
    info.price = widget.info.price;
    info.discount = widget.info.discount;
    info.maxCnt = widget.info.maxCnt;
    arrOptionList.add(info);
    for (int i = 0; i < widget.info.options!.length; i++) {
      thingCount.add(0);
      arrOptionList.add(widget.info.options!.elementAt(i));
    }

    setState(() {});
  }

  int getDeliveryWon(String type) {
    for (int i = 0; i < gReviewPoint!.length; i++) {
      if (type == gReviewPoint!.elementAt(i).TYPE) {
        return int.parse(gReviewPoint!.elementAt(i).value!);
      }
    }
    return 0;
  }

  void goOrder() {
    List<ProductDto> orderProduct = [];
    List<int> productCount = [];
    double amount = 0;
    double discount_amount = 0;

    for (int i = 0; i < thingCount.length; i++) {
      if (thingCount[i] > 0) {
        orderProduct.add(ProductDto(id: arrOptionList[i].productId, name: widget.info.name, option: arrOptionList[i].name, price: arrOptionList[i].price, mainImage: widget.info.mainImage));
        productCount.add(thingCount[i]);
        amount += double.parse(arrOptionList[i].price!) * thingCount[i];
        discount_amount = discount_amount + doubleParse(arrOptionList[i].price!) * doubleParse(arrOptionList[i].discount!) / 100 * thingCount[i];
      }
    }
    int shipping_fee = getDeliveryWon("DELIVER_WON");
    //주문하기 페이지 구현하면서 이 부분 구현해야 함
    if (gUserInfo!.deliverAddress!.isEmpty && gUserInfo!.deliverAddressDetail!.isEmpty) {
      setState(() {
        gUserInfo!.deliverAddress = gUserInfo!.address;
        gUserInfo!.deliverAddressDetail = gUserInfo!.addressDetail;
        gUserInfo!.deliverPostcode = gUserInfo!.postcode;
      });
    }

    OrderInfo orderInfo = OrderInfo(orderProduct, productCount, amount, discount_amount, shipping_fee, gUserInfo!.deliverAddress! + " " + gUserInfo!.deliverAddressDetail!);
    Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderPage(orderInfo: orderInfo, direct: 1)));
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  // Network functions
  //////////////////////////////////
  //장바구니 추가
  void reqAddBasket() {
    List<Map<String, String>> optList = [];
    for (int i = 0; i < thingCount.length; i++) {
      if (thingCount.elementAt(i) > 0) {
        Map<String, String> info = {
          'name': arrOptionList.elementAt(i).name!,
          'price': arrOptionList.elementAt(i).price!,
          'discount': arrOptionList.elementAt(i).discount!,
          'count': thingCount.elementAt(i).toString(),
        };
        optList.add(info);
      }
    }
    String opt_list = json.encode(optList);

    setState(() {
      isLoading = true;
    });

    final HttpService httpService = HttpService();
    List<BasketAddDto>? list = [];
    Future<BasketAddResModel> info = httpService.addBakset(widget.info.id!, opt_list);
    info.then((BasketAddResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list = value.data!.list;
        Navigator.pop(context);
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return ProductDialog(list: list, pImg: widget.info.mainImage);
            });
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
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
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7 - 75,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              child: Column(children: [
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(color: AppColor_f4f5f7, borderRadius: BorderRadius.circular(2.5)),
                  ),
                ),
                const SizedBox(height: 30),
                H18(
                  text: widget.info.name!,
                  maxLine: 2,
                  align: TextAlign.start,
                  height: 1.3,
                  weight: FW.regular,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                      itemCount: arrOptionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Options item = arrOptionList.elementAt(index);
                        return Column(
                          children: [
                            const Divider(color: AppColor_Selector_Border, height: 1),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    H16(
                                      text: item.name!,
                                      align: TextAlign.start,
                                      height: 1.3,
                                      weight: FW.medium,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        H16(
                                          text: item.price != null ? ValidPrice(item.discount != "" ? (double.parse(item.price!) * (100 - int.parse(item.discount!)) / 100).toString() : item.price!) : "0",
                                          align: TextAlign.start,
                                          height: 1.3,
                                          weight: FW.bold,
                                        ),
                                        const SizedBox(width: 5),
                                        H16(
                                          text: LanguageService.trans("won"),
                                          maxLine: 1,
                                          align: TextAlign.start,
                                          weight: FW.regular,
                                        ),
                                        const SizedBox(width: 10),
                                        Visibility(
                                          visible: item.discount != "0",
                                          child: H16(
                                            text: item.discount != "" ? (sprintf("%s%s", [item.discount, "%"])) : "",
                                            maxLine: 2,
                                            align: TextAlign.start,
                                            color: AppColor_Red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: item.discount != "0",
                                      child: const SizedBox(height: 5),
                                    ),
                                    Visibility(
                                      visible: item.discount != "0",
                                      child: Text(
                                        (item.price != null ? ValidPrice(convertScore(item.price!)) : "0") + "원",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          height: 1.0,
                                          color: AppColor_BlackText.withOpacity(0.3),
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (thingCount[index] == 0) {
                                            return;
                                          }
                                          totalCount--;
                                          thingCount[index]--;
                                        });
                                      },
                                      child: Container(
                                          width: 30,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: AppColor_Light_Gray, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                          child: Center(
                                            child: H20(text: "-", weight: FW.regular),
                                          )),
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColor_Light_Gray,
                                      ),
                                      child: Center(
                                        child: H16(text: thingCount[index].toString(), weight: FW.medium),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (thingCount[index] == int.parse(item.maxCnt!)) {
                                            showToast(item.maxCnt! + "개까지 선택 가능합니다.");
                                            return;
                                          }
                                          thingCount[index]++;
                                          totalCount++;
                                        });
                                      },
                                      child: Container(
                                          width: 30,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: AppColor_Light_Gray, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                          child: Center(
                                            child: H20(text: "+", weight: FW.regular),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: totalCount > 0 ? 1.0 : 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainTextButton(
                        text: LanguageService.trans("buy_now"),
                        backgroundColor: Colors.white,
                        style: AppTextStyle.PD(AppColor_Primary, 18, weight: FW.bold),
                        borderColor: AppColor_Primary,
                        showBorder: true,
                        height: 58,
                        disable: false,
                        width: (MediaQuery.of(context).size.width - 70) / 2,
                        onPressed: () {
                          if (totalCount <= 0) {
                            return;
                          }
                          if (gUserInfo!.message!.isEmpty) {
                            // onLeaveMessage();
                          }
                          goOrder();
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MainTextButton(
                        text: LanguageService.trans("shopping_basket"),
                        backgroundColor: AppColor_Primary,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        width: (MediaQuery.of(context).size.width - 70) / 2,
                        height: 58,
                        onPressed: () {
                          if (totalCount <= 0) {
                            return;
                          }
                          reqAddBasket();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
          onWillPop: onBackPressed);
    });
  }
}
