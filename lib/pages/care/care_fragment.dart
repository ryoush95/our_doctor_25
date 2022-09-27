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
import 'package:ourdoctor/pages/care/product_list.dart';
import 'package:ourdoctor/pages/care/product_show.dart';
import 'package:ourdoctor/pages/components/h13.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/noline_input.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class CareFragment extends StatefulWidget {
  @override
  CareFragmentState createState() => CareFragmentState();
}

class CareFragmentState extends BaseState<CareFragment>
    with TickerProviderStateMixin {
  int tabIndex = 0;
  int category = 0;
  String keyword = "";
  late TabController tabController;
  final searchController = TextEditingController();

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

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      changeTab(tabController.index);
    });

    tabController.index = faqFromSide ? 1 : 0;
    getBannerList();
    getHomeDataInfo();

    eventBus.on<HomeCareTabEvent>().listen((event) {
      if (mounted) {
        category = event.type;
        getBannerList();
        getHomeDataInfo();
      }
    });
  }

  void changeTab(int tab) {
    setState(() {
      tabIndex = tab;
      tabController.index = tabIndex;
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

    Future<HomeCareBannerResModel> info = httpService
        .homecareBannerList(category == 0 ? "GROWTH" : "DEVELOPMENT");
    info.then((HomeCareBannerResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrBannerList = value.data!.list;
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

    Future<HomeCareDataResModel> info =
        httpService.homecareDataInfo(category == 0 ? "GROWTH" : "DEVELOPMENT");
    info.then((HomeCareDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrLikeList = value.data!.pdtLikeList;
        arrNewList = value.data!.pdtNewList;
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
                  CareBanner(),
                  const SizedBox(height: 28),
                  CategoryShow(),
                  SearchBar(),
                  const SizedBox(height: 60),
                  category == 0
                      ? ProductShow(
                          category: category,
                          title: LanguageService.trans("popular_item"),
                          list: arrLikeList)
                      : ProductShow(
                          category: category,
                          title: LanguageService.trans("popular_class"),
                          list: arrLikeList),
                  category == 0
                      ? ProductShow(
                          category: category,
                          title: LanguageService.trans("new_products_miss"),
                          list: arrNewList)
                      : ProductShow(
                          category: category,
                          title: LanguageService.trans("new_class"),
                          list: arrNewList),
                ]))));
  }

  Widget CareBanner() {
    return Container(
        height: 260,
        child: Stack(children: [
          Container(
              height: 110,
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: category == 0 ? AppColor_Primary : AppColor_Yellow),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        category = 1 - category;
                        getBannerList();
                        getHomeDataInfo();
                      });
                    },
                    child: H18(
                      text: LanguageService.trans("growth_store"),
                      color: category == 0 ? Colors.white : AppColor_ffe166,
                      weight: FW.semi_bold,
                    ),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      setState(() {
                        category = 1 - category;
                        getBannerList();
                        getHomeDataInfo();
                      });
                    },
                    child: H18(
                      text: LanguageService.trans("development_class"),
                      color:
                          category == 1 ? Colors.white : AppColor_Banner_Hint,
                      weight: FW.semi_bold,
                    ),
                  ),
                ],
              )),
          Positioned(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 180,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // itemCount: arrBannerList == null ? 0 : arrBannerList!.length,
                    itemCount: arrBannerList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      HomeCareBannerDto info = arrBannerList!.elementAt(index);
                      return InkWell(
                        child: Container(
                            width: MediaQuery.of(context).size.width - 64,
                            height: 180,
                            // padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              color: category == 0
                                  ? GROWTH_COLOR![index % 4]
                                  : DEVELOPMENT_COLOR![index % 4],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 74,
                                    height: 170,
                                    decoration: const BoxDecoration(
                                        color: AppColor_Selector_Border),
                                    child: ExtendedImage.network(
                                      info.image!,
                                      width: 350,
                                      height: 160,
                                      fit: BoxFit.fill,
                                      cache: true,
                                    ),
                                  ),
                                  right: 5,
                                  bottom: 5,
                                ),
                                Positioned(
                                  child: H16(
                                    text: "1 / " +
                                        arrBannerList!.length.toString(),
                                    color: Colors.white,
                                    weight: FW.semi_bold,
                                    align: TextAlign.start,
                                    height: 1.6,
                                  ),
                                  right: 10,
                                  bottom: 10,
                                )
                                // Container(
                                //   width: MediaQuery.of(context).size.width - 64 - 180,
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       H18(
                                //         text: info.title!,
                                //         color: Colors.white,
                                //         weight: FW.bold,
                                //         align: TextAlign.start,
                                //       ),
                                //       Container(
                                //         height: 8,
                                //       ),
                                //       H14(
                                //         text: info.content!,
                                //         color: Colors.white,
                                //         weight: FW.medium,
                                //         maxLine: 8,
                                //         align: TextAlign.start,
                                //         height: 1.2,
                                //       ),
                                //       // H12(
                                //       //   text: "",
                                //       //   color: Colors.white,
                                //       //   weight: FW.regular,
                                //       //   align: TextAlign.start,
                                //       //   height: 1.6,
                                //       // ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            )),
                        onTap: () {
                          //Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: info.uid)));
                        },
                      );
                    }),
              ),
              top: 70),
        ]));
  }

  Widget CategoryShow() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                String recv = await Navigator.push(
                    context,
                    SlideRightTransRoute(
                        builder: (context) => ProductList(
                            category:
                                category == 0 ? "GROWTH" : "DEVELOPMENT")));
                if (recv == "200") {
                  getHomeDataInfo();
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 10) / 4,
                height: 70,
                child: Column(
                  children: [
                    category == 0
                        ? Image.asset('assets/cake_black_24dp.png',
                            width: 40, height: 25)
                        : Image.asset('assets/cake_black_24dp1.png',
                            width: 40, height: 25),
                    const SizedBox(height: 10),
                    H13(text: "전체", weight: FW.medium),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String recv = await Navigator.push(
                    context,
                    SlideRightTransRoute(
                        builder: (context) => HomeCareListPage(
                            category_1:
                                category == 0 ? "GROWTH" : "DEVELOPMENT",
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
                    category == 0
                        ? Image.asset(
                            'assets/face_retouching_natural_black_24dp.png',
                            width: 40,
                            height: 25)
                        : Image.asset(
                            'assets/face_retouching_natural_black_24dp1.png',
                            width: 40,
                            height: 25),
                    const SizedBox(height: 10),
                    H13(text: "신체", weight: FW.medium),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String recv = await Navigator.push(
                    context,
                    SlideRightTransRoute(
                        builder: (context) => HomeCareListPage(
                            category_1:
                                category == 0 ? "GROWTH" : "DEVELOPMENT",
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
                    category == 0
                        ? Image.asset('assets/psychology_black_24dp.png',
                            width: 40, height: 25)
                        : Image.asset('assets/psychology_black_24dp1.png',
                            width: 40, height: 25),
                    const SizedBox(height: 10),
                    H13(text: "두뇌", weight: FW.medium),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String recv = await Navigator.push(
                    context,
                    SlideRightTransRoute(
                        builder: (context) => HomeCareListPage(
                            category_1:
                                category == 0 ? "GROWTH" : "DEVELOPMENT",
                            category_2: "RECOMMEND")));
                if (recv == "200") {
                  getHomeDataInfo();
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 10) / 4,
                height: 70,
                child: Column(
                  children: [
                    category == 0
                        ? Image.asset(
                            'assets/volunteer_activism_black_24dp.png',
                            width: 40,
                            height: 25)
                        : Image.asset(
                            'assets/volunteer_activism_black_24dp1.png',
                            width: 40,
                            height: 25),
                    const SizedBox(height: 10),
                    H13(text: "맞춤추천", weight: FW.medium),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget SearchBar() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
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
              width: screenSize.width - 130,
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
                                  category:
                                      category == 0 ? "GROWTH" : "DEVELOPMENT",
                                  keyword: keyword))),
                    }
                },
                placeholder: LanguageService.trans('search_hint'),
                onChanged: (text) => {keyword = text},
              ),
            )
          ],
        ));
  }

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
        changeTab(step);
      },
    );
  }
}
