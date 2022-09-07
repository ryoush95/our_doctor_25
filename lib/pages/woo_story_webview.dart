import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

import 'base/base_state.dart';

class WooStoryWebView extends StatefulWidget {
  WooStoryWebView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  WooStoryWebViewState createState() => WooStoryWebViewState();
}

class WooStoryWebViewState extends BaseState<WooStoryWebView> {
  @override
  void initState() {
    super.initState();

    // if (mounted) {
    //   setState(() {
    //     title = getTitle();
    //   });
    // }
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return false;
    // setState(() {
    //   shouldPop = true;
    // });
  }

  // String getTitle() {
  //   String title = LanguageService.trans('woo_story') + widget.itemIndex.toString();
  //   return title;
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Container(
              child: Scaffold(
                  body: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            SimpleHeader(
                              title: "",
                              onBackPressed: onBackPressed,
                            ),
                            const Divider(color: Colors.black, height: 1),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: InAppWebView(
                                  onLoadStart: (controller, url) => {
                                    setState(() {
                                      showLoading();
                                    })
                                  },
                                  onLoadStop: (controller, url) => {
                                    setState(() {
                                      hideLoading();
                                    })
                                  },
                                  initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
