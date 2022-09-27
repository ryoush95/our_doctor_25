import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/basket_add_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/shopping_basket.dart';
import 'package:sprintf/sprintf.dart';

class ProductDialog extends StatefulWidget {
  ProductDialog({Key? key, required this.list, this.pImg}) : super(key: key);

  List<BasketAddDto>? list;
  String? pImg;

  @override
  ProductDialogState createState() => ProductDialogState();
}

class ProductDialogState extends State<ProductDialog> {
  final HttpService httpService = HttpService();
  bool valid = false;
  var contentController = TextEditingController();
  String content = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void onLeaveMessage() {
    Navigator.pop(context);
  }

  void checkValid() {
    setState(() {
      valid = content.isNotEmpty;
    });
  }

  // Network functions
  //////////////////////////////////
  //결과메시지 남기기
  Future<void> reqSendMsg() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo = httpService.sendMsg(content);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('send_msg_success'));
        Navigator.pop(context);
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
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7 - 75,
            // padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColor_Gray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: ExtendedImage.network(
                                  widget.pImg!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fill,
                                  cache: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 50,
                              child: Center(
                                child: H16(
                                  text: "장바구니에 상품을 담았어요",
                                  color: AppColor_BlackText.withOpacity(0.8),
                                  weight: FW.medium,
                                  height: 1.3,
                                  maxLine: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SlideRightTransRoute(
                                    builder: (context) =>
                                        ShoppingBasketPage()));
                          },
                          child: Container(
                              child:
                                  H14(text: "바로가기", color: AppColor_Primary)),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(color: AppColor_Gray, height: 5),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  width: double.infinity,
                  child: H16(text: "다른 고객이 함께 본 상품", align: TextAlign.start),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.list!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 3),
                      itemBuilder: (BuildContext context, int index) {
                        BasketAddDto info = widget.list!.elementAt(index);
                        return Container(
                            width:
                                (MediaQuery.of(context).size.width - 64 - 10) /
                                    2,
                            // margin: const EdgeInsets.only(right: 20, top: 20),
                            height:
                                (MediaQuery.of(context).size.width - 64 - 10) /
                                        2 +
                                    120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlideRightTransRoute(
                                            builder: (context) => ProductDetail(
                                                  pid: info.id!,
                                                )));
                                  },
                                  child: Stack(children: [
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.width -
                                                  64 -
                                                  10) /
                                              2,
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  64 -
                                                  10) /
                                              2,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        // image: const DecorationImage(image: AssetImage
                                        //   ("assets/bg_child_on.png"),fit: BoxFit.cover),
                                      ),
                                      child: Stack(
                                        children: [
                                          Visibility(
                                              visible: info.mainImage!.isEmpty,
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/img_test1.png",
                                                  fit: BoxFit.fill,
                                                ),
                                              )),
                                          Visibility(
                                            visible: info.mainImage!.isNotEmpty,
                                            child: ClipPath(
                                              clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: ExtendedImage.network(
                                                info.mainImage!,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        64 -
                                                        10) /
                                                    2,
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        64 -
                                                        10) /
                                                    2,
                                                fit: BoxFit.fill,
                                                cache: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: H16(
                                    text: info.name!,
                                    weight: FW.regular,
                                    maxLine: 2,
                                    align: TextAlign.start,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: H16(
                                    text: ValidPrice(sprintf("%.0f",
                                            [double.parse(info.price!)])) +
                                        "원",
                                    weight: FW.bold,
                                    maxLine: 1,
                                    align: TextAlign.start,
                                    color: AppColor_Primary,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: (MediaQuery.of(context).size.width -
                                          64 -
                                          10) /
                                      2,
                                  height:
                                      widget.list![index].tags! == "" ? 0 : 22,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.list![index].tags! == ""
                                          ? 0
                                          : widget.list![index].tags!
                                              .split(",")
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int idx) {
                                        String tag = widget.list![index].tags!
                                                    .split(",")
                                                    .length >
                                                idx
                                            ? widget.list![index].tags!
                                                .split(",")[idx]
                                            : "";
                                        return Container(
                                          height: tag == "" ? 0 : 22,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          margin:
                                              const EdgeInsets.only(right: 4.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(11.0),
                                            border: Border.all(
                                                color:
                                                    AppColor_Selector_Border),
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
                            ));
                      }),
                ),
              ]),
            ),
          ),
          onWillPop: onBackPressed);
    });
  }

// Widget buildtagItem(int i, int index) {
//   String tag = widget.list![i].tags!.split(",").length > index ? widget.list![i].tags!.split(",")[index] : "";
//   return Container(
//     height: tag == "" ? 0 : 22,
//     padding: const EdgeInsets.symmetric(horizontal: 10),
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
