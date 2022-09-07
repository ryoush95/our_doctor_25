import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';

class CareBanner extends StatefulWidget {
  @override
  CareBannerState createState() => CareBannerState();
}

class CareBannerState extends BaseState<CareBanner> {
  int category = 0;
  //List<BannerList>? arrBannerList;
  @override
  void initState() {
    super.initState();
  }

  void changeTab(int tab) {}

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        height: 260,
        child: Stack(children: [
          Container(
              height: 110,
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: AppColor_Primary),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        category = 1 - category;
                      });
                    },
                    child: H18(
                      text: LanguageService.trans("growth_store"),
                      color: category == 0 ? Colors.white : AppColor_Banner_Hint,
                      weight: FW.semi_bold,
                    ),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      setState(() {
                        category = 1 - category;
                      });
                      print(category);
                    },
                    child: H18(
                      text: LanguageService.trans("development_class"),
                      color: category == 1 ? Colors.white : AppColor_Banner_Hint,
                      weight: FW.semi_bold,
                    ),
                  ),
                ],
              )),
          SizedBox(
            width: double.infinity,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // itemCount: arrBannerList == null ? 0 : arrBannerList!.length,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  //BannerList info = arrBannerList!.elementAt(index);
                  return InkWell(
                    child: Container(
                        width: 310,
                        height: 190,
                        padding: const EdgeInsets.all(22),
                        margin: const EdgeInsets.only(right: 10, top: 70),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0)), color: AppColor_Banner_Test),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H18(
                                  text: "하루 3번 포인트 혜택",
                                  color: Colors.white,
                                  weight: FW.bold,
                                  align: TextAlign.start,
                                ),
                                H18(
                                  text: "오늘의 적립!",
                                  color: Colors.white,
                                  weight: FW.bold,
                                  align: TextAlign.start,
                                  height: 1.6,
                                ),
                                H12(
                                  text: "title",
                                  color: Colors.white,
                                  weight: FW.regular,
                                  align: TextAlign.start,
                                  height: 1.6,
                                ),
                              ],
                            ),
                            Positioned(child: Container(width: 150, height: 110, decoration: BoxDecoration(color: AppColor_Selector_Border)), right: 5, bottom: 10),
                            Positioned(
                                child: H16(
                                  text: "1 / 6",
                                  color: Colors.white,
                                  weight: FW.semi_bold,
                                  align: TextAlign.start,
                                  height: 1.6,
                                ),
                                right: 0,
                                bottom: 0)
                          ],
                        )),
                    onTap: () {
                      //Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: info.uid)));
                    },
                  );
                }),
          )
        ]));
  }
}
