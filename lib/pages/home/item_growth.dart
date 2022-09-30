import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:sprintf/sprintf.dart';

class ItemGrowth extends StatefulWidget {
  ItemGrowth({Key? key, this.info}) : super(key: key);
  GrowthList? info;

  @override
  ItemGrowthState createState() => ItemGrowthState();
}

class ItemGrowthState extends BaseState<ItemGrowth> {
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
          if (widget.info!.liked! == "0") {
            widget.info!.liked = "1";
          } else {
            widget.info!.liked = "0";
          }
        });
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
    return Container(
      width: 150,
      height: 236,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: ExtendedImage.network(
                  widget.info!.mainImage!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                  cache: true,
                ),
              ),
              Positioned(
                  child: InkWell(
                      onTap: () {
                        productLike(widget.info!.id!);
                      },
                      child: widget.info!.liked! == "1"
                          ? Icon(Icons.favorite, color: Colors.pinkAccent,)
                          : Icon(Icons.favorite_border, color: Colors.black26),
                          /*? Image.asset('assets/ic_heart_on.png', width: 40)
                          : Image.asset(
                              'assets/ic_heart_off.png',
                              width: 40,
                            )*/),
                  right: 5,
                  top: 5),
            ],
          ),
          const SizedBox(height: 15),
          H14(
            text: widget.info!.name!,
            weight: FW.regular,
          ),
          const SizedBox(height: 6),
          Container(
            width: 150,
            child: H16(
              text: ValidPrice(
                      sprintf("%.0f", [double.parse(widget.info!.price!)])) +
                  "원",
              weight: FW.bold,
              maxLine: 1,
              align: TextAlign.start,
              color: AppColor_Primary,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: (MediaQuery.of(context).size.width - 64 - 10) / 2,
            height: 22,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.info!.tags!.split(",").length,
                itemBuilder: (BuildContext context, int index) {
                  String tag = widget.info!.tags!.split(",").length > index
                      ? widget.info!.tags!.split(",")[index]
                      : "";
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
        ],
      ),
    );
  }

// Widget buildtagItem(int index) {
//   String tag = widget.info!.tags!.split(",").length > index ? widget.info!.tags!.split(",")[index] : "";
//   return Container(
//     height: tag == "" ? 0 : 22,
//     padding: const EdgeInsets.symmetric(horizontal: 5),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(11.0),
//       border: Border.all(color: AppColor_Selector_Border),
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
