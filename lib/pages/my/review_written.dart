import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/review_detail_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/action_sheet.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

import 'review_edit.dart';

class WrittenReviewPage extends StatefulWidget {
  WrittenReviewPage({Key? key, required this.pid}) : super(key: key);
  String? pid;

  @override
  WrittenReviewPageState createState() => WrittenReviewPageState();
}

class WrittenReviewPageState extends BaseState<WrittenReviewPage> {
  final HttpService httpService = HttpService();
  final contentsController = TextEditingController();
  String content = "";
  int star = -1;
  ReviewDetailDto? review;
  int imageCount = 0;
  late ScrollController _listController;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    getReview();
    eventBus.on<EditReviewEvent>().listen((event) {
      if (mounted) {
        getReview();
      }
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    super.dispose();
    _listController.dispose();
  }

  Future<void> getReview() async {
    setState(() {
      isLoading = true;
    });
    Future<ReviewDetailResModel> info = httpService.getReviewDetail(widget.pid!);
    info.then((ReviewDetailResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        review = value.data;
        star = int.parse(value.data!.rating!);
        images = value.data!.photosUrl!.split(",");
        imageCount = images.length;
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

  void viewMore() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return ActionSheet(
              action1: LanguageService.trans('to_edit'),
              action2: LanguageService.trans('to_delete'),
              onAction1: () {
                Navigator.push(context, SlideRightTransRoute(builder: (context) => EditReviewPage(review: review)));
              },
              onAction2: () {
                reqDelete();
              });
        });
  }

  // Network functions
  //////////////////////////////////
  //리뷰 삭제
  Future<void> reqDelete() async {
    Future<DefaultResModel> offInfo = httpService.deleteReview(review!.id!);
    offInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('review_delete_success'));
        eventBus.fire(DeleteReviewEvent());
        onBackPressed();
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
      //showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("review_written"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              ExtendedImage.network(review != null ? review!.mainImage! : "", width: 75, height: 75, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(6))),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenSize.width - 150,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      H16(text: review != null ? review!.name! : "", weight: FW.regular, color: AppColor_414141),
                                      InkWell(
                                        onTap: () {
                                          viewMore();
                                        },
                                        child: Image.asset(
                                          'assets/ic_more.png',
                                          width: 25,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(height: 5),
                                  H16(text: review != null ? review!.optionName! : "", weight: FW.regular, color: AppColor_Table_DateTime),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                      height: 15,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: _itemBuilder,
                                        itemCount: 5,
                                      ))
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          Visibility(
                              visible: imageCount > 0,
                              child: Container(
                                  height: 300,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: _itemBuilder1,
                                    itemCount: imageCount,
                                    controller: _listController,
                                  ))),
                          const SizedBox(height: 25),
                          H16(
                            text: review != null ? review!.text! : "",
                            weight: FW.regular,
                            align: TextAlign.left,
                            color: AppColor_BlackText,
                            maxLine: 100,
                          ),
                          const SizedBox(height: 20),
                          H14(text: review != null ? review!.addDate! : "", color: AppColor_BlackText.withOpacity(0.4), weight: FW.regular)
                        ])),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        // star = index;
        // setState(() {});
      },
      child: Image.asset(index < star ? "assets/ic_star_on.png" : "assets/ic_star_off.png"),
    );
  }

  Widget _itemBuilder1(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        ExtendedImage.network(images[index],
            width: MediaQuery.of(context).size.width - 60,
            height: MediaQuery.of(context).size.width - 60,
            fit: BoxFit.contain,
            cache: true,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            )),
      ],
    );
  }
}
