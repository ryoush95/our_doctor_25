import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';

class SolutionArea extends StatefulWidget {
  const SolutionArea({Key? key}) : super(key: key);

  @override
  State<SolutionArea> createState() => _SolutionAreaState();
}

class _SolutionAreaState extends State<SolutionArea> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 450,
      // margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: AppColor_White,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: AppColor_Light_Gray,
              blurRadius: 3.0, // soften the shadow
              spreadRadius: 4.0, //extend the shadow
            )
          ]),
      child: Column(
        children: [
          const SizedBox(height: 20),
          H16(text: "솔루션 추천"),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                double s = 130;
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: s,
                        width: s,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                        child: Image.asset("assets/icon_good.png",width: 84, height: 84, fit: BoxFit.fill,),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: s,
                        child: H18(
                          text: "asdasdaskuygygygd",
                          weight: FW.regular,
                          maxLine: 2,
                          align: TextAlign.center,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },),
          ),
        ],
      ),
    );
  }
}