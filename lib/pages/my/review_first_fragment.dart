import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/my_review_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/my/review_write.dart';
import 'package:sprintf/sprintf.dart';

class ReviewFirstFragment extends StatefulWidget {
  @override
  ReviewFirstFragmentState createState() => ReviewFirstFragmentState();
}

class ReviewFirstFragmentState extends BaseState<ReviewFirstFragment> {
  final HttpService httpService = HttpService();
  late ScrollController _scrollController;
  late ScrollController _listController;

  bool isLast = false;
  int nPage = 0;
  List<MyReviewDto> productList = [];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _scrollController = ScrollController()..addListener(loadMore);
    getReviewList();
    eventBus.on<AddReviewEvent>().listen((event) {
      if (mounted) {
        nPage = 0;
        getReviewList();
      }
    });
  }

  void loadMore() {
    if (!isLoading) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getReviewList();
      }
    }
  }

  // Network functions
  //////////////////////////////////
  Future<void> getReviewList() async {
    setState(() {
      isLoading = true;
    });
    int length = 8;
    Future<MyReviewListResModel> info = httpService.myReviewList(1, nPage);
    info.then((MyReviewListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && productList.isNotEmpty) {
          productList.clear();
        }
        isLast = value.data!.isLast!;
        productList.addAll(value.data!.list!);
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {}
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
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

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: _itemBuilder,
                      itemCount: productList.length,
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
    MyReviewDto info = productList.elementAt(index);
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
                H12(
                  text: sprintf("%s %s", [LanguageService.trans("purchase_confirmation"), info.confirmDate]),
                  color: AppColor_BlackText.withOpacity(0.4),
                  weight: FW.semi_bold,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ExtendedImage.network(info.mainImage!, width: 60, height: 60, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(6))),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H14(text: info.name!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.8)),
                        const SizedBox(height: 5),
                        H14(text: info.optionName!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.3)),
                      ],
                    )
                    //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(thickness: 1, color: AppColor_Light_Gray),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        H12(text: sprintf("%s %s %s", ["최대 적립", "500", "p"]), color: AppColor_BlackText.withOpacity(0.8), weight: FW.semi_bold),
                        const SizedBox(height: 5),
                        H12(text: sprintf("%s %d", [LanguageService.trans("completed_d"), 30 - int.parse(info.dDay!)]), color: AppColor_BlackText.withOpacity(0.4), weight: FW.semi_bold),
                      ],
                    ),
                    MainTextButton(
                      text: "후기 작성",
                      backgroundColor: AppColor_Light_Gray,
                      width: 100,
                      height: 40,
                      radius: 8,
                      onPressed: () {
                        Navigator.push(context, SlideRightTransRoute(builder: (context) => WriteReviewPage(pid: info.productId, opid: info.orderProductId)));
                      },
                    )
                  ],
                ),
                const SizedBox(height: 12),
              ],
            )),
        const Divider(thickness: 10, color: AppColor_Light_Gray),
      ],
    );
  }
}
