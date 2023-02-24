import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/point_buying_dialog.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:sprintf/sprintf.dart';

class ItemTestProduct extends StatefulWidget {
  ItemTestProduct({Key? key, required this.data, this.likeInfo}) : super(key: key);

  final ProductDto data;
  final PdtLikeDto? likeInfo;

  @override
  ItemTestProductState createState() => ItemTestProductState();
}

class ItemTestProductState extends BaseState<ItemTestProduct> {
  //List<BannerList>? arrBannerList;
  ProductDetailDto mData = ProductDetailDto();

  //상품 좋아요
  void productLike(String pid) {
    setState(() {
      isLoading = true;
    });

    final HttpService httpService = HttpService();

    Future<DefaultResModel> info = httpService.productLike(pid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        setState(() {
          if (widget.likeInfo!.liked! == "0") {
            widget.likeInfo!.liked = "1";
          } else {
            widget.likeInfo!.liked = "0";
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

  int getDeliveryWon(String type) {
    for (int i = 0; i < gReviewPoint!.length; i++) {
      if (type == gReviewPoint!.elementAt(i).TYPE) {
        return int.parse(gReviewPoint!.elementAt(i).value!);
      }
    }
    return 0;
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
          width: 150,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // image: const DecorationImage(image: AssetImage
                    //   ("assets/bg_child_on.png"),fit: BoxFit.cover),
                  ),
                  child: Stack(
                    children: [
                      Visibility(
                          visible: widget.likeInfo!.mainImage!.isEmpty,
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Image.network(
                              widget.likeInfo!.mainImage!,
                              fit: BoxFit.fill,
                              width: 150,
                              height: 150,
                            ),
                          )),
                      Visibility(
                        visible: widget.likeInfo!.mainImage!.isNotEmpty,
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: ExtendedImage.network(
                            widget.likeInfo!.mainImage!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                            cache: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    child: InkWell(
                      onTap: () {
                        productLike(widget.likeInfo!.id!);
                      },
                      child: widget.likeInfo!.liked! == "1"
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.pinkAccent,
                            )
                          : Icon(Icons.favorite_border, color: Colors.black26),
                    ),
                    right: 5,
                    top: 5),
              ]),
              const SizedBox(height: 16),
              Container(
                width: 150,
                child: H14(
                  text: widget.likeInfo!.name!,
                  weight: FW.regular,
                  maxLine: 1,
                  align: TextAlign.start,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: H16(
                    text: ValidPrice(sprintf("%.0f", [double.parse(widget.likeInfo!.price!)])) + "P",
                    weight: FW.bold,
                    maxLine: 1,
                    align: TextAlign.left,
                    color: AppColor_Primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //카테고리 부분
              widget.likeInfo!.tags == null
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 150,
                      height: 22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.likeInfo!.tags!.split(",").length,
                        itemBuilder: (BuildContext context, int index) {
                          String tag =
                              widget.likeInfo!.tags!.split(",").length > index
                                  ? widget.likeInfo!.tags!.split(",")[index]
                                  : "";
                          return Container(
                            height: tag == "" ? 0 : 22,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            margin: const EdgeInsets.only(right: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.0),
                              border:
                                  Border.all(color: AppColor_Selector_Border),
                            ),
                            child: Center(
                              child: H14(
                                text: tag,
                                weight: FW.regular,
                                color: AppColor_GrayText,
                              ),
                            ),
                          );
                        },
                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      ),
                    ),
            ],
          )),
      onTap: () async {
        if (widget.likeInfo!.category2 == "SOON"){
          showToast("comming soon 우리 곧 만나요 ~");
        } else {
          showReviewDialog();
        }
      },
    );
  }

  void showReviewDialog() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return PointBuyingDialog( pid: widget.likeInfo!.id!);
        });
  }

  Widget buildChip(String label) {
    return Chip(
      side: BorderSide(width: 1, color: AppColor_Gray),
      label: Text(
        label,
        style: TextStyle(
          color: AppColor_GrayText,
        ),
      ),
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(2),
    );
  }
}
