import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/review_detail_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';

class ReviewDetailPage extends StatefulWidget {
  ReviewDetailPage({Key? key, required this.pid}) : super(key: key);

  String? pid;
  @override
  ReviewDetailPageState createState() => ReviewDetailPageState();
}

class ReviewDetailPageState extends BaseState<ReviewDetailPage> {
  bool valid = false;
  final contentsController = TextEditingController();
  String content = "";
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();

  ReviewDetailDto? dicInfo;
  @override
  void initState() {
    super.initState();

    getReviewDetail();
    checkValid();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void checkValid() {
    // if (phone.isEmpty || pwd.isEmpty || name.isEmpty || birth.isEmpty || date.isEmpty || postcode.isEmpty || address1.isEmpty || hosiptalId.isEmpty) {
    //   setState(() {
    //     valid = false;
    //   });
    // } else {
    //   setState(() {
    //     valid = true;
    //   });
    // }
  }

  // Network functions
  //////////////////////////////////
  //리뷰 상세정보 얻기
  Future<void> getReviewDetail() async {
    setState(() {
      isLoading = true;
    });
    int length = 8;
    Future<ReviewDetailResModel> info = httpService.getReviewDetail(widget.pid!);
    info.then((ReviewDetailResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicInfo = value.data;
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
                              Container(
                                height: 75,
                                width: 75,
                                decoration: const BoxDecoration(color: AppColor_White, borderRadius: BorderRadius.all(Radius.circular(12)), image: DecorationImage(image: AssetImage("assets/image_9.png"), fit: BoxFit.cover)),
                                //child: Image.asset("assets/ic_guide_logo.png")
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H16(text: "상품 이름", weight: FW.regular, color: AppColor_414141),
                                  const SizedBox(height: 5),
                                  H16(text: "option", weight: FW.regular, color: AppColor_Table_DateTime),
                                  const SizedBox(height: 15),
                                ],
                              )
                              //Image.asset('assets/ic_guide_logo.png', width: 75, height: 75),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Container(
                              height: 115,
                              decoration: BoxDecoration(
                                color: AppColor_Light_Gray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              child: TextField(
                                controller: contentsController,
                                style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: LanguageService.trans("review_content_hint"),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.regular),
                                ),
                                onChanged: (text) {
                                  content = text;
                                },
                              )),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: Container()),
                            H16(text: sprintf("%s / %s", ["0", "min 20 ja"]), weight: FW.medium, color: AppColor_414141),
                          ]),
                          const SizedBox(height: 15),
                          InkWell(
                              onTap: () {
                                print("a");
                              },
                              child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(border: Border.all(color: AppColor_BlackText), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/camera_alt_black_24dp.png", width: 24),
                                      const SizedBox(width: 10),
                                      H16(text: sprintf("%s %s/4", [LanguageService.trans("photo"), "0"]), weight: FW.medium)
                                    ],
                                  ))),
                          const SizedBox(height: 15),
                          H14(text: "If you attach a photo that is not related to the product,\n exposure may be restricted.\nPlease be careful not to include photos with personal information.", color: AppColor_GrayText, maxLine: 3, height: 1.5, align: TextAlign.left, weight: FW.regular),
                          const SizedBox(height: 10)
                        ])),
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Row(children: [
                            H16(text: LanguageService.trans("text_review"), weight: FW.regular, color: AppColor_414141),
                            Expanded(child: Container()),
                            H16(text: "200 P", weight: FW.medium, color: AppColor_414141),
                          ]),
                          const SizedBox(height: 15),
                          Row(children: [
                            H16(text: LanguageService.trans("photo_review"), weight: FW.regular, color: AppColor_414141),
                            Expanded(child: Container()),
                            H16(text: "500 P", weight: FW.medium, color: AppColor_414141),
                          ]),
                          const SizedBox(height: 20),
                          H14(
                              text:
                                  "- Review completed can be edited/deleted within 7 days.\n- Points are awarded within about 1 day after review is\ncompleted, and the timing of payment may vary depending on\noperational circumstances.\n- If there is inappropriate content such as advertisements or\nslander after reviewing the written content / If unrelated or\ninappropriate photos are attached to the product, there may be\nrestrictions on exposure and writing reviews.",
                              color: AppColor_GrayText,
                              maxLine: 8,
                              height: 1.5,
                              align: TextAlign.left,
                              weight: FW.regular),
                          const SizedBox(height: 15),
                          MainTextButton(
                            text: LanguageService.trans("completed"),
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            disable: !valid,
                            disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
                            onPressed: () {},
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
