import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/inoculation_info3.dart';

class InoculationInfo2Page extends StatefulWidget {
  @override
  InoculationInfo2PageState createState() => InoculationInfo2PageState();
}

class InoculationInfo2PageState extends BaseState<InoculationInfo2Page> {
  var nTabIdx = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: "접종 정보 업데이트",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 32, left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            nTabIdx = 0;
                            setState(() {});
                          },
                          child: H20(
                            text: "예방접종",
                            color: nTabIdx == 0 ? AppColor_Primary : AppColor_BlackText.withOpacity(0.2),
                            weight: nTabIdx == 0 ? FW.bold : FW.medium,
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            nTabIdx = 1;
                            setState(() {});
                          },
                          child: H20(
                            text: "건강검진",
                            color: nTabIdx == 1 ? AppColor_Primary : AppColor_BlackText.withOpacity(0.2),
                            weight: nTabIdx == 1 ? FW.bold : FW.medium,
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            nTabIdx = 2;
                            setState(() {});
                          },
                          child: H20(
                            text: "구강검진",
                            color: nTabIdx == 2 ? AppColor_Primary : AppColor_BlackText.withOpacity(0.2),
                            weight: nTabIdx == 2 ? FW.bold : FW.medium,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            Visibility(
                              visible: nTabIdx == 0,
                              child: Tab1Page(),
                            ),
                            Visibility(
                              visible: nTabIdx == 1,
                              child: Tab2Page(),
                            ),
                            Visibility(
                              visible: nTabIdx == 2,
                              child: Tab3Page(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget Tab1Page() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                H18(text: "이번 차수 예방접종"),
                Expanded(child: Container()),
                MainTextButton(
                  text: "업데이트",
                  backgroundColor: const Color(0xFFF4F9FF),
                  style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                  width: 76,
                  height: 32,
                  onPressed: () {
                    //
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 61,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor_Table_Border,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          3.0, // Move to bottom 5 Vertically
                        ))
                  ],
                  color: Colors.white),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  H18(
                    text: "현재",
                    weight: FW.semi_bold,
                    color: AppColor_BlackText.withOpacity(0.8),
                  ),
                  const SizedBox(width: 10),
                  H18(
                    text: "0/2",
                    weight: FW.semi_bold,
                    color: AppColor_Primary,
                  ),
                  Expanded(child: Container()),
                  Image.asset('assets/ic_blue_alarm.png', width: 37, height: 37),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _getTab1Tile,
              itemCount: 2,
            ),
            const SizedBox(height: 60),
            Row(
              children: [
                H18(text: "전체 예방접종"),
                Expanded(child: Container()),
                MainTextButton(
                  text: "업데이트",
                  backgroundColor: const Color(0xFFF4F9FF),
                  style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                  width: 76,
                  height: 32,
                  onPressed: () {
                    //
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 61,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor_Table_Border,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          3.0, // Move to bottom 5 Vertically
                        ))
                  ],
                  color: Colors.white),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  H18(
                    text: "22/38",
                    weight: FW.semi_bold,
                    color: AppColor_BlackText.withOpacity(0.8),
                  ),
                  const SizedBox(width: 10),
                  H18(
                    text: "58% 완료",
                    weight: FW.semi_bold,
                    color: AppColor_Primary,
                  ),
                  Expanded(child: Container()),
                  Image.asset('assets/ic_blue_alarm.png', width: 37, height: 37),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            const SizedBox(height: 37),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _getTab1_1Tile,
              itemCount: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTab1Tile(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          Navigator.push(context, SlideRightTransRoute(builder: (context) => InoculationInfo3Page(type: 0)));
        },
        child: Column(
          children: [
            Container(
                width: screenSize.width,
                height: 81,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor_Light_Gray,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/ic_monitor_off.png", width: 20, height: 20),
                            const SizedBox(width: 6),
                            H16(
                              text: "영유아 구강검진",
                              weight: FW.bold,
                              color: AppColor_BlackText,
                            ),
                            const SizedBox(width: 10),
                            H16(
                              text: "1차",
                              weight: FW.bold,
                              color: AppColor_BlackText.withOpacity(0.4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            H14(
                              text: "2021.03.19 - 2022.03.13",
                              weight: FW.semi_bold,
                              color: AppColor_BlackText.withOpacity(0.6),
                            ),
                            const SizedBox(width: 10),
                            H14(
                              text: "유료",
                              weight: FW.semi_bold,
                              color: AppColor_BlackText.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset("assets/Down-Small.png", width: 13)
                  ],
                )),
            const SizedBox(height: 8),
          ],
        ));
  }

  Widget _getTab1_1Tile(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H14(
          text: "2019년 9월 (0개월)",
          weight: FW.semi_bold,
          color: AppColor_BlackText,
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: _getTab1_2Tile,
          itemCount: 2,
        ),
        const SizedBox(height: 37),
      ],
    );
  }

  Widget _getTab1_2Tile(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          Navigator.push(context, SlideRightTransRoute(builder: (context) => InoculationInfo3Page(type: 0)));
        },
        child: Column(
          children: [
            Container(
                width: screenSize.width,
                height: 81,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor_Light_Gray,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/ic_vac_black.png", width: 20, height: 20),
                            const SizedBox(width: 6),
                            H16(
                              text: "영유아 구강검진",
                              weight: FW.bold,
                              color: AppColor_BlackText,
                            ),
                            const SizedBox(width: 10),
                            H16(
                              text: "1차",
                              weight: FW.bold,
                              color: AppColor_BlackText.withOpacity(0.4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            H14(
                              text: "2021.03.19 - 2022.03.13",
                              weight: FW.semi_bold,
                              color: AppColor_BlackText.withOpacity(0.6),
                            ),
                            const SizedBox(width: 10),
                            H14(
                              text: "유료",
                              weight: FW.semi_bold,
                              color: AppColor_BlackText.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset("assets/Down-Small.png", width: 13)
                  ],
                )),
            const SizedBox(height: 8),
          ],
        ));
  }

  Widget Tab2Page() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                H18(text: "영유아 구강검진"),
                Expanded(child: Container()),
                MainTextButton(
                  text: "업데이트",
                  backgroundColor: const Color(0xFFF4F9FF),
                  style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                  width: 76,
                  height: 32,
                  onPressed: () {
                    //
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 61,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor_Table_Border,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          3.0, // Move to bottom 5 Vertically
                        ))
                  ],
                  color: Colors.white),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  H18(
                    text: "5차 건강검진",
                    weight: FW.semi_bold,
                    color: AppColor_BlackText.withOpacity(0.8),
                  ),
                  const SizedBox(width: 10),
                  H18(
                    text: "미검진",
                    weight: FW.semi_bold,
                    color: AppColor_Primary,
                  ),
                  Expanded(child: Container()),
                  Image.asset('assets/ic_blue_alarm.png', width: 37, height: 37),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _getTab2Tile,
              itemCount: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTab2Tile(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          Navigator.push(context, SlideRightTransRoute(builder: (context) => InoculationInfo3Page(type: 1)));
        },
        child: Column(
          children: [
            Container(
                width: screenSize.width,
                height: 81,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: index % 2 == 0 ? AppColor_Light_Gray : const Color(0xFFF4F9FF),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(index % 2 == 0 ? "assets/ic_monitor_off.png" : "assets/ic_take1.png", width: 20, height: 20),
                            const SizedBox(width: 6),
                            H16(
                              text: "영유아 구강검진",
                              weight: FW.bold,
                              color: index % 2 == 0 ? AppColor_BlackText : AppColor_Primary,
                            ),
                            const SizedBox(width: 10),
                            H16(
                              text: "1차",
                              weight: FW.bold,
                              color: AppColor_BlackText.withOpacity(0.4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        H14(
                          text: "2021.03.19 - 2022.03.13",
                          weight: FW.semi_bold,
                          color: AppColor_BlackText.withOpacity(0.6),
                        ),
                      ],
                    ),
                    Image.asset("assets/Down-Small.png", width: 13)
                  ],
                )),
            const SizedBox(height: 8),
          ],
        ));
  }

  Widget Tab3Page() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                H18(text: "영유아 구강검진"),
                Expanded(child: Container()),
                MainTextButton(
                  text: "업데이트",
                  backgroundColor: const Color(0xFFF4F9FF),
                  style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                  width: 76,
                  height: 32,
                  onPressed: () {
                    //
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 61,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor_Table_Border,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          3.0, // Move to right 10  horizontally
                          3.0, // Move to bottom 5 Vertically
                        ))
                  ],
                  color: Colors.white),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  H18(
                    text: "검진 예정",
                    weight: FW.semi_bold,
                    color: AppColor_BlackText.withOpacity(0.8),
                  ),
                  const SizedBox(width: 10),
                  H18(
                    text: "9개월 뒤",
                    weight: FW.semi_bold,
                    color: AppColor_Primary,
                  ),
                  Expanded(child: Container()),
                  Image.asset('assets/ic_blue_alarm.png', width: 37, height: 37),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _getTab3Tile,
              itemCount: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTab3Tile(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
        onTap: () {
          //
        },
        child: Column(
          children: [
            Container(
                width: screenSize.width,
                height: 81,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor_Light_Gray,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/ic_monitor_off.png", width: 20, height: 20),
                            const SizedBox(width: 6),
                            H16(
                              text: "영유아 구강검진",
                              weight: FW.bold,
                              color: AppColor_BlackText,
                            ),
                            const SizedBox(width: 10),
                            H16(
                              text: "1차",
                              weight: FW.bold,
                              color: AppColor_BlackText.withOpacity(0.4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        H14(
                          text: "2021.03.19 - 2022.03.13",
                          weight: FW.semi_bold,
                          color: AppColor_BlackText.withOpacity(0.6),
                        ),
                      ],
                    ),
                    Image.asset("assets/Down-Small.png", width: 13)
                  ],
                )),
            const SizedBox(height: 8),
          ],
        ));
  }
}
