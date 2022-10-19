import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/basket_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'edit_shipping_address.dart';
import 'order.dart';

class ShoppingBasketPage extends StatefulWidget {
  @override
  ShoppingBasketPageState createState() => ShoppingBasketPageState();
}

class ShoppingBasketPageState extends BaseState<ShoppingBasketPage> {
  final HttpService httpService = HttpService();

  bool valid = true;
  bool checkAll = false;
  ScrollController scrollController = ScrollController();

  int selectedCount = 0;
  double amount = 0;
  double discount_amount = 0;
  int shipping_fee = 0;
  List<bool> checkStatus = [];
  var textEditingControllers = <TextEditingController>[];

  List<BasketDto> basketList = [];

  ShoppingBasketPageState();

  @override
  void initState() {
    super.initState();

    if (gUserInfo!.deliverAddress!.isEmpty && gUserInfo!.deliverAddressDetail!.isEmpty) {
      setState(() {
        gUserInfo!.deliverAddress = gUserInfo!.address;
        gUserInfo!.deliverAddressDetail = gUserInfo!.addressDetail;
        gUserInfo!.deliverPostcode = gUserInfo!.postcode;
      });
    }
    basket_list();
    eventBus.on<UpdateShippingAddressEvent>().listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
    eventBus.on<UpdateUserEvent>().listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < textEditingControllers.length; i++) textEditingControllers[i].dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void checkValid() {
    checkAll = false;
    for (int i = 0; i < basketList.length; i++) {
      if (checkStatus[i] == false) {
        checkAll = false;
        break;
      } else
        checkAll = true;
    }
    calcPrice();
  }

  void calcPrice() {
    amount = 0;
    discount_amount = 0;
    selectedCount = 0;
    for (int i = 0; i < basketList.length; i++) {
      if (checkStatus[i]) {
        amount = amount + doubleParse(basketList[i].price!) * int.parse(basketList[i].count!);
        discount_amount =
            discount_amount + doubleParse(basketList[i].price!) * doubleParse(basketList[i].discount!) / 100 * doubleParse(basketList[i].count!);
        selectedCount++;
      }
    }
    setState(() {});
  }

  void goOrder() {
    List<ProductDto> orderProduct = [];
    List<int> productCount = [];
    for (int i = 0; i < basketList.length; i++) {
      if (checkStatus[i]) {
        orderProduct.add(ProductDto(
            id: basketList[i].product_id,
            name: basketList[i].pdt_name,
            option: basketList[i].name,
            price: basketList[i].price,
            mainImage: basketList[i].main_image));
        productCount.add(int.parse(basketList[i].count!));
      }
    }
    OrderInfo orderInfo = OrderInfo(
        orderProduct, productCount, amount, discount_amount, shipping_fee, gUserInfo!.deliverAddress! + " " + gUserInfo!.deliverAddressDetail!);
    Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderPage(orderInfo: orderInfo, direct: 0)));
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

  Future<void> basket_list() async {
    setState(() {
      isLoading = true;
    });
    Future<BasketListResModel> info = httpService.getBasketList();
    info.then((BasketListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        shipping_fee = int.parse(value.data!.deliver_price!);
        basketList.addAll(value.data!.lists!);

        List.generate(basketList.length, (index) => checkStatus.add(false));
        for (int i = 0; i < basketList.length; i++) {
          var textEditingController = TextEditingController(text: basketList[i].count.toString());
          textEditingControllers.add(textEditingController);
        }
        setState(() {});
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

  Future<void> basket_deletes(String basket_ids) async {
    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> info = httpService.basketDelete(basket_ids);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        for (int i = 0; i < basket_ids.split(',').length; i++) {
          basketList.removeWhere((element) => element.id == basket_ids.split(',')[i]);
        }
        checkValid();
        setState(() {});
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

  Future<void> basket_change(int index, int step) async {
    // basketList[index].count = (int.parse(basketList[index].count!) - 1).toString();
    // textEditingControllers[index].text = basketList[index].count.toString();
    // calcPrice();

    // basketList[index].count = (int.parse(basketList[index].count!) + 1).toString();
    // textEditingControllers[index].text = basketList[index].count.toString();
    // calcPrice();

    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> info = httpService.changeBakset(basketList[index].id!, int.parse(basketList[index].count!) + step);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        setState(() {
          basketList[index].count = (int.parse(basketList[index].count!) + step).toString();
          textEditingControllers[index].text = basketList[index].count.toString();
          calcPrice();
        });
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
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("shopping_basket"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, SlideRightTransRoute(builder: (context) => EditShippingAddressPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/ic_loctaion.png',
                                width: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: H16(
                                      align: TextAlign.start,
                                      text: gUserInfo!.deliverAddress! + " " + gUserInfo!.deliverAddressDetail!,
                                      weight: FW.regular,
                                      maxLine: 2)),
                              Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  'assets/Path 12638.png',
                                  height: 15,
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: const BoxDecoration(color: AppColor_Light_Gray),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      checkAll = !checkAll;
                                      for (int i = 0; i < basketList.length; i++) {
                                        checkStatus[i] = checkAll;
                                      }
                                    });
                                    calcPrice();
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(checkAll ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', height: 22),
                                      const SizedBox(width: 8),
                                      H18(
                                          text: sprintf("%s (%s/%s)",
                                              [LanguageService.trans("select_all"), selectedCount.toString(), basketList.length.toString()]),
                                          weight: FW.medium)
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      String basket_ids = '';
                                      for (int i = 0; i < basketList.length; i++) {
                                        if (checkStatus[i]) {
                                          basket_ids += basketList[i].id! + ',';
                                        }
                                      }
                                      if (basket_ids.isNotEmpty) {
                                        basket_ids = basket_ids.substring(0, basket_ids.length - 1);
                                        basket_deletes(basket_ids);
                                      }
                                    },
                                    child: H14(text: LanguageService.trans("delete_selection"), weight: FW.medium))
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: [
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              checkStatus[index] = !checkStatus[index];
                                            });
                                            checkValid();
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                  checkAll
                                                      ? 'assets/ic_radio_on.png'
                                                      : (checkStatus[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png'),
                                                  height: 22),
                                              const SizedBox(width: 8),
                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                H18(text: basketList[index].name ?? "", weight: FW.medium),
                                                const SizedBox(height: 5),
                                                H16(text: basketList[index].pdt_name ?? "", weight: FW.medium, color: AppColor_GrayText)
                                              ])
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            basket_deletes(basketList[index].id!);
                                          },
                                          child: Opacity(opacity: 0.3, child: Image.asset('assets/clear_black_24dp.png', width: 17)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          children: [
                                            basketList[index].main_image!.isNotEmpty
                                                ? ExtendedImage.network(basketList[index].main_image!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.fill,
                                                    cache: true,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)))
                                                : Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: const BoxDecoration(
                                                        color: AppColor_f4f5f7, borderRadius: BorderRadius.all(Radius.circular(12))),
                                                  ),
                                            const SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    H18(text: sprintf("%s 원", [ValidPrice(basketList[index].price ?? "0")])),
                                                    const SizedBox(width: 16),
                                                    Visibility(
                                                      visible: basketList[index].discount != "0",
                                                      child: H18(text: sprintf("%s%", [ValidPrice(basketList[index].discount ?? "0")]), color: AppColor_Red),
                                                    ),

                                                  ],
                                                ),
                                                const SizedBox(height: 40),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (int.parse(basketList[index].count ?? "0") > 1) {
                                                            basket_change(index, -1);
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          alignment: Alignment.center,
                                                          decoration: const BoxDecoration(
                                                              color: AppColor_Light_Gray,
                                                              borderRadius:
                                                                  BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                                          child: Center(
                                                            child: H20(text: "-", weight: FW.regular),
                                                          )),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      width: 50,
                                                      decoration: const BoxDecoration(
                                                        color: AppColor_Light_Gray,
                                                      ),
                                                      child: Center(
                                                        child: TextField(
                                                            textInputAction: TextInputAction.done,
                                                            controller: textEditingControllers[index],
                                                            style: AppTextStyle.PD(Colors.black, 20, weight: FW.regular, height: 1.0),
                                                            textAlign: TextAlign.center,
                                                            readOnly: true,
                                                            decoration: const InputDecoration(border: InputBorder.none)),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (int.parse(basketList[index].count ?? "0") <
                                                              int.parse(basketList[index].max_cnt ?? "0")) {
                                                            basket_change(index, 1);
                                                          } else {
                                                            showToast('${int.parse(basketList[index].max_cnt!)}개까지 선택 가능합니다.');
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          alignment: Alignment.center,
                                                          decoration: const BoxDecoration(
                                                              color: AppColor_Light_Gray,
                                                              borderRadius:
                                                                  BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                                          child: Center(
                                                            child: H20(text: "+", weight: FW.regular),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                    const SizedBox(height: 30),
                                    const Divider(color: AppColor_Gray, thickness: 1),
                                  ]);
                                },
                                itemCount: basketList.length),
                          ],
                        )),
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: const BoxDecoration(color: AppColor_Light_Gray),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
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
                                text: sprintf("%s %s", [ValidPrice(amount.toString()), "원"]),
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
                                text: sprintf("- %s %s", [ValidPrice(discount_amount.toString()), "원"]),
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
                                text: sprintf("+ %s %s", [ValidPrice(shipping_fee.toString()), "원"]),
                                weight: FW.regular,
                                color: AppColor_BlackText,
                              ),
                            ],
                          ),
                          // const SizedBox(height: 20),
                          // Align(alignment: Alignment.bottomRight, child: H14(text: LanguageService.trans("free_shipping"), weight: FW.regular, color: AppColor_Primary)),
                          const SizedBox(height: 30),
                          const Divider(color: Colors.black, height: 1),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H18(
                                text: LanguageService.trans("amount_to_be_paid"),
                                weight: FW.bold,
                                color: AppColor_BlackText,
                              ),
                              const SizedBox(width: 20),
                              H18(
                                text: sprintf("%s %s", [ValidPrice((amount - discount_amount + shipping_fee).toString()), "원"]),
                                weight: FW.bold,
                                color: AppColor_BlackText,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: SubstringHighlight(
                                text: '${getPayPoint(amount - discount_amount + shipping_fee, "PAY_POINT")} ' +
                                    LanguageService.trans("expected_to_earn"),
                                term: '${getPayPoint(amount - discount_amount + shipping_fee, "PAY_POINT")} 우아포인트',
                                textStyle: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                                textStyleHighlight: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium),
                              )),
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: SubstringHighlight(
                                text: LanguageService.trans("grace_points"),
                                term: '우아 포인트',
                                textStyle: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                                textStyleHighlight: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium),
                              )),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MainTextButton(
              text: selectedCount == 0 ? "주문하기" : sprintf("%s원 주문하기", [ValidPrice((amount - discount_amount + shipping_fee).toString())]),
              height: 80,
              backgroundColor: AppColor_Primary,
              radius: 0,
              style: AppTextStyle.PD(Colors.white, 20, weight: FW.bold),
              onPressed: () {
                if (selectedCount > 0) goOrder();
              },
              disable: selectedCount == 0,
              disableBackground: AppColor_Primary_Disable,
            ),
          ],
        ));
  }
}
