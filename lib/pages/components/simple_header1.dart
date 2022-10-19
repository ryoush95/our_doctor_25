import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/models/basket_list_res_model.dart';
import 'package:ourdoctor/pages/components/h10.dart';
import 'package:ourdoctor/pages/my/shopping_basket.dart';
import 'package:sprintf/sprintf.dart';

import 'h12.dart';
import 'h18.dart';

class SimpleHeader1 extends StatelessWidget {
  final title;
  final onBackPressed;
  final basket;
  final basketList;



  SimpleHeader1({Key? key, this.title, this.onBackPressed, this.basket, required this.basketList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                'assets/path_12225.png',
                width: 10,
              ),
            ),
            onTap: onBackPressed,
          ),
          GestureDetector(
            child: Center(
              child: H18(text: title, weight: FW.medium, maxLine: 2),
            ),
          ),
          GestureDetector(
            child: basketButton(),
            onTap: basket,
          ),
        ],
      ),
    );
  }

  Column basketButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 38,
                padding: const EdgeInsets.only(
                    left: 10, top: 6, right: 20, bottom: 8),
                child: Image.asset(
                  'assets/ic_basket.png',
                  color: AppColor_121215,
                ),
              ),
            ),
            Positioned(
              bottom: 22,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor_c8ffff,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: H10(
                  text: basketList,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
