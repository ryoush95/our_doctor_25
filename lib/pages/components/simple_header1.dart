import 'package:flutter/material.dart';
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
              child: Image.asset('assets/path_12225.png', width: 10,),
            ),
            onTap: onBackPressed,
          ),
         /* Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 62,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset('assets/path_12225.png', width: 10,),
                ),
                onTap: onBackPressed,
              )),*/
          GestureDetector(
            child: Center(
              child: H18(text: title, weight: FW.medium, maxLine: 2),

            ),
          ),

          basketButton(),
          /*    Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Image.asset(
                          'assets/ic_basket.png',
                          width: 24),

                    ),
                    onTap: basket,
                  ),
                   H10(
                    text: sprintf(
                        "%s 개", [(basketList.length.toString())]),
                  )
                ],
              ),*/


        ],

      ),
    );
  }

  Column basketButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,

          child: Container(
            height: 30,
            padding: const EdgeInsets.only(left: 10, right: 10),
              child: Image.asset( 'assets/ic_basket.png',),
          ),
          onTap: basket,
        ),
        H12(text: basketList,  weight: FW.regular,),


      ],
    );
  }
}
