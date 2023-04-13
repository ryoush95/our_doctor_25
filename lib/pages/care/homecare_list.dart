import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/models/homecare_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/item_product2.dart';
import 'package:ourdoctor/pages/care/product_list.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';

class HomeCareListPage extends StatefulWidget {
  HomeCareListPage({Key? key, required this.category_1, required this.category_2}) : super(key: key);

  String? category_1;
  String? category_2;

  @override
  HomeCareListPageState createState() => HomeCareListPageState();
}

class HomeCareListPageState extends BaseState<HomeCareListPage> {
  List<PdtLikeDto>? arrPdtList1 = [];
  List<PdtLikeDto>? arrPdtList2 = [];
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();

    getStoreList();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, "200");
    return true;
  }

  double getList1height() {
    double allheight = 0;
    if (arrPdtList1!.isEmpty) {
      return allheight;
    }
    double itemheight = (MediaQuery.of(context).size.width - 64 - 10) / 2 + 120;
    int count = arrPdtList1!.length ~/ 2;
    int diff = arrPdtList1!.length % 2;
    if (diff == 1) {
      count++;
    }
    allheight = itemheight * count;
    return allheight;
  }

  double getList2height() {
    double allheight = 0;
    if (arrPdtList2!.isEmpty) {
      return allheight;
    }
    double itemheight = (MediaQuery.of(context).size.width - 64 - 10) / 2 + 120;
    int count = arrPdtList2!.length ~/ 2;
    int diff = arrPdtList2!.length % 2;
    if (diff == 1) {
      count++;
    }
    allheight = itemheight * count;
    return allheight;
  }

  String getTitle() {
    String result = "";
    if (widget.category_2 == "BODY") {
      result = "신체";
    } else if (widget.category_2 == "BRAIN") {
      result = "두뇌";
    } else if (widget.category_2 == "RECOMMEND") {
      result = "맞춤추천";
    }

    return result;
  }

  String getImageName() {
    String result = "";
    if (widget.category_1 == "GROWTH") {
      if (widget.category_2 == "BODY") {
        result = "assets/face_retouching_natural_black_24dp.png";
      } else if (widget.category_2 == "BRAIN") {
        result = "assets/psychology_black_24dp.png";
      } else if (widget.category_2 == "RECOMMEND") {
        result = "assets/volunteer_activism_black_24dp.png";
      }
    } else {
      if (widget.category_2 == "BODY") {
        result = "assets/face_retouching_natural_black_24dp1.png";
      } else if (widget.category_2 == "BRAIN") {
        result = "assets/psychology_black_24dp1.png";
      } else if (widget.category_2 == "RECOMMEND") {
        result = "assets/volunteer_activism_black_24dp1.png";
      }
    }

    return result;
  }

  String getSubTitle() {
    String result = "";
    if (widget.category_2 == "BODY") {
      result = "신체 발달에 도움이 되는 상품을 추천 드릴게요";
    } else if (widget.category_2 == "BRAIN") {
      result = "두뇌 발달에 도움이 되는 상품을 추천 드릴게요";
    } else if (widget.category_2 == "RECOMMEND") {
      result = "우리 아이에게 딱 맞는 발달클래스";
    }

    return result;
  }

  String getList1Name() {
    String result = "";
    if (widget.category_1 == "GROWTH") {
      if (widget.category_2 == "BODY") {
        result = "키·체중 발달클래스";
      } else if (widget.category_2 == "BRAIN") {
        result = "언어 발달 관련 상품 ";
      } else if (widget.category_2 == "RECOMMEND") {
        result = "자주 구매했어요.";
      }
    } else {
      if (widget.category_2 == "BODY") {
        result = "키·체중 발달클래스";
      } else if (widget.category_2 == "BRAIN") {
        result = "언어 발달클래스";
      } else if (widget.category_2 == "RECOMMEND") {
        result = getAge(gSelChildInfo!.birth!) + "세가 많이 수강중이에요.";
      }
    }

    return result;
  }

  String getList2Name() {
    String result = "";
    if (widget.category_1 == "GROWTH") {
      if (widget.category_2 == "BODY") {
        result = "생활습관 개선 관련 상품";
      } else if (widget.category_2 == "BRAIN") {
        result = "운동 발달 관련 상품";
      } else if (widget.category_2 == "RECOMMEND") {
        // result = gSelChildInfo!.name! + "어린이 맞춤 상품";
        result = "";
      }
    } else {
      if (widget.category_2 == "BODY") {
        result = "생활습관 발달클래스";
      } else if (widget.category_2 == "BRAIN") {
        result = "운동 발달클래스";
      } else if (widget.category_2 == "RECOMMEND") {
        // result = gSelChildInfo!.name! + "어린이 맞춤 클래스";
        result = "";
      }
    }

    return result;
  }

  // Network functions
  //////////////////////////////////
  void getStoreList() {
    setState(() {
      isLoading = true;
    });

    Future<HomeCareListResModel> info = httpService.homecareStoreData(widget.category_1!, widget.category_2!);
    info.then((HomeCareListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrPdtList1 = value.data!.list1;
        // arrPdtList1!.addAll(value.data!.list2!);
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        onBack: onBackPressed,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(
                    height: 62,
                    child: Row(
                      children: [
                        const SizedBox(width: 30),
                        InkWell(
                          onTap: () {
                            onBackPressed();
                          },
                          child: Image.asset(
                            'assets/path_12225.png',
                            width: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: H18(
                                text: widget.category_1 == "GROWTH" ? "성장스토어" : "발달클래스",
                                weight: FW.medium,
                                height: 1.2,
                                color: AppColor_BlackText,
                                maxLine: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                H18(
                                  text: getTitle(),
                                  color: AppColor_BlackText,
                                ),
                                const SizedBox(width: 6),
                                Image.asset(getImageName(), width: 32),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: screenSize.width - 64,
                                    child: H16(
                                      text: getSubTitle(),
                                      weight: FW.medium,
                                      maxLine: 2,
                                      align: TextAlign.start,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 42),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                height: screenSize.height - 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: GridView.builder(
                                          // controller: scrollController,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                          itemCount: arrPdtList1!.length,
                                          itemBuilder: Itembuild1,
                                        ))
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            )));
  }

  Widget Itembuild1(BuildContext context, int index) {
    return ItemProduct2(data: arrPdtList1![index]);
  }

  Widget Itembuild2(BuildContext context, int index) {
    return ItemProduct2(data: arrPdtList2![index]);
  }
}
