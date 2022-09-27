import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/models/product_review_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/buying_dialog.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/simple_header1.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/review_fragment.dart';
import 'package:ourdoctor/pages/my/shopping_basket.dart';
import 'package:sprintf/sprintf.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({
    required this.pid,
  });

  final String pid;

  @override
  ProductDetailtState createState() => ProductDetailtState();
}

class ProductDetailtState extends BaseState<ProductDetail> {
  final HttpService httpService = HttpService();
  int nTabIndex = 0;
  bool isLast = true;
  int totalReviewCount = 0;
  bool isLast_review = true;
  int currentPage = 0;
  ProductDetailDto mData = ProductDetailDto();
  List<ProductDto> arrProductList = [];
  List<ProductReviewDto> reviewList = [];

  late PageController _pageController;
  late ScrollController _listController;

  //리스트뷰 컨트롤러
  late ScrollController controller;
  String? _selection = "인기순";

  @override
  void initState() {
    getProductDetail();
    super.initState();
    mData.name = "";
    mData.mainImage = "";
    mData.detailImage = "";
    mData.description = "";
    mData.price = "0";
    mData.notice = "0";
    mData.discount = "0";
    mData.liked = "0";
    mData.notice = "";
    mData.tags = "";

    _listController = ScrollController();
    _listController.addListener(() {});
    _pageController = PageController(
      initialPage: currentPage,
      keepPage: false,
    );

    eventBus.on<AddReviewEvent>().listen((event) {
      if (mounted) {
        getReviewList();
      }
    });
  }

  // Network functions
  //////////////////////////////////
  void getProductDetail() {
    setState(() {
      isLoading = true;
    });
    Future<ProductDetailResModel> info =
        httpService.getProductDetail(widget.pid);
    info.then((ProductDetailResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        mData = value.data!;
        getReviewList();
        setState(() {});
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void getReviewList() {
    String order = _selection == "최신순" ? "new" : "like";
    setState(() {
      isLoading = true;
    });
    Future<ProductReviewListResModel> reviewInfo =
        httpService.getProductReview(widget.pid, 0, order);
    reviewInfo.then((ProductReviewListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        reviewList.clear();
        isLast_review = value.data!.isLast!;
        totalReviewCount = value.data!.totalCount!;
        reviewList.addAll(value.data!.list!);
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
      showToast(onError.toString());
    });
  }

  //상품 좋아요
  void productLike() {
    setState(() {
      isLoading = true;
    });

    final HttpService httpService = HttpService();

    Future<DefaultResModel> info = httpService.productLike(widget.pid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        setState(() {
          if (mData.liked! == "0") {
            mData.liked = "1";
          } else {
            mData.liked = "0";
          }
        });
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          // Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  void showReviewDialog() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return BuyingDialog(info: mData);
        });
  }

  @override
  void dispose() {
    _listController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed() async {
    // Navigator.of(context).pop();
    Navigator.pop(context, mData.liked);
    return true;
  }

  Future<bool> goShoppingBasketPage() async {
     Navigator.push(context,
        SlideRightTransRoute(builder: (context) => ShoppingBasketPage()));
    return true;
  }

  //////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      isLoading: isLoading,
      onBack: onBackPressed,
      child: SizedBox(
        child: Column(
          children: [
            SimpleHeader1(
              title: mData.name != null ? mData.name : "",
              onBackPressed: onBackPressed,
              basket: goShoppingBasketPage,
            ),
            Expanded(
              child: Container(
                  // height: MediaQuery.of(context).size.height - 164,
                  child: SingleChildScrollView(
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(color: AppColor_f4f5f7),
                    child: Stack(
                      children: [
                        Visibility(
                            visible: mData == null || mData.mainImage!.isEmpty,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 360,
                              decoration: BoxDecoration(
                                color: AppColor_f4f5f7,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                        Visibility(
                          visible: mData == null && mData.mainImage!.isEmpty,
                          child: ExtendedImage.network(
                            mData == null ? "" : mData.mainImage!,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                            cache: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  thumbnail(),
                  Container(
                      height: 59,
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: AppColor_f4f5f7,
                          spreadRadius: 10,
                          blurRadius: 7,
                          offset: Offset(0, 1),
                        )
                      ]),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                nTabIndex = 0;
                              });
                            },
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width) / 3,
                              child: Stack(
                                children: [
                                  Center(
                                    child: H16(
                                      text: LanguageService.trans(
                                          'Product_Descrition'),
                                      weight: FW.semi_bold,
                                      align: TextAlign.center,
                                      color: nTabIndex == 0
                                          ? AppColor_Primary
                                          : AppColor_BlackText.withOpacity(0.2),
                                      maxLine: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                nTabIndex = 1;
                              });
                            },
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width) / 3,
                              child: Stack(
                                children: [
                                  Center(
                                    child: H16(
                                      text: totalReviewCount > 100
                                          ? "후기 100+"
                                          : "후기 " +
                                              totalReviewCount.toString() +
                                              "+",
                                      weight: FW.semi_bold,
                                      align: TextAlign.left,
                                      color: nTabIndex == 1
                                          ? AppColor_Primary
                                          : AppColor_BlackText.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                nTabIndex = 2;
                              });
                            },
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width) / 3,
                              child: Stack(
                                children: [
                                  Center(
                                    child: H16(
                                      text: LanguageService.trans('notice1'),
                                      weight: FW.semi_bold,
                                      align: TextAlign.left,
                                      color: nTabIndex == 2
                                          ? AppColor_Primary
                                          : AppColor_BlackText.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  nTabIndex == 0 ? Detail1() : const SizedBox(),
                  nTabIndex == 1 ? Detail2() : const SizedBox(),
                  nTabIndex == 2 ? Detail3() : const SizedBox(),
                ],
              ))),
            ),
            InkWell(
              onTap: () {
                showReviewDialog();
              },
              child: Container(
                height: 58,
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                decoration: BoxDecoration(color: AppColor_Primary),
                child: H20(
                  text: LanguageService.trans("choose_an_opinion"),
                  color: Colors.white,
                  weight: FW.bold,
                  align: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Detail1() {
    return Column(children: [
      Container(
          // height: 250,
          // decoration: BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            H18(
                text: (mData.name == "") ? "" : mData.name!,
                maxLine: 2,
                align: TextAlign.start,
                height: 1.3),
            // const SizedBox(height: 10),
            // H16(text: (mData.description != null) ? mData.description! : "", maxLine: 10, align: TextAlign.start, weight: FW.regular, height: 1.4),
            const SizedBox(height: 30),
            mData.discount != null
                ? H14(
                    text: "우아 할인가",
                    maxLine: 2,
                    align: TextAlign.start,
                    weight: FW.regular,
                    color: AppColor_GrayText)
                : const SizedBox(),
            const SizedBox(height: 10),
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      H24B(
                        text: mData.price != null
                            ? ValidPrice(mData.discount != ""
                                ? (double.parse(mData.price!) *
                                        (100 - int.parse(mData.discount!)) /
                                        100)
                                    .toString()
                                : mData.price!)
                            : "0",
                        maxLine: 2,
                        align: TextAlign.start,
                      ),
                      const SizedBox(width: 5),
                      H16(
                        text: LanguageService.trans("won"),
                        maxLine: 2,
                        align: TextAlign.start,
                        weight: FW.regular,
                      ),
                      const SizedBox(width: 16),
                      Visibility(
                        visible: mData.discount != "0",
                        child: H24B(
                          text: mData.discount != ""
                              ? (sprintf("%s%s", [mData.discount, "%"]))
                              : "",
                          maxLine: 2,
                          align: TextAlign.start,
                          color: AppColor_Red,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        productLike();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            mData.liked == "1"
                                ? 'assets/ic_like_on.png'
                                : 'assets/ic_like_off.png',
                            width: 19,
                          ),
                          const SizedBox(width: 5),
                          H14(text: "찜", weight: FW.medium),
                        ],
                      ))
                ]),
            Visibility(
              visible: mData.discount != "0",
              child: const SizedBox(height: 10),
            ),
            Visibility(
              visible: mData.discount != "0",
              child: Text(
                (mData.price != null
                        ? ValidPrice(convertScore(mData.price!))
                        : "0") +
                    "원",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  // fontFamily: 'Pretendard',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  height: 1.0,
                  color: AppColor_BlackText.withOpacity(0.3),
                  decoration: TextDecoration.lineThrough,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
            ),
          ])),
      Container(
        height: 8,
        decoration: BoxDecoration(color: AppColor_f4f5f7),
      ),
      Container(
          padding: const EdgeInsets.all(30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            H16(text: "상품정보", weight: FW.bold, align: TextAlign.start),
            const SizedBox(height: 20),
            H14(
              text: (mData.description != null) ? mData.description! : "",
              weight: FW.regular,
              align: TextAlign.start,
              height: 1.2,
              maxLine: 100,
            ),
            const SizedBox(height: 40),
            Container(
              decoration: const BoxDecoration(color: AppColor_f4f5f7),
              child: mData == null || mData.detailImage! == ""
                  ? const Center(child: CircularProgressIndicator())
                  : ExtendedImage.network(
                      mData.detailImage!,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
            )
          ])),
    ]);
  }

  Widget Detail2() {
    return Column(children: [
      InkWell(
        onTap: () {
          Navigator.push(context,
              SlideRightTransRoute(builder: (context) => ReviewFragment()));
        },
        child: Visibility(
          visible: mData.buyCnt != "0",
          child: Container(
              height: 38,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor_Primary,
                borderRadius: BorderRadius.circular(19.0),
              ),
              margin: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
              child: Center(
                child: H14(
                  text: "리뷰 등록하고 1,000 우아포인트 받기",
                  maxLine: 1,
                  align: TextAlign.start,
                  height: 1.3,
                  color: Colors.white,
                  weight: FW.semi_bold,
                ),
              )),
        ),
      ),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          margin: const EdgeInsets.only(top: 30.0),
          child: Row(
            children: [
              H14(
                  text: "리뷰 ",
                  maxLine: 1,
                  align: TextAlign.start,
                  height: 1.3,
                  weight: FW.semi_bold),
              H14(
                  text: totalReviewCount.toString(),
                  maxLine: 1,
                  align: TextAlign.start,
                  height: 1.3,
                  weight: FW.semi_bold,
                  color: AppColor_Primary),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  if (_selection == "인기순") {
                    _selection = "최신순";
                  } else {
                    _selection = "인기순";
                  }
                  getReviewList();
                },
                child: Row(
                  children: [
                    Image.asset('assets/ic_order.png',
                        width: 18, height: 12, fit: BoxFit.contain),
                    const SizedBox(width: 6),
                    H14(
                        text: _selection!,
                        maxLine: 1,
                        align: TextAlign.start,
                        height: 1.3,
                        weight: FW.semi_bold),
                  ],
                ),
              ),
            ],
          )),
      Container(
        child: ListView.builder(
          itemCount: reviewList.length,
          shrinkWrap: true,
          controller: _listController,
          itemBuilder: ReviewItem,
        ),
      ),
    ]);
  }

  Widget Detail3() {
    return Column(children: [
      const SizedBox(height: 40),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H16(
                  text: "공지",
                  maxLine: 1,
                  align: TextAlign.start,
                  height: 1.3,
                  weight: FW.semi_bold),
            ],
          )),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
        child: Align(
          alignment: Alignment.centerLeft,
          child: H14(
            text: mData == null ? "" : mData.notice!,
            weight: FW.regular,
            height: 1.2,
            maxLine: 100,
            align: TextAlign.start,
          ),
        ),
      ),
    ]);
  }

  Widget ReviewItem(BuildContext context, int index) {
    var mark = int.parse(reviewList[index].rating!);
    final List<Widget> stars = <Widget>[];
    for (var i = 0; i < 5; i++) {
      if (i < mark)
        stars.add(Image.asset('assets/ic_star_on.png', width: 15));
      else
        stars.add(Image.asset('assets/ic_star_off.png', width: 15));
      stars.add(const SizedBox(width: 3));
    }
    final List<String> images = reviewList[index].photos!.split(",");
    final List<Widget> imagesWidget = <Widget>[];
    for (var i = 0; i < images.length; i++) {
      imagesWidget.add(Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: AppColor_Light_Gray,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ExtendedImage(
            image: NetworkImage(images[i]),
            fit: BoxFit.fill,
          )));
    }
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  H14(
                    text: reviewList[index].patientName!,
                    weight: FW.bold,
                  ),
                  H14(
                    text: "님",
                    weight: FW.medium,
                  ),
                  Expanded(child: Container()),
                  H12(
                      text: dateFormat
                          .format(DateTime.parse(reviewList[index].createdAt!))
                          .toString(),
                      weight: FW.semi_bold,
                      height: 1.2,
                      color: AppColor_GrayText),
                ],
              ),
              const SizedBox(height: 5),
              Row(children: stars),
              // const SizedBox(height: 15),
              // Row(children: [
              //   H16(text: "selection option", weight: FW.regular),
              //   const SizedBox(width: 5),
              //   H16(text: "option name", weight: FW.bold),
              // ]),
              const SizedBox(height: 20),
              SizedBox(
                  height: MediaQuery.of(context).size.width - 60,
                  width: MediaQuery.of(context).size.width - 60,
                  child: PageView(
                    controller: _pageController,
                    children: imagesWidget,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                  )),
              const SizedBox(height: 5),
              Container(
                  width: double.infinity,
                  height: 18,
                  color: Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _paginationItemBuilder(images.length))),
              const SizedBox(height: 15),
              H16(
                text: reviewList[index].text!,
                weight: FW.regular,
                maxLine: 4,
                align: TextAlign.start,
                height: 1.4,
                color: AppColor_BlackText,
              ),
              // Align(alignment: Alignment.bottomRight, child: H16(text: LanguageService.trans("view_more"), weight: FW.semi_bold)),
              const SizedBox(height: 30),
            ],
          )),
      Container(
        height: 8,
        decoration: BoxDecoration(color: AppColor_f4f5f7),
      ),
    ]);
  }

  List<Widget> _paginationItemBuilder(int size) {
    List<Widget> widgets = [];
    for (int i = 0; i < size; i++) {
      widgets.add(Container(
          height: 8,
          width: 8,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: currentPage == i ? AppColor_Primary : AppColor_Gray)));
    }
    return widgets;
  }

  thumbnail() => Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .38,
      child: mData.mainImage == "" || mData.mainImage == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              PageView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  List _items = [mData.mainImage!, mData.mainImage!];
                  return ExtendedImage.network(
                    mData.mainImage!,
                    fit: BoxFit.fill,
                    cache: true,
                  );
                },
                onPageChanged: (i) {
                  setState(() {
                    position = i;
                  });
                },
              ),
              _dotIndicator(),
            ])
      // : ExtendedImage.network(
      //   mData.mainImage!,
      //   fit: BoxFit.fill,
      //   cache: true,
      // ),
      );
  int position = 0;

  _dotIndicator() {
    List _items = [mData.mainImage!, mData.mainImage!];
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DotsIndicator(
          dotsCount: _items.length,
          position: position.toDouble(),
          decorator: DotsDecorator(
            color: const Color(0xFF000000).withOpacity(0.12), // Inactive color
            activeColor: const Color(0xFF332A2F),
          ),
        ),
      ),
    );
  }
}
