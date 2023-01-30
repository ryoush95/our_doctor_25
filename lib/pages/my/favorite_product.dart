import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/basket_add_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/product_like_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:sprintf/sprintf.dart';

class FavoriteProductPage extends StatefulWidget {
  @override
  FavoriteProductPageState createState() => FavoriteProductPageState();
}

class FavoriteProductPageState extends BaseState<FavoriteProductPage> {
  final HttpService httpService = HttpService();
  late ScrollController _scrollController;
  late ScrollController _listController;

  bool isLast = false;
  int nPage = 0;
  int total_count = 0;
  List<ProductLikeDto> arrProductList = [];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _scrollController = ScrollController()..addListener(loadMore);
    getFavoritesList();
  }

  void loadMore() {
    if (!isLoading) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getFavoritesList();
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
    super.dispose();
  }

  // Network functions
  //////////////////////////////////
  //찜한 상품 목록 얻기
  Future<void> getFavoritesList() async {
    setState(() {
      isLoading = true;
    });

    //String keyword, String name, String only_like, String order_by, int page, String tags
    Future<ProductLikeListResModel> info = httpService.productLikeList("", "", "true", "like", 0, "");
    info.then((ProductLikeListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && arrProductList.isNotEmpty) {
          arrProductList.clear();
        }
        isLast = value.data!.isLast!;
        total_count = value.data!.totalCount!;
        arrProductList.addAll(value.data!.list!);
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

  //좋아요 삭제
  void onDelete(String pid, int index) {
    Future<DefaultResModel> info = httpService.productLike(pid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrProductList.removeAt(index);
        total_count = total_count - 1;
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

  //장바구니 추가
  void reqAddBasket(ProductLikeDto mInfo) {
    List<Map<String, String>> optList = [];
    Map<String, String> item = {
      'name': mInfo.name!,
      'price': mInfo.price!,
      'discount': mInfo.discount!,
      'count': "1",
    };
    optList.add(item);
    String opt_list = json.encode(optList);

    setState(() {
      isLoading = true;
    });

    final HttpService httpService = HttpService();
    List<BasketAddDto>? list = [];
    Future<BasketAddResModel> info = httpService.addBakset(mInfo.id!, opt_list);
    info.then((BasketAddResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast("장바구니에 추가되었습니다.");
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
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("fav_item"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        H16(text: "전체 ", weight: FW.regular),
                        H16(text: total_count.toString(), weight: FW.bold),
                        H16(text: "개", weight: FW.regular),
                      ]),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: _itemBuilder,
                      itemCount: arrProductList.length,
                      controller: _listController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    ProductLikeDto info = arrProductList.elementAt(index);
    return Column(
      children: [
        Container(
            width: screenSize.width,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    ExtendedImage.network(info.mainImage!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.fill,
                        cache: true,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        )),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H14(text: info.name!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.8)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Visibility(
                              visible: int.parse(info.discount!) > 0,
                              child: H16(
                                text: sprintf("%s%s", [info.discount, "%"]),
                                weight: FW.medium,
                                color: AppColor_Red,
                              ),
                            ),
                            Visibility(
                                visible: int.parse(info.discount!) > 0,
                                child: const SizedBox(
                                  width: 10,
                                )),
                            Visibility(
                              visible: int.parse(info.discount!) > 0,
                              child: H16(
                                text: sprintf("%s%s", [ValidPrice((doubleParse(info.price!) / 100 * (100 - int.parse(info.discount!))).toString()), "원"]),
                                weight: FW.medium,
                                color: AppColor_414141,
                              ),
                            ),
                            Visibility(
                              visible: int.parse(info.discount!) == 0,
                              child: H16(
                                text: ValidPrice(info.price!) + "원",
                                weight: FW.medium,
                                color: AppColor_414141,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Visibility(
                              visible: int.parse(info.discount!) > 0,
                              child: Text(
                                sprintf("%s%s ", [ValidPrice(doubleParse(info.price!).toString()), "원"]),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  // fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  height: 1.0,
                                  color: AppColor_BlackText.withOpacity(0.4),
                                  decoration: TextDecoration.lineThrough,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            MainTextButton(
                              text: LanguageService.trans("delete"),
                              showBorder: true,
                              borderColor: AppColor_Gray,
                              width: (screenSize.width - 60 - 120 - 25) / 2,
                              height: 36,
                              radius: 8,
                              backgroundColor: AppColor_White,
                              style: AppTextStyle.PD(AppColor_414141, 14, weight: FW.regular),
                              onPressed: () {
                                onDelete(info.id!, index);
                              },
                            ),
                            const SizedBox(width: 8),
                            // MainTextButton(
                            //   text: LanguageService.trans("shopping_basket"),
                            //   showBorder: true,
                            //   borderColor: AppColor_Primary,
                            //   width: (screenSize.width - 60 - 120 - 25) / 2,
                            //   height: 36,
                            //   radius: 8,
                            //   backgroundColor: AppColor_White,
                            //   style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.regular),
                            //   onPressed: () {
                            //     reqAddBasket(info);
                            //   },
                            // )
                          ],
                        )
                      ],
                    )
                    //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ))
      ],
    );
  }
}
