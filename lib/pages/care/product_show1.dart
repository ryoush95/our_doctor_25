import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/models/res/mbti_quiz_send_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/item_product.dart';
import 'package:ourdoctor/pages/care/product_list.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';

import 'item_test_product.dart';


class ProductShow1 extends StatefulWidget {
  ProductShow1({Key? key, this.category = 0, this.title = "items", required this.list}) : super(key: key);

  final int category;
  final String title;
  final List<PdtLikeDto>? list;

  @override
  ProductShow1State createState() => ProductShow1State();
}

class ProductShow1State extends BaseState<ProductShow1> {
  //List<BannerList>? arrBannerList;

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
                      padding: const EdgeInsets.only(right: 20),
                      child: ItemTestProduct(data: info, likeInfo: widget.list!.elementAt(index)),
                    );
                  }),
            )
          ],
        ));
  }
}
