import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/order_start_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/test2_quiz_list_model.dart';
import 'package:ourdoctor/pages/care/inspection_test2_answer.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/my/custom_mbti_inspection.dart';
import 'package:ourdoctor/pages/my/inspection_first2.dart';
import 'package:sprintf/sprintf.dart';

import 'inspection_test2_first.dart';

class PointBuyingDialog extends StatefulWidget {
  PointBuyingDialog({Key? key, required this.pid}) : super(key: key);

  String? pid;
  @override
  PointBuyingDialogState createState() => PointBuyingDialogState();
}

class PointBuyingDialogState extends State<PointBuyingDialog> {
  bool isLoading = false;

  final HttpService httpService = HttpService();
  var pointInputController = TextEditingController();
  bool isValid = true;
  bool showProduct = false;
  ProductDetailDto mData = ProductDetailDto();
  String calPrice = "";


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('PointBuyingDialogState');
    getProductDetail();
    mData.name = "";
    mData.mainImage = "";
    mData.detailImage = "";
    mData.description = "";
    mData.price = "0";
    mData.notice = "0";
    mData.discount = "0";
    mData.liked = "0";
    mData.notice = "";
    mData.tags = "";
    mData.category2 = "";
    mData.category3 = "";
    setState(() {});
  }

  checkValid() {
    int dis = int.parse(calPrice);
    if (int.parse(gUserInfo!.point!) > dis){
      setState(() {
        isValid = false;
      });
    }
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void subtractionPoint() {
    setState(() {
      isLoading = true;
    });

  }

  void getProductDetail() {
    setState(() {
      isLoading = true;
    });
    Future<ProductDetailResModel> info =
    httpService.getProductDetail(widget.pid!);
    info.then((ProductDetailResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        mData = value.data!;
        double dis = double.parse(mData.price!) * ((100 - int.parse(mData.discount!)) / 100);
        setState(() {
          calPrice = dis.round().toString();
          checkValid();
        });
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void savePoint() async{
    Future<OrderStartResModel> info = httpService.pointChange('ordered',"-" + calPrice);
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast('결제가 완료되었습니다.');
        int myp = int.parse(gUserInfo!.point!) - int.parse(calPrice);
        gUserInfo!.point = myp.toString();
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(children: [
              const SizedBox(height: 30),
              H18(
                text: "검사를 위해 포인트가 필요해요!",
                maxLine: 1,
                align: TextAlign.center,
                height: 1.3,
                weight: FW.semi_bold,
              ),
              const SizedBox(height: 20),
              const Divider(
                color: AppColor_Table_DateTime,
                thickness: 1,
              ),
              Row(
                children: [
                  H16(text: "사용 가능한 우아포인트  ", weight: FW.regular, color: AppColor_BlackText.withOpacity(0.6)),
                  H18(text: ValidPrice(gUserInfo!.point!), weight: FW.semi_bold, color: AppColor_BlackText.withOpacity(0.6)),
                  H16(text: "P", weight: FW.regular, color: AppColor_BlackText.withOpacity(0.6)),
                ],
              ),
              const Divider(
                color: AppColor_Table_DateTime,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  H16(
                    text: LanguageService.trans("검사 포인트"),
                    weight: FW.regular,
                    color: AppColor_BlackText,
                  ),
                  const SizedBox(width: 20),
                  H16(
                    text: sprintf("%s %s", [ValidPrice(mData.price.toString()), "P"]),
                    weight: FW.regular,
                    color: AppColor_BlackText,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Visibility(
                  visible: mData.discount != "0",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      H16(
                        text: LanguageService.trans("우아 할인가"),
                        weight: FW.regular,
                        color: AppColor_BlackText,
                      ),
                      const SizedBox(width: 20),
                      H16(
                        text: mData.discount != ""
                            ? (sprintf("%s%s", [mData.discount, "%"]))
                            : "",
                        maxLine: 2,
                        align: TextAlign.start,
                        color: AppColor_Red,
                      ),
                    ],
              )),
              const SizedBox(height: 20),
              const SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  H16(
                    text: LanguageService.trans("포인트 사용"),
                    weight: FW.medium,
                    color: AppColor_BlackText,
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      H18(
                        text: mData.price != null
                            ? ValidPrice(mData.discount != ""
                            ? calPrice
                            : mData.price!)
                            : "0",
                        align: TextAlign.start,
                        weight: FW.bold,
                        color: AppColor_BlackText,
                      ),
                      H16(
                        text: " P",
                        align: TextAlign.start,
                        weight: FW.regular,
                      ),
                    ],
                  )

                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainTextButton(
                    text: LanguageService.trans("검사 시작하기"),
                    backgroundColor: AppColor_Primary,
                    style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                    width: (MediaQuery.of(context).size.width - 70),
                    height: 58,
                    disableBackground: AppColor_Primary_Disable,
                    disable: isValid,
                    onPressed: () {
                      if(isValid){
                        showToast('포인트가 부족합니다.');
                        return;
                      }
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('검사 시작'),
                          titleTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.semi_bold),
                          content: Text('${calPrice} 포인트가 차감됩니다.\n검사를 시작할까요?'),
                          contentTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.regular),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('아니오'),
                            ),
                            TextButton(
                              onPressed: () {
                                savePoint();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  SlideRightTransRoute(
                                      builder: (context) {
                                        if (widget.pid == "36") {
                                          return CustomMbtiInspectionMainPage();
                                        }
                                        if (mData.category2 == "TEST2"){
                                          return InspectionTest2FirstPage(data: mData,);
                                        }
                                        return InspectionFirstPage2(list: []);
                                      }),
                                );
                              },
                              child: const Text('네'),
                            ),
                          ],
                        ),
                      );
                      // const CustomMbtiInspectionMainPage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ),
        onWillPop: onBackPressed);
  }
}
