import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/product_like_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/item_product1.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';

class ProductListSub extends StatefulWidget {
  ProductListSub({Key? key, this.title = "items", this.type1 = -1, this.type2 = -1, this.type3 = -1}) : super(key: key);

  final String title;
  final int type1;
  final int type2;
  final int type3;

  @override
  ProductListSubState createState() => ProductListSubState();
}

class ProductListSubState extends BaseState<ProductListSub> {
  final searchController = TextEditingController();
  final HttpService httpService = HttpService();
  ScrollController scrollController = ScrollController();
  String keyword = "";

  bool isLast = false;
  int nPage = 0;
  List<ProductLikeDto> arrProductList = [];

  @override
  void initState() {
    super.initState();
    //getProductList(); yj temp
    for (int i = 0; i < 10; i++) {
      ProductLikeDto info = ProductLikeDto();
      info.category = "";
      info.name = "상품이름";
      info.price = "144000";
      info.tags = "태그";
      info.tags = "태그,태그,태그";
      info.mainImage = "";
      info.liked = "1";
      arrProductList.add(info);
    }
    setState(() {});
  }

  Future<void> getProductList() async {
    setState(() {
      isLoading = true;
    });
    int length = 8;
    int t1 = widget.type1;
    int t2 = widget.type2;
    int t3 = widget.type3;
    Future<ProductListResModel> info = httpService.getProductList(t1.toString(), t2.toString(), t3.toString(), (nPage * 6).toString(), length.toString(), keyword);
    info.then((ProductListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && arrProductList.isNotEmpty) {
          arrProductList.clear();
        }
        isLast = value.data!.isLast!;
        // arrProductList.addAll(value.data!.lists!);
        setState(() {});
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
      showToast(onError.toString());
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: screenSize.width - 200, child: H20(text: widget.title, weight: FW.bold, maxLine: 2, align: TextAlign.start)),
              InkWell(
                onTap: () {
                  //Navigator.push(context, SlideRightTransRoute(builder: (context) => ProductList(type1: widget.type1, type2: widget.type2, type3: widget.type3, type4: 1, title: LanguageService.trans('growth_store'))));
                },
                child: H14(text: LanguageService.trans("view_more"), weight: FW.medium),
              ),
            ],
          ),
        ),
        GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 10),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          itemCount: arrProductList.length,
          itemBuilder: Itembuild,
        )
      ],
    );
  }

  Widget Itembuild(BuildContext context, int index) {
    return ItemProduct1(data: arrProductList[index]);
  }
}
