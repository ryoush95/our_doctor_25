import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:sprintf/sprintf.dart';

class ItemProduct2 extends StatefulWidget {
  ItemProduct2({Key? key, required this.data}) : super(key: key);

  final PdtLikeDto data;

  @override
  ItemProduct2State createState() => ItemProduct2State();
}

class ItemProduct2State extends BaseState<ItemProduct2> {
  //List<BannerList>? arrBannerList;
  final bool checkStatus = false;

  @override
  void initState() {
    super.initState();
  }

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
          if (widget.data.liked! == "0") {
            widget.data.liked = "1";
          } else {
            widget.data.liked = "0";
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
          width: (MediaQuery.of(context).size.width - 64 - 10) / 2,
          // margin: const EdgeInsets.only(right: 20, top: 20),
          height: (MediaQuery.of(context).size.width - 64 - 10) / 2 + 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  height: (MediaQuery.of(context).size.width - 64 - 10) / 2,
                  width: (MediaQuery.of(context).size.width - 64 - 10) / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // image: const DecorationImage(image: AssetImage
                    //   ("assets/bg_child_on.png"),fit: BoxFit.cover),
                  ),
                  child: Stack(
                    children: [
                      Visibility(
                          visible: widget.data.mainImage!.isEmpty,
                          child: Center(
                            child: Image.asset(
                              "assets/img_test1.png",
                              fit: BoxFit.fill,
                            ),
                          )),
                      Visibility(
                        visible: widget.data.mainImage!.isNotEmpty,
                        child: ClipPath(
                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: ExtendedImage.network(
                            widget.data.mainImage!,
                            height: (MediaQuery.of(context).size.width - 64 - 10) / 2,
                            width: (MediaQuery.of(context).size.width - 64 - 10) / 2,
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
                          productLike(widget.data.id!);
                        },
                        child: widget.data.liked! == "1"
                            ? Image.asset('assets/ic_heart_on.png', width: 40)
                            : Image.asset(
                                'assets/ic_heart_off.png',
                                width: 40,
                              )),
                    right: 5,
                    top: 5),
              ]),
              const SizedBox(height: 15),
              Container(
                width: 150,
                child: H16(
                  text: widget.data.name!,
                  weight: FW.regular,
                  maxLine: 1,
                  align: TextAlign.start,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 150,
                child: H16(
                  text: ValidPrice(sprintf("%.0f", [double.parse(widget.data.price!)])) + "원",
                  weight: FW.bold,
                  maxLine: 1,
                  align: TextAlign.start,
                  color: AppColor_Primary,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: (MediaQuery.of(context).size.width - 64 - 10) / 2,
                  height: 22,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.tags! == "" ? 0 : widget.data.tags!.split(",").length,
                      itemBuilder: (BuildContext context, int index) {
                        String tag = widget.data.tags!.split(",").length > index ? widget.data.tags!.split(",")[index] : "";
                        return Container(
                          height: tag == "" ? 0 : 22,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.only(right: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11.0),
                            border: Border.all(color: AppColor_Selector_Border),
                          ),
                          child: Center(
                            child: H14(
                              text: tag,
                              weight: FW.regular,
                              color: AppColor_GrayText,
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          )),
      onTap: () async {
        String recv = await Navigator.push(context, SlideRightTransRoute(builder: (context) => ProductDetail(
          pid: widget.data.id!,
        )));
        if (recv != "") {
          widget.data.liked = recv;
          setState(() {});
        }
      },
    );
  }

  // Widget buildtagItem(int index) {
  //   String tag = widget.data.tags!.split(",").length > index ? widget.data.tags!.split(",")[index] : "";
  //   return Container(
  //     height: tag == "" ? 0 : 22,
  //     padding: const EdgeInsets.symmetric(horizontal: 5),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(11.0),
  //       border: Border.all(color: checkStatus ? AppColor_Primary : AppColor_Selector_Border),
  //     ),
  //     child: Center(
  //       child: H14(
  //         text: tag,
  //         weight: FW.regular,
  //         color: AppColor_GrayText,
  //       ),
  //     ),
  //   );
  // }
}
