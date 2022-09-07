import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

class InoculationInfo3Page extends StatefulWidget {
  InoculationInfo3Page({Key? key, this.type = 0}) : super(key: key);
  int? type;

  @override
  InoculationInfo3PageState createState() => InoculationInfo3PageState();
}

class InoculationInfo3PageState extends BaseState<InoculationInfo3Page> {
  String title = "";
  @override
  void initState() {
    super.initState();

    if (widget.type == 0) {
      title = "예방접종 정보";
    } else if (widget.type == 1) {
      title = "건강검진 정보";
    }
    setState(() {});
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
              title: title,
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 32, left: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      H18(
                        text: "영유아 구강검진",
                        color: AppColor_BlackText,
                      ),
                      const SizedBox(height: 5),
                      H18(
                        text: "4차",
                        color: AppColor_BlackText.withOpacity(0.4),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        color: const Color(0xFFF4F5F7),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: H14(
                              text: "시기",
                              weight: FW.semi_bold,
                              align: TextAlign.start,
                              color: AppColor_BlackText,
                            ),
                          ),
                          H14(
                            text: "생후 18 - 25개월",
                            weight: FW.regular,
                            align: TextAlign.start,
                            maxLine: 10,
                            color: AppColor_BlackText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: H14(
                              text: "검진일자",
                              weight: FW.semi_bold,
                              align: TextAlign.start,
                              color: AppColor_BlackText,
                            ),
                          ),
                          H14(
                            text: "2021.06.04",
                            weight: FW.regular,
                            align: TextAlign.start,
                            maxLine: 10,
                            color: AppColor_BlackText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: H14(
                              text: "검진기관",
                              weight: FW.semi_bold,
                              align: TextAlign.start,
                              color: AppColor_BlackText,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 64 - 64,
                            child: H14(
                              text: "의료법인 우리아이들 의료재단 우리아이들병원",
                              weight: FW.regular,
                              align: TextAlign.start,
                              maxLine: 10,
                              height: 1.1,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: H14(
                              text: "메모",
                              weight: FW.semi_bold,
                              align: TextAlign.start,
                              color: AppColor_BlackText,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 64 - 64,
                            child: H14(
                              text: "성장 발달 현재 양호. 지난 검진 2020.10에 비해 키 약 5cm 성장함",
                              weight: FW.regular,
                              align: TextAlign.start,
                              height: 1.1,
                              maxLine: 10,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: H14(
                              text: "검진결과",
                              weight: FW.semi_bold,
                              align: TextAlign.start,
                              color: AppColor_BlackText,
                            ),
                          ),
                          MainTextButton(
                            text: "열기",
                            backgroundColor: const Color(0xFFF4F9FF),
                            style: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.bold),
                            width: 56,
                            height: 32,
                            onPressed: () {
                              //
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
