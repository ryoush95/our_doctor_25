import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/order_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/my/order_cancel.dart';
import 'package:ourdoctor/pages/my/order_exchange.dart';
import 'package:ourdoctor/pages/my/order_sheet.dart';
import 'package:ourdoctor/pages/my/review_select_product.dart';
import 'package:sprintf/sprintf.dart';

import 'delivery_tracking_dialog.dart';
import 'purchase_confirm_dialog.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  OrderHistoryPageState createState() => OrderHistoryPageState();
}

class OrderHistoryPageState extends BaseState<OrderHistoryPage> {
  final HttpService httpService = HttpService();
  late ScrollController _scrollController;
  late ScrollController _listController;
  late ScrollController _listController1;

  int nTabIndex = 0;
  bool isLast = false;
  int nPage = 0;
  List<OrderDto> orderList = [];
  List<String> orderStatus = [
    '삭제', //0.삭제
    LanguageService.trans("checking_deposit_without_bankbook"), //1.시작
    LanguageService.trans("payment_complete"), //2.결제완료
    LanguageService.trans("shipping"), //3.배송중
    LanguageService.trans("delivery_completed"), //4.배송완료
    LanguageService.trans("purchase_confirmation"), //5.확인완료
    '취소', //6.취소
  ];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _listController1 = ScrollController();
    _scrollController = ScrollController()..addListener(loadMore);

    eventBus.on<OrderHistoryEvent>().listen((event) {
      if (mounted) {
        nPage = 0;
        getOrders();
      }
    });
    getOrders();
  }

  void loadMore() {
    if (!isLoading) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getOrders();
      }
    }
  }

  Future<void> getOrders() async {
    setState(() {
      isLoading = true;
    });
    int length = 8;
    Future<OrderListResModel> info = httpService.getUserOrders((nPage * 8).toString(), length.toString());
    info.then((OrderListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && orderList.isNotEmpty) {
          orderList.clear();
        }
        isLast = value.data!.isLast!;
        orderList.addAll(value.data!.lists!);
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

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void onDeliveryTracking(OrderDto order) {
    if (order.deliverCompany!.isEmpty && order.deliverNumber!.isEmpty) {
      showToast('배송정보가 존재하지 않습니다.');
      return;
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return DeliveryTrackingDialog(deliverCompany: order.deliverCompany!, deliverNumber: order.deliverNumber!);
        });
  }

  void onPurchaseConfirm(String id) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return PurchaseConfirmDialog(
            orderId: id,
          );
        });
  }

  void onExchangeReturn(OrderDto order) {
    if (order.exchangeAction!.isEmpty) {
      //교환,반품이 아닌 경우에만 신청페이지를 보여준다.
      Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderExchangePage(order: order)));
    }
  }

  String getExchangeReturnStatus(OrderDto order) {
    if (order.exchangeAction!.isNotEmpty) {
      if (order.exchangeAction! == "EXCHANGE") {
        if (order.exchangeStatus! == "1") {
          return "교환 신청중";
        } else if (order.exchangeStatus! == "2") {
          return "교환 배송중";
        } else if (order.exchangeStatus! == "3") {
          return "교환완료";
        }
      } else {
        if (order.exchangeStatus! == "1") {
          return "반품 신청중";
        } else if (order.exchangeStatus! == "2") {
          return "반품 배송중";
        } else if (order.exchangeStatus! == "3") {
          return "반품완료";
        }
      }
    }
    return "";
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listController.dispose();
    _listController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("order_history"),
              onBackPressed: onBackPressed,
            ),
            Visibility(
              visible: false,
              child: SizedBox(
                height: 45,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          nTabIndex = 0;
                          nPage = 0;
                          getOrders();
                        });
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Center(
                              child: H14(
                                text: '전체',
                                weight: FW.medium,
                                align: TextAlign.center,
                                color: nTabIndex == 0 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: nTabIndex == 0 ? 2 : 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    color: AppColor_BlackText,
                                  )),
                              bottom: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          nTabIndex = 1;
                          nPage = 0;
                          getOrders();
                        });
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Center(
                              child: H14(
                                text: '성장스토어',
                                weight: FW.medium,
                                align: TextAlign.center,
                                color: nTabIndex == 1 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: nTabIndex == 1 ? 2 : 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    color: AppColor_BlackText,
                                  )),
                              bottom: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          nTabIndex = 2;
                          nPage = 0;
                          getOrders();
                        });
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Center(
                              child: H14(
                                text: '발달클래스',
                                weight: FW.medium,
                                align: TextAlign.center,
                                color: nTabIndex == 2 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: nTabIndex == 2 ? 2 : 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    color: AppColor_BlackText,
                                  )),
                              bottom: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: _itemBuilder,
                      itemCount: orderList.length,
                      controller: _listController1,
                    ),
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
        const Divider(thickness: 10, color: AppColor_Light_Gray),
        Container(
            width: screenSize.width,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderSheetPage(orderId: orderList[index].id)));
                    },
                    child: SizedBox(
                      height: 30,
                      child: Row(children: [
                        H16(
                          text: orderList[index].addDate!,
                        ),
                        Expanded(child: Container()),
                        Image.asset('assets/chevron_right_black_24dp.png', width: 24),
                      ]),
                    )),
                const Divider(thickness: 1, color: AppColor_Light_Gray),
                const SizedBox(height: 20),
                H16(text: orderStatus[int.parse(orderList[index].status!)], color: AppColor_Primary, weight: FW.medium),
                const SizedBox(height: 10),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderList[index].productList!.length,
                    controller: _listController,
                    itemBuilder: (BuildContext context, int ind) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              orderList[index].productList![ind].mainImage!.isNotEmpty
                                  ? ExtendedImage.network(orderList[index].productList![ind].mainImage!,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.fill,
                                      cache: true,
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(Radius.circular(12)))
                                  : Container(
                                      width: 75,
                                      height: 75,
                                      decoration: const BoxDecoration(color: AppColor_f4f5f7, borderRadius: BorderRadius.all(Radius.circular(12))),
                                    ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    H16(text: orderList[index].productList![ind].name!, weight: FW.regular, color: AppColor_414141),
                                    const SizedBox(height: 5),
                                    H16(text: orderList[index].productList![ind].optionName!, weight: FW.regular, color: AppColor_Table_DateTime),
                                    const SizedBox(height: 15),
                                    H16(
                                        text: sprintf("%s원", [ValidPrice(orderList[index].productList![ind].payPrice!.toString())]),
                                        weight: FW.bold,
                                        color: AppColor_414141),
                                  ],
                                ),
                              )
                              //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
                            ],
                          ),
                          const SizedBox(height: 10)
                        ],
                      );
                    }),
                const SizedBox(height: 15),
                Visibility(
                  visible: (int.parse(orderList[index].status!) == 1 || int.parse(orderList[index].status!) == 2), //시작, 결제완료
                  child: Row(
                    children: [
                      MainTextButton(
                        text: LanguageService.trans("order_cancellation"),
                        width: screenSize.width - 60,
                        height: 35,
                        radius: 10,
                        backgroundColor: AppColor_White,
                        showBorder: true,
                        borderColor: AppColor_Gray,
                        style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                        onPressed: () {
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderCancelPage(order: orderList[index])));
                        },
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: (int.parse(orderList[index].status!) == 3 || int.parse(orderList[index].status!) == 4), //배송중,배송완료
                  child: Row(
                    children: [
                      MainTextButton(
                        text: LanguageService.trans("delivery_tracking"),
                        width: (screenSize.width - 70) / 3,
                        height: 35,
                        radius: 10,
                        backgroundColor: AppColor_White,
                        showBorder: true,
                        borderColor: AppColor_Gray,
                        style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                        onPressed: () {
                          onDeliveryTracking(orderList[index]);
                        },
                      ),
                      const SizedBox(width: 5),
                      MainTextButton(
                        text: LanguageService.trans("purchase_confirm"),
                        width: (screenSize.width - 70) / 3,
                        height: 35,
                        radius: 10,
                        backgroundColor: AppColor_White,
                        showBorder: true,
                        borderColor: AppColor_Gray,
                        style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                        onPressed: () {
                          onPurchaseConfirm(orderList[index].id!);
                        },
                      ),
                      const SizedBox(width: 5),
                      MainTextButton(
                        text: getExchangeReturnStatus(orderList[index]).isEmpty ? '교환/반품' : getExchangeReturnStatus(orderList[index]),
                        width: (screenSize.width - 70) / 3,
                        height: 35,
                        radius: 10,
                        backgroundColor: AppColor_White,
                        showBorder: true,
                        borderColor: AppColor_Gray,
                        style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                        onPressed: () {
                          onExchangeReturn(orderList[index]);
                        },
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: int.parse(orderList[index].status!) == 5, //확인완료(구매확정)
                  child: Row(
                    children: [
                      MainTextButton(
                        text: LanguageService.trans("delivery_tracking"),
                        width: (screenSize.width - 65) / 2,
                        height: 35,
                        radius: 10,
                        backgroundColor: AppColor_White,
                        showBorder: true,
                        borderColor: AppColor_Gray,
                        style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                        onPressed: () {
                          onDeliveryTracking(orderList[index]);
                        },
                      ),
                      /*const SizedBox(width: 5),
                      MainTextButton(
                        text: '수강하기',
                        width: (screenSize.width - 70) / 3,
                        height: 35,
                        radius: 10,
                        backgroundColor: Color(0xFFF4F9FF),
                        showBorder: true,
                        borderColor: Color(0xFFC9E2FF),
                        style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.regular),
                        onPressed: () {

                        },
                      ),*/
                      const SizedBox(width: 5),
                      MainTextButton(
                        text: LanguageService.trans("review_write"),
                        width: (screenSize.width - 65) / 2,
                        height: 35,
                        radius: 10,
                        backgroundColor: AppColor_White,
                        showBorder: true,
                        borderColor: AppColor_Gray,
                        style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
                        onPressed: () {
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => ReviewSelectProductPage(order: orderList[index])));
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ))
      ],
    );
  }
// Widget itemBuilder(BuildContext context, int index) {
//   var screenSize = MediaQuery.of(context).size;
//   return Column(
//     children: [
//       Row(
//         children: [
//           Container(
//             height:75,
//             width: 75,
//             decoration: const BoxDecoration(
//                 color: AppColor_White,
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//                 image: DecorationImage(image: AssetImage
//                   ("assets/image_9.png"), fit: BoxFit.cover)
//             ),
//             //child: Image.asset("assets/ic_guide_logo.png")
//           ),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               H16(text: "product name", weight: FW.regular, color: AppColor_414141),
//               const SizedBox(height: 5),
//               H16(text: "option", weight: FW.regular, color: AppColor_Table_DateTime),
//               const SizedBox(height: 15),
//               H16(text: "7,600won", weight: FW.bold, color: AppColor_414141),
//             ],
//           )
//           //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
//         ],
//       ),
//       const SizedBox(height: 10)
//     ],
//   );
// }
}
