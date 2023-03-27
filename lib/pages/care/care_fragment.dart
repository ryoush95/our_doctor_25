import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/homecare_banner_res_model.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/homecare_list.dart';
import 'package:ourdoctor/pages/care/item_product2.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/care/product_list.dart';
import 'package:ourdoctor/pages/care/product_show.dart';
import 'package:ourdoctor/pages/care/product_show1.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h13.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/noline_input.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';

import 'item_product1.dart';

class CareFragment extends StatefulWidget {
  @override
  CareFragmentState createState() => CareFragmentState();
}

class CareFragmentState extends BaseState<CareFragment>
    with TickerProviderStateMixin {
  int tabIndex = 0;
  int category = 0;

  List<String> cateList = ["성장스토어", "발달클래스", "우아테스트"];
  ScrollController controller = ScrollController();
  bool isLast = true;
  int nPage = 0;
  String keyword = "";
  late TabController tabController;
  final searchController = TextEditingController();
  PageController pageController = PageController();
  double scaleFactor = 0.8;
  double height = 100.0;
  List<String> bannerList = [];
  int position = 0;




  static const platform = MethodChannel('doctor.flutter.dev');
  final HttpService httpService = HttpService();
  List<HomeCareBannerDto>? arrBannerList = [];
  List<PdtLikeDto>? arrLikeList = [];
  List<PdtLikeDto>? arrNewList = [];
  List<Color>? GROWTH_COLOR = [
    const Color(0xFFB5C4FF),
    const Color(0xFF9DD6FF),
    const Color(0xFFB6DAE0),
    const Color(0xFFC6B9F0)
  ];
  List<Color>? DEVELOPMENT_COLOR = [
    const Color(0xFFFFE72F),
    const Color(0xFFFFA429),
    const Color(0xFFADE641),
    const Color(0xFF44C924)
  ];

  List<Color>? MBTI_COLOR = [
    const Color(0xFFA8E1AC),
    const Color(0xFF9DD6FF),
    const Color(0xFFB6DAE0),
    const Color(0xFFC6B9F0)
  ];

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      changeTab(tabController.index);
    });
    tabIndex = Provider.of<ConvertScoreProvider>(context, listen: false).careTab;

    tabController.index = faqFromSide ? 1 : 0;
    getBannerList();
    getHomeDataInfo();

    eventBus.on<HomeCareTabEvent>().listen((event) {
      if (mounted) {
        category = event.type;
        // getBannerList();
        // getHomeDataInfo();
      }
    });
  }

  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getBannerList();
        getHomeDataInfo();
      }
    }
  }

  void changeTab(int tab) {
    Provider.of<ConvertScoreProvider>(context, listen: false).changeCareTab(tab);
    setState(() {
      tabIndex = tab;
      tabController.index = tabIndex;
    });
  }


  void moveScroll() {
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.jumpTo(50);
    });
  }

  Future<void> goChatting() async {
    try {
      final int result = await platform.invokeMethod(
          'talk', {"uid": gUserInfo!.id, "name": gUserInfo!.name});
    } on PlatformException catch (e) {
      showToast("'${e.message}'.");
    }
  }

  // Network functions
  //////////////////////////////////
  //홈케어 배너리스트 얻기
  Future<void> getBannerList() async {
    setState(() {
      isLoading = true;
    });
    String category = "";
    if (tabIndex == 0) {
      category = "GROWTH";
    } else if (tabIndex == 1) {
      category = "DEVELOPMENT";
    } else {
      category = "GROWTH";
    }

    Future<HomeCareBannerResModel> info =
        httpService.homecareBannerList(category);
    info.then((HomeCareBannerResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && arrBannerList!.isNotEmpty) {
          arrBannerList!.clear();
          bannerList.clear();
        }
        arrBannerList = value.data!.list;
        if (nPage == 0) {
          for(int i = 0; i < arrBannerList!.length; i++){
            bannerList.add(
              arrBannerList![i].image!,
            );
          }
        }
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //홈케어 홈 데이터 얻기
  Future<void> getHomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    String category = "";
    if (tabIndex == 0) {
      category = "GROWTH";
    } else if (tabIndex == 1) {
      category = "DEVELOPMENT";
    } else {
      category = "TEST";
    }

    Future<HomeCareDataResModel> info = httpService.homecareDataInfo(category);
    info.then((HomeCareDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (tabIndex == 2){
          arrLikeList!.clear();
          arrNewList!.clear();
          for (var i in value.data!.pdtLikeList!) {
            if (i.category2 == "SOON") {
              arrNewList!.add(i);
            } else {
              arrLikeList!.add(i);
            }
          }
        } else {
          arrLikeList = value.data!.pdtLikeList;
          arrNewList = value.data!.pdtNewList;
        }
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        if(mounted) {
          isLoading = false;
        }
      });
      showToast(onError);
    });
  }

  // Widget getBannerTitle(int index) {
  //   return InkWell(
  //     onTap: () {
  //       changeTab(index);
  //       setState(() {
  //         nPage = 0;
  //         position = 0;
  //         getBannerList();
  //         getHomeDataInfo();
  //         pageController.jumpToPage(0);
  //       });
  //     },
  //     child: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
  //         margin: const EdgeInsets.only(right: 8),
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(18),
  //             color: tabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
  //         child: SizedBox(
  //           child: Stack(
  //             children: [
  //               Center(
  //                 child: H14(
  //                   text: cateList[index],
  //                   weight: FW.bold,
  //                   align: TextAlign.center,
  //                   maxLine: 1,
  //                   color: tabIndex == index
  //                       ? AppColor_White
  //                       : AppColor_GridText,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        isAvoidResize: false,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  bannerList.isNotEmpty ? CareBanner() : const Center(child: CircularProgressIndicator()),
                  bannerList.isNotEmpty ? Center(child: _dotIndicator()) : Container(),
                  const SizedBox(height: 10),
                  CategoryShow(),
                  SearchBar(),
                  PersonalityType(),
                  const SizedBox(height: 60),
                  ProductListShow(),
                ]))));
  }

  Widget PersonalityType() => Visibility(
        visible: tabIndex == 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              tabIndex == 2
              ? ProductShow1(
                category: category,
                title: "인기 검사",
                list: arrLikeList,
              ) : const SizedBox(),
              tabIndex == 2
              ? Visibility(
                visible: arrNewList!.isNotEmpty,
                child: ProductShow1(
                  category: category,
                  title: "오픈 예정",
                  list: arrNewList,
                ),
              ) : const SizedBox(),
            ],
          ),
      );

  Widget ProductListShow() => Visibility(
        visible: tabIndex == 0 || tabIndex == 1,
        child: Column(
          children: [
            tabIndex == 0
                ? ProductShow(
                    category: category,
                    title: LanguageService.trans("popular_item"),
                    list: arrLikeList)
                : ProductShow(
                    category: category,
                    title: LanguageService.trans("popular_class"),
                    list: arrLikeList),
            tabIndex == 0
                ? ProductShow(
                    category: category,
                    title: LanguageService.trans("new_products_miss"),
                    list: arrNewList)
                : ProductShow(
                    category: category,
                    title: LanguageService.trans("new_class"),
                    list: arrNewList),
          ],
        ),
      );

  Widget _getTiles1(int index) {
    double mWidth = (MediaQuery.of(context).size.width) / cateList.length;
    return InkWell(
      onTap: () {
        changeTab(index);
        setState(() {
          nPage = 0;
          position = 0;
          getBannerList();
          getHomeDataInfo();
          pageController.jumpToPage(0);
        });
      },
      child: SizedBox(
        width: mWidth,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
              child: H14(
                text: cateList[index],
                weight: FW.medium,
                align: TextAlign.center,
                maxLine: 2,
                color: tabIndex == index ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
              ),
            ),
            Positioned(
              child: SizedBox(
                  width: mWidth,
                  height: 2,
                  child: Container(
                    width: 80,
                    height: MediaQuery.of(context).size.width,
                    color: tabIndex == index ? AppColor_Primary : AppColor_BlackText.withOpacity(0.1),
                  )),
              bottom: 0,
            )
          ],
        ),
      ),
    );
  }

  Widget CareBanner() {
    return SizedBox(
      width: double.infinity,
        height: 270,
        child: Stack(children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _getTiles1(index);
              },
              itemCount: cateList.length,
            ),
          ),
          Positioned(
              child:thumbnail(),
              top: 70),
        ]));
  }

  thumbnail() {
    var screen = MediaQuery.of(context).size;
    return Container(
        width: screen.width - 10,
        height: screen.width / 2 - 10,
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColor_Light_Gray,
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
              ),
            ]),
        child: bannerList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : PageView.builder(
              controller: pageController,
              itemCount: bannerList.length,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: bannerList[index],
                    width: screen.width,
                    height: screen.width / 2,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                  ),
                );
              },
              onPageChanged: (i) {
                setState(() {
                  position = i;
                });
              },
            )
    );
  }


  _dotIndicator() {
    // List _items = [mData.mainImage!, mData.mainImage!];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DotsIndicator(
        dotsCount: bannerList.length,
        position: position.toDouble(),
        decorator: DotsDecorator(
          color: const Color(0xFF000000).withOpacity(0.12), // Inactive color
          activeColor: AppColor_Primary,
        ),
      ),
    );
  }

  Widget CategoryShow() => Visibility(
        visible: tabIndex == 0 || tabIndex == 1,
        child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    String recv = await Navigator.push(
                        context,
                        SlideRightTransRoute(
                            builder: (context) => ProductList(
                                category:
                                    tabIndex == 0 ? "GROWTH" : "DEVELOPMENT")));
                    if (recv == "200") {
                      getHomeDataInfo();
                    }
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 10) / 4,
                    height: 70,
                    child: Column(
                      children: [
                        tabIndex == 0
                            ? Image.asset('assets/cake_black_24dp.png',
                                width: 40, height: 40)
                            : Image.asset('assets/cake_black_24dp1.png',
                                width: 40, height: 40),
                        const SizedBox(height: 10),
                        H13(text: "전체", weight: FW.medium),
                      ],
                    ),
                  ),
                ),
                //신체
                InkWell(
                  onTap: () async {
                    String recv = await Navigator.push(
                        context,
                        SlideRightTransRoute(
                            builder: (context) => HomeCareListPage(
                                category_1:
                                    tabIndex == 0 ? "GROWTH" : "DEVELOPMENT",
                                category_2: "BODY")));
                    if (recv == "200") {
                      getHomeDataInfo();
                    }
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 10) / 4,
                    height: 70,
                    child: Column(
                      children: [
                        tabIndex == 0
                            ? Image.asset(
                                'assets/face_retouching_natural_black_24dp.png',
                                width: 40,
                                height: 40)
                            : Image.asset(
                                'assets/face_retouching_natural_black_24dp1.png',
                                width: 40,
                                height: 40),
                        const SizedBox(height: 10),
                        H13(text: "신체", weight: FW.medium),
                      ],
                    ),
                  ),
                ),
                //두뇌
                InkWell(
                  onTap: () async {
                    String recv = await Navigator.push(
                        context,
                        SlideRightTransRoute(
                            builder: (context) => HomeCareListPage(
                                category_1:
                                    tabIndex == 0 ? "GROWTH" : "DEVELOPMENT",
                                category_2: "BRAIN")));
                    if (recv == "200") {
                      getHomeDataInfo();
                    }
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 10) / 4,
                    height: 70,
                    child: Column(
                      children: [
                        tabIndex == 0
                            ? Image.asset('assets/psychology_black_24dp.png',
                                width: 40, height: 40)
                            : Image.asset('assets/psychology_black_24dp1.png',
                                width: 40, height: 40),
                        const SizedBox(height: 10),
                        H13(text: "두뇌", weight: FW.medium),
                      ],
                    ),
                  ),
                ),
                // 맞춤추천
                // InkWell(
                //   onTap: () async {
                //     String recv = await Navigator.push(
                //         context,
                //         SlideRightTransRoute(
                //             builder: (context) => HomeCareListPage(
                //                 category_1:
                //                     category == 0 ? "GROWTH" : "DEVELOPMENT",
                //                 category_2: "RECOMMEND")));
                //     if (recv == "200") {
                //       getHomeDataInfo();
                //     }
                //   },
                //   child: Container(
                //     width: (MediaQuery.of(context).size.width - 10) / 4,
                //     height: 70,
                //     child: Column(
                //       children: [
                //         tabIndex == 0
                //             ? Image.asset(
                //                 'assets/volunteer_activism_black_24dp.png',
                //                 width: 40,
                //                 height: 25)
                //             : Image.asset(
                //                 'assets/volunteer_activism_black_24dp1.png',
                //                 width: 40,
                //                 height: 25),
                //         const SizedBox(height: 10),
                //         H13(text: "맞춤추천", weight: FW.medium),
                //       ],
                //     ),
                //   ),
                // )
              ],
            )),
      );

  Widget SearchBar() => Visibility(
        visible: tabIndex == 0 || tabIndex == 1,
        child: Container(
            width: double.infinity,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: AppColor_Light_Gray,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/search_black_24dp.png', width: 20),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  // margin: const EdgeInsets.only(bottom: 3),
                  child: NolineInput(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    borderColor: AppColor_Light_Gray,
                    onEditingComplete: () => {
                      if (keyword == "")
                        {
                          showToast("검색어를 입력해 주세요."),
                        }
                      else
                        {
                          FocusScope.of(context).requestFocus(FocusNode()),
                          Navigator.push(
                              context,
                              SlideRightTransRoute(
                                  builder: (context) => ProductList(
                                      category: tabIndex == 0
                                          ? "GROWTH"
                                          : "DEVELOPMENT",
                                      keyword: keyword))),
                        }
                    },
                    placeholder: LanguageService.trans('search_hint'),
                    onChanged: (text) => {keyword = text},
                  ),
                )
              ],
            )),
      );

  Widget _buildTabHeaderItem(String tabText, int step) {
    return InkWell(
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 70,
            child: Column(
              children: [
                Image.asset('assets/add_reaction_black_24dp.png',
                    width: 22, height: 25),
                const SizedBox(height: 8),
                H14(
                    text: "Personalized recommendation",
                    maxLine: 2,
                    height: 1.3,
                    weight: FW.semi_bold)
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        //changeTab(step);
      },
    );
  }
}
