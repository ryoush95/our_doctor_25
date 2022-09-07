import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/signup/address.dart';

class EditShippingAddressPage extends StatefulWidget {
  final void Function(String addr, String detail, String postcode)? onChanged;

  EditShippingAddressPage({Key? key, this.onChanged}) : super(key: key);

  @override
  EditShippingAddressPageState createState() => EditShippingAddressPageState();
}

class EditShippingAddressPageState extends BaseState<EditShippingAddressPage> {
  final HttpService httpService = HttpService();
  var codeController = TextEditingController();
  var address1Controller = TextEditingController();
  var address2Controller = TextEditingController();

  String postcode = "";
  String address1 = "";
  String address2 = "";

  bool valid = true;
  bool isEdit = false;
  FocusNode? detailAddrFocusNode;

  @override
  void initState() {
    super.initState();
    detailAddrFocusNode = FocusNode();

    if (gUserInfo!.deliverAddress!.isNotEmpty || gUserInfo!.deliverAddressDetail!.isNotEmpty || gUserInfo!.deliverPostcode!.isNotEmpty) {
      postcode = gUserInfo!.deliverPostcode!;
      address1 = gUserInfo!.deliverAddress!;
      address2 = gUserInfo!.deliverAddressDetail!;
    } else {
      postcode = gUserInfo!.postcode!;
      address1 = gUserInfo!.address!;
      address2 = gUserInfo!.addressDetail!;
    }

    codeController.text = postcode;
    address1Controller.text = address1;
    address2Controller.text = address2;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void onSave() {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo = httpService.changeDeliverAddress(postcode, address1, address2, isEdit ? 'y' : 'n');
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gUserInfo!.deliverPostcode = postcode;
        gUserInfo!.deliverAddress = address1;
        gUserInfo!.deliverAddressDetail = address2;
        if (isEdit) {
          gUserInfo!.postcode = postcode;
          gUserInfo!.address = address1;
          gUserInfo!.addressDetail = address2;
        }
        if (widget.onChanged != null) {
          widget.onChanged!(address1, address2, postcode);
        }
        showToast(LanguageService.trans('update_user_success'));
        eventBus.fire(UpdateUserEvent());
        onBackPressed();
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

  void checkValid() {
    if (postcode.isEmpty || address1.isEmpty || address2.isEmpty) {
      setState(() {
        valid = false;
      });
    } else {
      setState(() {
        valid = true;
      });
    }
  }

  // Network functions
  //////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("edit_shipping_address"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  UnderlineInput1(
                                    height: MediaQuery.of(context).size.height,
                                    controller: codeController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () => node.nextFocus(),
                                    placeholder: LanguageService.trans("post_num"),
                                    onChanged: (text) => {address1 = text, checkValid()},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // MainTextButton(
                          //   text: "업데이트",
                          //   backgroundColor: const Color(0xFFF4F9FF),
                          //   style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                          //   width: 76,
                          //   height: 32,
                          //   onPressed: () {
                          //     //
                          //   },
                          // ),
                          MainTextButton(
                            text: LanguageService.trans("search"),
                            backgroundColor: const Color(0xFFF4F9FF),
                            style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                            width: 76,
                            height: 36,
                            disable: true,
                            disableBackground: const Color(0xFFF4F9FF),
                            onPressed: () async {
                              Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => AddressSearchPage()));
                              detailAddrFocusNode!.requestFocus();
                              postcode = received["postcode"];
                              address1 = received["addr"];
                              // postcode = "12345";
                              // address1 = "address12345";
                              checkValid();
                              codeController.text = postcode;
                              address1Controller.text = address1;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: UnderlineInput1(
                        controller: address1Controller,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () => node.nextFocus(),
                        placeholder: LanguageService.trans("address1"),
                        onChanged: (text) => {address1 = text, checkValid()},
                      ),
                    ),
                    SizedBox(
                        height: 50,
                        child: Center(
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                            maxLength: -1,
                            controller: address2Controller,
                            onEditingComplete: () => node.nextFocus(),
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.done,
                            focusNode: detailAddrFocusNode,
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColor_Selector_Border),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColor_BlackText),
                              ),
                              hintText: LanguageService.trans("address2"),
                              hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) => {address2 = text, checkValid()},
                          ),
                        )),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        isEdit = !isEdit;
                        setState(() {});
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 24,
                        child: Row(
                          children: [
                            Image.asset(
                              isEdit ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            H14(
                              text: LanguageService.trans("edit_basic_information"),
                              weight: FW.medium,
                              height: 1.3,
                              color: isEdit ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MainTextButton(
                      text: LanguageService.trans("to_save"),
                      backgroundColor: AppColor_Primary,
                      style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                      disable: !valid,
                      disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
                      onPressed: () {
                        onSave();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )),
            ),
          ],
        ));
  }
}
