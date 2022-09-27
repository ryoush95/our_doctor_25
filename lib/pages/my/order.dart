import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/order_start_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_input.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/my/payment.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'order_complete.dart';
import 'profile_item1.dart';

class OrderInfo {
  final List<ProductDto> productList;
  final List<int> productCount;
  final double amount;
  final double discountAmount;
  final int shippingFee;
  final shippingAddress;

  OrderInfo(this.productList, this.productCount, this.amount, this.discountAmount, this.shippingFee, this.shippingAddress);
}

class OrderPage extends StatefulWidget {
  OrderPage({Key? key, required this.orderInfo, required this.direct}) : super(key: key);
  OrderInfo orderInfo;
  final int direct;

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends BaseState<OrderPage> {
  final HttpService httpService = HttpService();
  late ScrollController _listController;

  bool showInformation = false;
  bool showProduct = false;
  String ua_point = "0";
  var pointInputController = TextEditingController();
  bool isUsed = true;
  int card = 0;
  bool isRequired = false;
  bool isValid = false;
  String card_name = "";
  List<String> cardList = [];
  OrderInfo? order;

  bool bDlgAgree = false;
  String? strAgreeTitle = "";
  String? strAgreeUrl = "";
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    LocalService.getPaymentCard().then((value) {
      setState(() {
        card = value;
      });
    });

    order = widget.orderInfo;
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
    _listController.dispose();
    super.dispose();
  }

  void checkPoint() {
    setState(() {});
  }

  Future<void> goPay() async {
    if (int.parse(ua_point == "" ? "0" : ua_point) > int.parse(gUserInfo!.point ?? "0")) {
      showToast('우아포인트는 ${int.parse(gUserInfo!.point ?? "0")}까지 사용가능합니다.');
      return;
    }

    Map<String, String> deliver_address = {'addr': gUserInfo!.deliverAddress!, 'detail': gUserInfo!.deliverAddressDetail!, 'postcode': gUserInfo!.deliverPostcode!};
    String str_deliver = json.encode(deliver_address);

    List<Map<String, String>> pdtInfo = [];
    for (int i = 0; i < order!.productList.length; i++) {
      Map<String, String> info = {
        'id': order!.productList.elementAt(i).id!,
        'name': order!.productList.elementAt(i).name!,
        'price': order!.productList.elementAt(i).price!,
        'discount': order!.productList[i].discount ?? "0",
        'count': order!.productCount[i].toString(),
      };
      pdtInfo.add(info);
    }
    String strPdtInfo = json.encode(pdtInfo);

    Future<OrderStartResModel> offerInfo = httpService.orderStart(strPdtInfo, ua_point, card == 1 ? "CARD" : (card == 2 ? "TRANS" : "PHONE"), str_deliver);

    offerInfo.then((OrderStartResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (value.data!.merchantUid != null) {
          Navigator.push(
            context,
            SlideRightTransRoute(
                builder: (context) =>
                    PaymentPage(payMethod: card == 1 ? "CARD" : (card == 2 ? "TRANS" : "PHONE"), merchantUid: value.data!.merchantUid, orderID: value.data!.id, totalMoney: (order!.amount - order!.discountAmount + order!.shippingFee - int.parse(ua_point == "" ? "0" : ua_point)).toInt())),
          );
        } else {
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => OrderCompletePage(orderID: value.data!.id)));
        }
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

  checkValid() {
    if (isRequired == false || card == 0) {
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }
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

  void showAgreeDlg(int type) async {
    if (type == 1) {
      strAgreeTitle = "서비스 이용약관";
      // strAgreeUrl = API_BASE_URL + "api/common/term?type=term";
      strAgreeUrl = TERMS_URL;
    } else if (type == 2) {
      strAgreeTitle = "개인정보 처리방침";
      // strAgreeUrl = API_BASE_URL + "api/common/term?type=privacy";
      strAgreeUrl = POLICY_URL;
    }
    bDlgAgree = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  SimpleHeader(
                    title: LanguageService.trans("order"),
                    onBackPressed: onBackPressed,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(children: [
                                const SizedBox(height: 40),
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
                                      Visibility(
                                        visible: !showProduct,
                                        child: Row(children: [
                                          H16(text: '${order!.productList.length}개', weight: FW.regular),
                                          const SizedBox(width: 15),
                                        ]),
                                      ),
                                      Image.asset(showProduct ? 'assets/group_20046.png' : 'assets/Down-Small.png', width: 15),
                                    ])),
                                const SizedBox(height: 20),
                                Visibility(visible: showProduct, child: ListView.builder(shrinkWrap: true, itemBuilder: _itemBuilder, itemCount: order!.productList.length, controller: _listController))
                              ])),
                          const Divider(thickness: 10, color: AppColor_Light_Gray),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  InkWell(
                                      onTap: () {
                                        showInformation = !showInformation;
                                        setState(() {});
                                      },
                                      child: Row(children: [
                                        H16(
                                          text: LanguageService.trans("orderer_information"),
                                        ),
                                        Expanded(child: Container()),
                                        Visibility(
                                            visible: !showInformation,
                                            child: Row(
                                              children: [
                                                H16(text: sprintf("%s, %s", [gUserInfo!.nickname, gUserInfo!.phone]), weight: FW.regular),
                                                const SizedBox(width: 10),
                                              ],
                                            )),
                                        Image.asset(showInformation ? 'assets/group_20046.png' : 'assets/Down-Small.png', width: 15),
                                      ])),
                                  const SizedBox(height: 20),
                                  Visibility(
                                      visible: showInformation,
                                      child: Column(
                                        children: [ProfileItem1(title: LanguageService.trans("orderer"), content: gUserInfo!.nickname!), const SizedBox(height: 15), ProfileItem1(title: LanguageService.trans("mobile"), content: gUserInfo!.phone!), const SizedBox(height: 15)],
                                      ))
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
                                  // const SizedBox(height: 15),
                                  // H16(
                                  //   text: sprintf("%s, %s", [gUserInfo!.nickname, gUserInfo!.phone]),
                                  //   weight: FW.regular,
                                  //   color: AppColor_BlackText,
                                  //   align: TextAlign.left,
                                  // ),
                                  const SizedBox(height: 20),
                                  const Divider(thickness: 2, color: AppColor_Light_Gray),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Image.asset('assets/ic_loctaion.png', width: 15),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: H16(
                                          text: order!.shippingAddress,
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
                                    text: LanguageService.trans("ua_point"),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        width: screenSize.width - 160,
                                        child: OutlineInput(
                                          controller: pointInputController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          //onEditingComplete: () => node.nextFocus(),
                                          placeholder: LanguageService.trans("0"),
                                          onChanged: (text) => {ua_point = text, checkPoint()},
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      MainTextButton(
                                        text: LanguageService.trans("use_all"),
                                        width: 90,
                                        showBorder: true,
                                        backgroundColor: AppColor_White,
                                        borderColor: AppColor_Gray,
                                        onPressed: () {
                                          if (gUserInfo!.point! == "0" || gUserInfo!.point! == "") {
                                            showToast("사용가능한 포인트가 없습니다.");
                                            return;
                                          }
                                          ua_point = gUserInfo!.point!;
                                          pointInputController.text = gUserInfo!.point!;
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      H14(text: "사용 가능 우아포인트 ", weight: FW.regular, color: AppColor_BlackText.withOpacity(0.6)),
                                      H16(text: ValidPrice(gUserInfo!.point!), weight: FW.semi_bold, color: AppColor_BlackText.withOpacity(0.6)),
                                      H14(text: "원", weight: FW.regular, color: AppColor_BlackText.withOpacity(0.6)),
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
                                    text: LanguageService.trans("payment_method"),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    MainTextButton(
                                      text: LanguageService.trans("card"),
                                      height: 45,
                                      width: (screenSize.width - 70) / 3,
                                      style: AppTextStyle.PD(card == 1 ? Colors.white : Colors.black, 14, weight: FW.medium),
                                      showBorder: card == 1 ? false : true,
                                      borderColor: AppColor_Gray,
                                      backgroundColor: card == 1 ? AppColor_Primary : AppColor_White,
                                      onPressed: () {
                                        card = 1;
                                        setState(() {});
                                        checkValid();
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    MainTextButton(
                                      text: LanguageService.trans("deposit_without_bankbook"),
                                      height: 45,
                                      width: (screenSize.width - 70) / 3,
                                      style: AppTextStyle.PD(card == 2 ? Colors.white : Colors.black, 14, weight: FW.medium),
                                      showBorder: card == 2 ? false : true,
                                      borderColor: AppColor_Gray,
                                      backgroundColor: card == 2 ? AppColor_Primary : AppColor_White,
                                      onPressed: () {
                                        card = 2;
                                        setState(() {});
                                        checkValid();
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    MainTextButton(
                                      text: LanguageService.trans("mobile"),
                                      height: 45,
                                      width: (screenSize.width - 70) / 3,
                                      style: AppTextStyle.PD(card == 3 ? Colors.white : Colors.black, 14, weight: FW.medium),
                                      showBorder: card == 3 ? false : true,
                                      borderColor: AppColor_Gray,
                                      backgroundColor: card == 3 ? AppColor_Primary : AppColor_White,
                                      onPressed: () {
                                        card = 3;
                                        setState(() {});
                                        checkValid();
                                      },
                                    ),
                                  ]),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      isUsed = !isUsed;
                                      LocalService.setPaymentCard(isUsed ? card : 0);
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 25,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            isUsed ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png',
                                            width: 24,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 10),
                                          H16(
                                            text: LanguageService.trans("use_your_chosen_payment_method_also_for"),
                                            weight: FW.regular,
                                            height: 1.3,
                                            color: isUsed ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                    text: LanguageService.trans("amount_of_payment"),
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
                                        text: sprintf("%s %s", [ValidPrice(order!.amount.toString()), "원"]),
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
                                        text: sprintf("-%s %s", [ValidPrice(order!.discountAmount.toString()), "원"]),
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
                                        text: sprintf("+ %s %s", [ValidPrice(order!.shippingFee.toString()), "원"]),
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
                                        text: sprintf("- %s %s", [ValidPrice(ua_point), "원"]),
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
                                        text: sprintf("%s %s", [ValidPrice((order!.amount - order!.discountAmount + order!.shippingFee - int.parse(ua_point == "" ? "0" : ua_point)).toString()), "원"]),
                                        weight: FW.bold,
                                        color: AppColor_BlackText,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SubstringHighlight(
                                        text: '${getPayPoint((order!.amount - order!.discountAmount + order!.shippingFee - int.parse(ua_point == "" ? "0" : ua_point)), "PAY_POINT")} 우아포인트 적립',
                                        term: '${getPayPoint((order!.amount - order!.discountAmount + order!.shippingFee - int.parse(ua_point == "" ? "0" : ua_point)), "PAY_POINT")} 우아포인트',
                                        textStyle: AppTextStyle.PD(AppColor_707071, 14, weight: FW.regular),
                                        textStyleHighlight: AppTextStyle.PD(AppColor_707071, 14, weight: FW.medium),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20)
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
                                  InkWell(
                                    onTap: () {
                                      isRequired = !isRequired;
                                      setState(() {});
                                      checkValid();
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            isRequired ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png',
                                            width: 24,
                                            height: 24,
                                          ),
                                          const SizedBox(width: 10),
                                          H16(
                                            text: LanguageService.trans("required_consent_to_proceed_with_payment"),
                                            weight: FW.medium,
                                            height: 1.3,
                                            color: isRequired ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                                            maxLine: 2,
                                            align: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  InkWell(
                                    onTap: () {
                                      showAgreeDlg(1);
                                    },
                                    child: Row(children: [
                                      H14(text: LanguageService.trans("order_agree_1"), color: AppColor_414141, weight: FW.regular),
                                      Expanded(child: Container()),
                                      Image.asset("assets/chevron_right_black_24dp.png", width: 24),
                                    ]),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      showAgreeDlg(2);
                                    },
                                    child: Row(children: [
                                      H14(text: LanguageService.trans("order_agree_2"), color: AppColor_414141, weight: FW.regular),
                                      Expanded(child: Container()),
                                      Image.asset("assets/chevron_right_black_24dp.png", width: 24),
                                    ]),
                                  ),
                                  const SizedBox(height: 45)
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  MainTextButton(
                    text: /*isRequired == false ? LanguageService.trans("please_agree_to_the_payment_process_required") : */ sprintf("%s원 결제하기", [ValidPrice((order!.amount - order!.discountAmount + order!.shippingFee - int.parse(ua_point == "" ? "0" : ua_point)).toString())]),
                    backgroundColor: AppColor_Primary,
                    style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                    radius: 0,
                    height: 78,
                    disable: !isValid,
                    disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                    onPressed: () {
                      if (!isValid) {
                        return;
                      }
                      goPay();
                    },
                  ),
                ],
              ),
              Visibility(
                visible: bDlgAgree,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                height: 80,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: H22(
                                        text: strAgreeTitle,
                                        height: 1.3,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bDlgAgree = false;
                                        setState(() {});
                                      },
                                      child: H16(
                                        text: LanguageService.trans("close"),
                                        weight: FW.medium,
                                        height: 1.3,
                                        color: AppColor_Primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: InAppWebView(
                                  initialOptions: options,
                                  initialUrlRequest: URLRequest(url: Uri.parse(strAgreeUrl!)),
                                  onLoadStart: (controller, url) => {
                                    setState(() {
                                      isLoading = true;
                                    })
                                  },
                                  onLoadStop: (controller, url) => {
                                    setState(() {
                                      isLoading = false;
                                    })
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                    order!.productList[index].mainImage!.isNotEmpty
                        ? ExtendedImage.network(order!.productList[index].mainImage!, width: 75, height: 75, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(12)))
                        : Container(
                            width: 75,
                            height: 75,
                            decoration: const BoxDecoration(color: AppColor_f4f5f7, borderRadius: BorderRadius.all(Radius.circular(12))),
                          ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: order!.productList[index].option!, weight: FW.regular, color: AppColor_414141),
                        const SizedBox(height: 5),
                        H16(text: order!.productList[index].name!, weight: FW.regular, color: AppColor_Table_DateTime),
                        const SizedBox(height: 15),
                        H16(text: sprintf("%s%s | %s개", [ValidPrice(order!.productList[index].price!), "원", order!.productCount[index].toString()]), weight: FW.bold, color: AppColor_414141),
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
