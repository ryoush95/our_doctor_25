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
import 'package:ourdoctor/pages/my/review_write.dart';
import 'package:sprintf/sprintf.dart';
import 'delivery_tracking_dialog.dart';
import 'purchase_confirm_dialog.dart';

class ReviewSelectProductPage extends StatefulWidget {
  final OrderDto order;

  ReviewSelectProductPage({Key? key, required this.order}) : super(key: key);

  @override
  ReviewSelectProductPageState createState() => ReviewSelectProductPageState();
}

class ReviewSelectProductPageState extends BaseState<ReviewSelectProductPage> {
  final HttpService httpService = HttpService();
  late ScrollController _scrollController;
  late ScrollController _listController;
  late ScrollController _listController1;

  List<bool> checkStatus = [];
  bool isLast = false;
  int nPage = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.order.productList!.length; i++) {
      checkStatus.add(false);
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
              title: '후기 작성하기',
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
                text: '후기작성',
                backgroundColor: AppColor_Primary,
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.semi_bold),
                height: 55,
                disable: checkStatus.where((element) => element).toList().isEmpty,
                disableBackground: AppColor_Primary_Disable,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      SlideRightTransRoute(
                          builder: (context) =>
                              WriteReviewPage(pid: widget.order.productList![checkStatus.indexWhere((element) => element)].productId,
                              opid: widget.order.productList![checkStatus.indexWhere((element) => element)].orderProductId)));
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
                          for (int i = 0; i < checkStatus.length; i++) {
                            checkStatus[i] = false;
                          }
                          checkStatus[index] = true;
                        });
                      },
                      child: Image.asset(checkStatus[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', height: 22),
                    ),
                    const SizedBox(width: 20),
                    ExtendedImage.network(widget.order.productList![index].mainImage!,
                        width: 75,
                        height: 75,
                        fit: BoxFit.fill,
                        cache: true,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(12)), loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.failed:
                          return ExtendedImage.asset(
                            "assets/img_test1.png",
                            width: 100,
                            height: 100,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            fit: BoxFit.cover,
                          );
                        case LoadState.completed:
                        case LoadState.loading:
                          return null;
                      }
                    }),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          H16(text: widget.order.productList![index].name!, weight: FW.regular, color: AppColor_414141),
                          const SizedBox(height: 5),
                          H16(text: widget.order.productList![index].optionName!, weight: FW.regular, color: AppColor_Table_DateTime),
                        ],
                      ),
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
