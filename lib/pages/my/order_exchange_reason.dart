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
import 'package:ourdoctor/pages/my/order_exchange_request.dart';
import 'package:ourdoctor/pages/my/order_sheet.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'delivery_tracking_dialog.dart';
import 'purchase_confirm_dialog.dart';

class OrderExchangeReasonPage extends StatefulWidget {
  final OrderDto order;
  final List<bool> checkStatus;
  final List<int> selectCount;

  OrderExchangeReasonPage({Key? key, required this.order, required this.checkStatus, required this.selectCount}) : super(key: key);

  @override
  OrderExchangeReasonPageState createState() => OrderExchangeReasonPageState();
}

class OrderExchangeReasonPageState extends BaseState<OrderExchangeReasonPage> {
  List<bool> checkStatus = [false, false, false, false, false, false, false, false];
  List<String> reasonList = [
    LanguageService.trans('exchange_reason_1'),
    LanguageService.trans('exchange_reason_2'),
    LanguageService.trans('exchange_reason_3'),
    LanguageService.trans('exchange_reason_4'),
    LanguageService.trans('exchange_reason_5'),
    LanguageService.trans('exchange_reason_6'),
    LanguageService.trans('exchange_reason_7'),
    LanguageService.trans('exchange_reason_8'),
  ];
  String content = "";

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: H18(
                            text: LanguageService.trans('tell_exchange_reason'),
                            weight: FW.bold,
                            align: TextAlign.start,
                            height: 1.2,
                          )),
                      H14(
                        text: LanguageService.trans('exchange_type_1'),
                        weight: FW.medium,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      const SizedBox(height: 2),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _itemBuilder(context, index, 0);
                        },
                        itemCount: 3,
                      ),
                      const SizedBox(height: 60),
                      H14(
                        text: LanguageService.trans('exchange_type_2'),
                        weight: FW.medium,
                        align: TextAlign.start,
                        height: 1.2,
                      ),
                      const SizedBox(height: 2),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _itemBuilder(context, index, 3);
                        },
                        itemCount: 5,
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: checkStatus.sublist(3).where((element) => element).toList().isNotEmpty,
                        child: Container(
                          height: 188,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.all(18),
                          child: Stack(
                            children: [
                              Visibility(
                                visible: content.isEmpty,
                                child: SubstringHighlight(
                                  text: sprintf("%s %s", [LanguageService.trans('required_input'), LanguageService.trans('exchange_detail_hint')]),
                                  term: LanguageService.trans('required_input'),
                                  textStyle: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium),
                                  textStyleHighlight: AppTextStyle.PD(AppColor_Red, 14, weight: FW.medium),
                                ),
                              ),
                              TextField(
                                style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: "",
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    content = text;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
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
                  int index = checkStatus.indexWhere((element) => element);
                  if (index > 2 && content.isEmpty) {
                    showToast('상품문제를 자세하게 입력해주세요.');
                    return;
                  }
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => OrderExchangeRequestPage(
                              order: widget.order,
                              checkStatus: widget.checkStatus,
                              selectCount: widget.selectCount,
                              reason1: reasonList[index],
                              reason2: index > 2 ? content : '')));
                },
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index, int start) {
    var screenSize = MediaQuery.of(context).size;
    var realIndex = index + start;

    return InkWell(
      onTap: () {
        setState(() {
          for (int i = 0; i < checkStatus.length; i++) {
            checkStatus[i] = false;
          }
          checkStatus[realIndex] = !checkStatus[realIndex];
        });
      },
      child: Column(
        children: [
          Container(
              width: screenSize.width,
              decoration: BoxDecoration(border: Border.all(color: AppColor_Gray), borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(checkStatus[realIndex] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', height: 22),
                      const SizedBox(width: 9),
                      Expanded(child: H16(text: reasonList[realIndex], weight: FW.regular, color: AppColor_414141, align: TextAlign.start)),
                    ],
                  ),
                ],
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
