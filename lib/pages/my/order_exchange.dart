import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/models/order_list_res_model.dart';
import 'package:ourdoctor/pages/alarm/alarm.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/my/order_cancel_complete.dart';
import 'package:ourdoctor/pages/my/order_exchange_reason.dart';
import 'package:ourdoctor/pages/my/order_sheet.dart';
import 'package:sprintf/sprintf.dart';
import 'delivery_tracking_dialog.dart';
import 'purchase_confirm_dialog.dart';

class OrderExchangePage extends StatefulWidget {
  final OrderDto order;

  OrderExchangePage({Key? key, required this.order}) : super(key: key);

  @override
  OrderExchangePageState createState() => OrderExchangePageState();
}

class OrderExchangePageState extends BaseState<OrderExchangePage> {
  final HttpService httpService = HttpService();
  late ScrollController _scrollController;
  late ScrollController _listController;
  late ScrollController _listController1;

  List<bool> checkStatus = [];
  List<int> selectCount = [];
  bool isLast = false;
  int nPage = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.order.productList!.length; i++) {
      checkStatus.add(false);
      selectCount.add(int.parse(widget.order.productList![i].optionCnt!));
    }

    _listController = ScrollController();
    _listController1 = ScrollController();
    _scrollController = ScrollController()..addListener(loadMore);
  }

  void loadMore() {
    if (!isLoading) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
      }
    }
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
    _scrollController.dispose();
    _listController.dispose();
    _listController1.dispose();
    super.dispose();
  }

  List<String> getCountArray(int max) {
    List<String> arr = [];
    for (int i = 0; i < max; i++) {
      arr.add("${i + 1}개");
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: H18(
                            text: LanguageService.trans('select_product'),
                            weight: FW.bold,
                            align: TextAlign.start,
                            height: 1.2,
                          )),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: _itemBuilder,
                        itemCount: widget.order.productList!.length,
                        controller: _listController1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: MainTextButton(
                text: LanguageService.trans('next_step'),
                backgroundColor: AppColor_Primary,
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.semi_bold),
                height: 55,
                disable: checkStatus.where((element) => element).toList().isEmpty,
                disableBackground: AppColor_Primary_Disable,
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => OrderExchangeReasonPage(order: widget.order, checkStatus: checkStatus, selectCount: selectCount)));
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          checkStatus[index] = !checkStatus[index];
                        });
                      },
                      child: Image.asset(checkStatus[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', height: 22),
                    ),
                    const SizedBox(width: 20),
                    widget.order.productList![index].mainImage!.isNotEmpty
                        ? ExtendedImage.network(widget.order.productList![index].mainImage!,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: widget.order.productList![index].name!, weight: FW.regular, color: AppColor_414141),
                        const SizedBox(height: 5),
                        H16(text: widget.order.productList![index].optionName!, weight: FW.regular, color: AppColor_Table_DateTime),
                      ],
                    )
                    //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
                  ],
                ),
                Visibility(visible: checkStatus[index], child: const SizedBox(height: 10)),
                Visibility(
                  visible: checkStatus[index] && int.parse(widget.order.productList![index].optionCnt!) > 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      H16(text: "${widget.order.productList![index].optionCnt!}개 중", weight: FW.regular, color: AppColor_414141),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: SelectorBox(
                            selectedCategory: getCountArray(int.parse(widget.order.productList![index].optionCnt!)).last,
                            categoryList: getCountArray(int.parse(widget.order.productList![index].optionCnt!)),
                            onSelect: (selectedCategory) {
                              selectCount[index] = int.parse(selectedCategory!.substring(0, selectedCategory.length - 1));
                              setState(() {});
                            },
                            hint: ""),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: checkStatus[index] && int.parse(widget.order.productList![index].optionCnt!) == 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      H16(text: "1개", weight: FW.regular, color: AppColor_414141),
                    ],
                  ),
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
