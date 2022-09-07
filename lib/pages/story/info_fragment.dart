import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/story_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h10.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/woo_story_webview.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';

class InfoFragment extends StatefulWidget {
  @override
  InfoFragmentState createState() => InfoFragmentState();
}

class InfoFragmentState extends BaseState<InfoFragment> {
  ScrollController scrollController = ScrollController();
  final HttpService httpService = HttpService();
  List<StoryInfo>? arrStoryList = [];
  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  bool isLast = false;
  int page = 0;

  int curCategory = 0;
  int curOrder = 0;
  String? _selection;
  List<String> topList = <String>[
    "Sleep",
    "covid-19",
    "seasonal food",
    "coffee",
    "wow point system",
    "vascular disease",
  ];

  List<String> order = <String>[LanguageService.trans("popular"), LanguageService.trans("recent")];

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()..addListener(loadMore);
    getStoryList();
    _selection = _selection = LanguageService.trans("recent");
    setState(() {});
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    page = 0;
    getStoryList();
  }

  void loadMore() {
    if (!isLoading) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        page = page + 1;
        getStoryList();
      }
    }
  }

  void goChatting() {}

  void onChooseCategory(int index) {
    setState(() {
      curCategory = index;
    });
    page = 0;
    getStoryList();
  }

  void onChangeOrder(String order) {
    setState(() {
      curOrder = curOrder == 0 ? 1 : 0;
    });
  }

  Widget _getTiles(int index) {
    StoryInfo info = arrStoryList!.elementAt(index);
    String dateTime = DateFormat("yyyy.MM.dd hh:mm").format(dateFormat.parse(info.createdAt!));
    String type = sprintf("[%s]", [info.categoryName!]);
    String title = type + " " + info.title!;
    return InkWell(
      onTap: () {
        goDetailPage(info.id!, info.url!, index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                Row(
                  children: [
                    H12(
                      text: dateTime,
                      weight: FW.medium,
                      color: AppColor_GrayText,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Image.asset(
                      "assets/ic_view.png",
                      width: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    H12(
                      text: info.viewCnt!,
                      weight: FW.medium,
                      color: AppColor_GrayText,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 1,
                  color: AppColor_Divider,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Network functions
  //////////////////////////////////
  //홈 스토리 얻기
  Future<void> getStoryList() async {
    setState(() {
      isLoading = true;
    });

    int order = _selection == LanguageService.trans("recent") ? 0 : 1;
    String strCategory = "";
    if (curCategory == 1) {
      strCategory = "tip";
    } else if (curCategory == 2) {
      strCategory = "news";
    } else {
      strCategory = "";
    }

    Future<StoryResModel> info = httpService.storyList(page, order, strCategory, "");
    info.then((StoryResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (page == 0) {
          arrStoryList!.clear();
        }
        arrStoryList!.addAll(value.data!.list!);
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

  //스토리 조회
  Future<void> goDetailPage(String uid, String url, int index) async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.storyDetail(uid);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        int count = int.parse(arrStoryList!.elementAt(index).viewCnt!) + 1;
        arrStoryList!.elementAt(index).viewCnt = count.toString();
        setState(() {});
        Navigator.push(context, SlideRightTransRoute(builder: (context) => WooStoryWebView(url: url)));
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

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //     height: 150,
                    //     width: double.infinity,
                    //     margin: const EdgeInsets.symmetric(horizontal: 20),
                    //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppColor_Light_Gray),
                    //     child: Column(
                    //       children: [
                    //         const SizedBox(height: 25),
                    //         H14(
                    //           text: LanguageService.trans("search_ranking_top"),
                    //         ),
                    //         const SizedBox(height: 10),
                    //         Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: <Widget>[
                    //             Wrap(
                    //               children: filterWidgets.toList(),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     )),
                    // const SizedBox(height: 20),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            onChooseCategory(0);
                          },
                          child: Container(
                              height: 25,
                              width: 65,
                              margin: const EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: curCategory == 0 ? Colors.black : AppColor_Black_Disable),
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
                            onChooseCategory(1);
                          },
                          child: Container(
                              height: 25,
                              width: 65,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: curCategory == 1 ? AppColor_Primary : AppColor_Primary_Disable),
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
                            onChooseCategory(2);
                          },
                          child: Container(
                              height: 25,
                              width: 65,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: curCategory == 2 ? AppColor_Green : AppColor_Green_Disable),
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
                          width: 100,
                          height: 30,
                          padding: const EdgeInsets.only(right: 20),
                          child: Center(
                            child: DropdownButton<String>(
                              value: _selection,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              borderRadius: BorderRadius.circular(15),
                              onChanged: (status) {
                                // onChangeOrder(status!);
                                _selection = status;
                                setState(() {});
                                page = 0;
                                getStoryList();
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
                    Container(
                        height: 40,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppColor_Light_Gray),
                        child: Center(
                          child: H10(
                            text: LanguageService.trans("article_guide"),
                            color: AppColor_GrayText,
                            height: 1.5,
                          ),
                        )),
                    RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return _getTiles(index);
                          },
                          itemCount: arrStoryList!.length),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(child: AppFloatingButton(onPressed: goChatting), right: 12, bottom: 12)
          ],
        ));
  }

  Iterable<Widget> get filterWidgets sync* {
    for (String category in topList) {
      yield Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, border: Border.all(width: 1, color: AppColor_Primary)),
                      child: Center(
                        child: H14(
                          text: category,
                          weight: FW.medium,
                          color: AppColor_Primary,
                        ),
                      )),
                ],
              )));
    }
  }
}
