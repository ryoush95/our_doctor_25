import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h18.dart';

class AddressSearchPage extends StatefulWidget {
  @override
  AddressSearchPageState createState() => AddressSearchPageState();
}

class AddressSearchPageState extends BaseState<AddressSearchPage> {
  late InAppWebViewController control;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: "woorihospital_app",
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  String strInitUrl = "";
  @override
  void initState() {
    super.initState();

    strInitUrl = API_BASE_URL + "api/common/search_addr?query=";
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  onBackPressed();
                                },
                                child: Image.asset(
                                  'assets/path_12225.png',
                                  width: 10,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: H18(
                                      text: LanguageService.trans("address_search"),
                                      weight: FW.medium,
                                      height: 1.5,
                                      color: AppColor_BlackText,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                            ],
                          )),
                      Expanded(
                        child: InAppWebView(
                          initialOptions: options,
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
                          initialUrlRequest: URLRequest(url: Uri.parse(strInitUrl)),
                          onWebViewCreated: (controller) => control = controller
                            ..addJavaScriptHandler(
                              handlerName: 'bridge_setaddr',
                              callback: (data) {
                                String recevieData = data.elementAt(0).toString();
                                Map valueMap = json.decode(recevieData);
                                Map obj = Map();
                                obj["postcode"] = valueMap["postcode"];
                                obj["addr"] = valueMap["addr"];
                                obj["jibun_addr"] = valueMap["jibun_addr"];
                                Navigator.pop(context, obj);
                              },
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
