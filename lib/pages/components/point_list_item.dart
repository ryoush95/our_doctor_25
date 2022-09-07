import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/point_his_list_res_model.dart';

import 'h12.dart';
import 'h14.dart';

class PointHistoryItem extends StatelessWidget {
  final PointHisDto item;
  String? icon;
  String? typeText;
  String? inOut;
  String? point;

  PointHistoryItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color_val = AppColor_BlackText; // as int;

    if (item.type == "welcome") {
      icon = 'assets/ic_point3.png';
      typeText = "웰컴 포인트";
      inOut = item.point! >= 0 ? LanguageService.trans("earn") : LanguageService.trans("use");
      point = (item.point! >= 0 ? (item.point == 0 ? "" : "+") : "-") + formatAmount(item.point!.abs()) + " " + LanguageService.trans("p");
      color_val = item.point! >= 0 ? AppColor_Primary : AppColor_Red;
    } else if (item.type == "ordered") {
      icon = 'assets/ic_point2.png';
      inOut = item.point! >= 0 ? LanguageService.trans("earn") : LanguageService.trans("use");
      typeText = "결제금액 0.5% " + inOut!;
      point = (item.point! >= 0 ? (item.point == 0 ? "" : "+") : "-") + formatAmount(item.point!.abs()) + " " + LanguageService.trans("p");
      color_val = item.point! >= 0 ? AppColor_Primary : AppColor_Red;
    } else if (item.type == "review_text") {
      icon = 'assets/ic_point3.png';
      inOut = item.point! >= 0 ? LanguageService.trans("earn") : LanguageService.trans("use");
      typeText = "리뷰텍스트 " + inOut!;
      point = (item.point! >= 0 ? (item.point == 0 ? "" : "+") : "-") + formatAmount(item.point!.abs()) + " " + LanguageService.trans("p");
      color_val = item.point! >= 0 ? AppColor_Primary : AppColor_Red;
    } else if (item.type == "review_image") {
      icon = 'assets/ic_point3.png';
      inOut = item.point! >= 0 ? LanguageService.trans("earn") : LanguageService.trans("use");
      typeText = "리뷰이미지 " + inOut!;
      point = (item.point! >= 0 ? (item.point == 0 ? "" : "+") : "-") + formatAmount(item.point!.abs()) + " " + LanguageService.trans("p");
      color_val = item.point! >= 0 ? AppColor_Primary : AppColor_Red;
    } else if (item.type == "payment") {
      icon = 'assets/ic_point2.png';
      inOut = item.point! >= 0 ? LanguageService.trans("earn") : LanguageService.trans("use");
      typeText = "결제금액 " + inOut!;
      point = (item.point! >= 0 ? (item.point == 0 ? "" : "+") : "-") + formatAmount(item.point!.abs()) + " " + LanguageService.trans("p");
      color_val = item.point! >= 0 ? AppColor_Primary : AppColor_Red;
    }

    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 30),
      //padding: const EdgeInsets.only(right: 20),
      height: 77,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon!,
                width: 25,
                height: 25,
                alignment: Alignment.center,
              ),

              const SizedBox(
                width: 13,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H14(
                    text: typeText!,
                    weight: FW.medium,
                    align: TextAlign.left,
                    color: AppColor_BlackText,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  H12(
                    text: getDateFormatString(DateTime.parse(item.createdAt!), "MM.dd(EEEE) HH:mm ") + inOut!,
                    weight: FW.medium,
                    align: TextAlign.left,
                    color: AppColor_Icon,
                  ),
                ],
              ),

              //const SizedBox(width: 13,),
              Expanded(
                //fit: FlexFit.tight,
                //flex: 5,
                child: H14(
                  text: point!,
                  weight: FW.medium,
                  align: TextAlign.end,
                  color: color_val,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Container(
            height: 1,
            color: AppColor_f4f5f7,
          )
        ],
      ),
    );
  }
}
