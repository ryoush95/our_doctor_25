import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/product_like_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/item_product1.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/noline_input.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class ProductList extends StatefulWidget {
  ProductList({Key? key, required this.category, this.order = "like", this.keyword = ""}) : super(key: key);

  final String category;
  final String order;
  final String keyword;

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends BaseState<ProductList> {
  final searchController = TextEditingController();
  final HttpService httpService = HttpService();
  ScrollController scrollController = ScrollController();
  bool isLast = false;
  String keyword = "";
  int nPage = 0;
  String? _selection = LanguageService.trans("recent");
  List<ProductLikeDto> arrProductList = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(loadMore);
    keyword = widget.keyword;
    searchController.text = keyword;
    _selection = widget.order == "like" ? LanguageService.trans("popular") : LanguageService.trans("recent");
    getProductList();
  }

  void refresh() {
    nPage = 0;
    getProductList();
  }

  void loadMore() {
    if (!isLoading) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getProductList();
      }
    }
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, "200");
    return true;
  }

  // Network functions
  //////////////////////////////////
  //상품 목록 얻기
  Future<void> getProductList() async {
    String order = _selection == LanguageService.trans("recent") ? "new" : "like";
    setState(() {
      isLoading = true;
    });

    Future<ProductLikeListResModel> info = httpService.productLikeList1(widget.category, "", "", keyword, "", "false", order, nPage, "");
    info.then((ProductLikeListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && arrProductList.isNotEmpty) {
          arrProductList.clear();
        }
        isLast = value.data!.isLast!;
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        isAvoidResize: false,
        onBack: onBackPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SimpleHeader(
              title: widget.category == "GROWTH" ? "성장스토어" : (widget.category == "DEVELOPMENT" ? "발달클래스" : "MBTI"),
              onBackPressed: onBackPressed,
            ),
            prevHeader()
          ],
        ));
  }

  Widget prevHeader() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SearchBar(),
        const SizedBox(height: 30),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H18(
                text: LanguageService.trans("all"),
                weight: FW.regular,
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
                      refresh();
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
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: screenSize.height - 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  itemCount: arrProductList.length,
                  itemBuilder: Itembuild,
                ))
              ],
            ))
      ],
    );
  }

  Widget Itembuild(BuildContext context, int index) {
    return ItemProduct1(data: arrProductList[index]);
  }

  Widget SearchBar() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: AppColor_Light_Gray, borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: Image.asset('assets/search_black_24dp.png', width: 20),
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  keyword = searchController.value.text;
                  nPage = 0;
                  getProductList();
                });
              },
            ),
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
                  FocusScope.of(context).requestFocus(FocusNode()),
                  nPage = 0,
                  getProductList(),
                },
                placeholder: LanguageService.trans('search_hint'),
                onChanged: (text) => {keyword = text},
              ),
            )
          ],
        ));
  }
}
