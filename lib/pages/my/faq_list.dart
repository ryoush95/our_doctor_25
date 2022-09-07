import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/faq_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/woo_story_webview.dart';
import 'package:substring_highlight/substring_highlight.dart';

class FaqListPage extends StatefulWidget {
  @override
  FaqListPageState createState() => FaqListPageState();
}

class FaqListPageState extends BaseState<FaqListPage> {
  ScrollController scrollController = ScrollController();
  final HttpService httpService = HttpService();
  var keywordController = TextEditingController();
  int page = 0;
  String keyword = "";
  String? _selection = LanguageService.trans("recent");
  String curCategory = "all";
  List<FaqListDto>? arrFaqList = [];
  bool isLast = false;
  int curOrder = 0;
  int selIndex = -1;

  @override
  void initState() {
    super.initState();
    _selection = LanguageService.trans("recent");
    scrollController = ScrollController()..addListener(loadMore);
    getFaqList();
    setState(() {});
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

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    page = 0;
    getFaqList();
  }

  void loadMore() {
    if (!isLoading) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        page = page + 1;
        getFaqList();
      }
    }
  }

  Future<void> getFaqList() async {
    curOrder = _selection == LanguageService.trans("recent") ? 0 : 1;
    setState(() {
      isLoading = true;
    });

    Future<FaqResModel> info = httpService.faqList(page, curOrder, curCategory, keyword);
    info.then((FaqResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (page == 0) {
          arrFaqList!.clear();
        }
        arrFaqList!.addAll(value.data!.list!);
        isLast = value.data!.isLast!;
        setState(() {});
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

  Widget _getTiles(int index) {
    FaqListDto info = arrFaqList!.elementAt(index);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    String type = "";
    String title = "";
    String dateTime = "";
    String htmlData = "";

    dateTime = DateFormat("yyyy.MM.dd hh:mm").format(dateFormat.parse(info.createdAt!));
    String temp = info.category!;
    if (temp == "signup") {
      type = "[회원가입]";
    } else if (type == "login") {
      type = "[로그인]";
    } else if (temp == "home") {
      type = "[홈케어]";
    } else if (temp == "error") {
      type = "[오류]";
    } else if (temp == "news") {
      type = "[뉴스]";
    } else if (temp == "health") {
      type = "[건강팁]";
    }

    title = type + " " + info.question!;
    htmlData = info.answer!;

    return InkWell(
      onTap: () {
        if (selIndex == index) {
          selIndex = -1;
        } else {
          selIndex = index;
        }
        setState(() {});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubstringHighlight(
                  text: title,
                  term: type,
                  textStyle: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium, height: 1.5),
                  textStyleHighlight: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.medium),
                ),
                const SizedBox(
                  height: 15,
                ),
                H12(
                  text: dateTime,
                  weight: FW.medium,
                  color: AppColor_GrayText,
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: selIndex == index,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColor_Light_Gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        H14(
                          text: info.answer!,
                          weight: FW.medium,
                          maxLine: 100,
                          height: 1.5,
                          align: TextAlign.start,
                        ),
                        Html(
                          data: htmlData,
                        ),
                        Linkify(
                          onOpen: (link) {
                            Navigator.push(context, SlideRightTransRoute(builder: (context) => WooStoryWebView(url: link.url)));
                          },
                          text: info.answer!,
                          options: const LinkifyOptions(looseUrl: true),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // ExtendedImage(
                        //   image: NetworkImage(widget.item.image),
                        //   width: double.infinity,
                        //   fit: BoxFit.fill,
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColor_Light_Gray,
          )
        ],
      ),
    );
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
              title: LanguageService.trans("faq"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor_Light_Gray),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.only(left: 20),
                            icon: const Icon(Icons.search_rounded, color: AppColor_Icon),
                            onPressed: () => {},
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: TextField(
                              style: AppTextStyle.PD(Colors.black, 14, weight: FW.regular),
                              maxLength: 100,
                              controller: keywordController,
                              onEditingComplete: () {
                                setState(() {
                                  page = 0;
                                  getFaqList();
                                });
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              maxLines: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: LanguageService.trans("faq_search_hint"),
                                hintStyle: AppTextStyle.PD(AppColor_GrayText, 14, weight: FW.medium),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                keyword = text;
                              },
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            curCategory = "all";
                            page = 0;
                            setState(() {});
                            getFaqList();
                          },
                          child: Container(
                              height: 28,
                              width: 55,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: curCategory == "all" ? Colors.black : AppColor_Black_Disable),
                              child: Center(
                                child: H14(
                                  text: LanguageService.trans("all"),
                                  weight: FW.medium,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            curCategory = "health";
                            page = 0;
                            setState(() {});
                            getFaqList();
                          },
                          child: Container(
                              height: 28,
                              width: 55,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: curCategory == "health" ? AppColor_Primary : AppColor_Primary_Disable),
                              child: Center(
                                child: H14(
                                  text: LanguageService.trans("health_tip"),
                                  weight: FW.medium,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            curCategory = "news";
                            page = 0;
                            setState(() {});
                            getFaqList();
                          },
                          child: Container(
                              height: 28,
                              width: 55,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: curCategory == "news" ? AppColor_Green : AppColor_Green_Disable),
                              child: Center(
                                child: H14(
                                  text: LanguageService.trans("news"),
                                  weight: FW.medium,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          // width: 100,
                          height: 30,
                          child: Center(
                            child: DropdownButton<String>(
                              value: _selection,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              underline: Container(height: 0),
                              borderRadius: BorderRadius.circular(15),
                              onChanged: (status) {
                                //onChangeOrder(status!);
                                _selection = status;
                                setState(() {});
                                page = 0;
                                getFaqList();
                              },
                              items: [
                                DropdownMenuItem(
                                  child: H14(text: LanguageService.trans("popular")),
                                  value: LanguageService.trans("popular"),
                                ),
                                DropdownMenuItem(
                                  child: H14(text: LanguageService.trans("recent")),
                                  value: LanguageService.trans("recent"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: refresh,
                        child: ListView.builder(
                            controller: scrollController,
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return _getTiles(index);
                            },
                            itemCount: arrFaqList!.length),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
