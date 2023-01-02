import 'package:flutter/material.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/item_product.dart';
import 'package:ourdoctor/pages/care/product_list.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';

class ProductShow extends StatefulWidget {
  ProductShow({Key? key, this.category = 0, this.title = "items", required this.list}) : super(key: key);

  final int category;
  final String title;
  final List<PdtLikeDto>? list;

  @override
  ProductShowState createState() => ProductShowState();
}

class ProductShowState extends BaseState<ProductShow> {
  //List<BannerList>? arrBannerList;

  // String? id;
  // String? category;
  // String? name;
  // String? option;
  // String? price;
  // String? tags;
  // String? add_time;
  // String? liked;
  // String? mainImage;
  // String? discount;
  ProductDto info = ProductDto();
  @override
  void initState() {
    super.initState();

    info.category = "";
    info.name = "상품이름";
    info.option = "옵션";
    info.price = "144000";
    info.tags = "태그";
    info.tags = "태그,태그,태그";
    info.mainImage = "";
    info.liked = "1";
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        height: 380,
        margin: const EdgeInsets.only(left: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                H18(text: widget.title),
                InkWell(
                  onTap: () async {
                    String recv = await Navigator.push(
                        context,
                        SlideRightTransRoute(
                            builder: (context) => ProductList(
                                  category: widget.category == 0 ? "GROWTH" : "DEVELOPMENT",
                                  order: widget.title == "인기 상품" ? "like" : "new",
                                )));
                    if (recv == "200") {
                      eventBus.fire(HomeCareTabEvent(type: widget.category));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: H14(text: LanguageService.trans("view_more")),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 340,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  // itemCount: arrBannerList == null ? 0 : arrBannerList!.length,
                  itemCount: widget.list!.length,
                  itemBuilder: (BuildContext context, int index) {
                    //BannerList info = arrBannerList!.elementAt(index);
                    return Container(
                      // padding: const EdgeInsets.only(right: 20),
                      child: ItemProduct(data: info, info: widget.list!.elementAt(index)),
                    );
                  }),
            )
          ],
        ));
  }
}
