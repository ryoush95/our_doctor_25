import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

import 'review_first_fragment.dart';
import 'review_second_fragment.dart';

class ReviewFragment extends StatefulWidget {
  @override
  ReviewFragmentState createState() => ReviewFragmentState();
}

class ReviewFragmentState extends BaseState<ReviewFragment> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  // static const platform = const MethodChannel('doctor.flutter.dev');
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      changeTab(tabController.index);
    });

    tabController.index = 0;
  }

  void changeTab(int tab) {
    setState(() {
      tabIndex = tab;
      tabController.index = tabIndex;
    });
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
    return PageLayout(
        isLoading: isLoading,
        isAvoidResize: true,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SimpleHeader(
                  title: LanguageService.trans("my_review"),
                  onBackPressed: onBackPressed,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabHeaderItem(LanguageService.trans("review_that_can_be_written"), 0),
                      _buildTabHeaderItem(LanguageService.trans("review_written"), 1),
                    ],
                  ),
                ),
                Expanded(
                    child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      body: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [ReviewFirstFragment(), ReviewSecondFragment()],
                  )),
                )),
              ],
            ),
          ],
        ));
  }

  Widget _buildTabHeaderItem(String tabText, int step) {
    return InkWell(
      child: Stack(
        children: [
          SizedBox(
              width: (MediaQuery.of(context).size.width - 40) / 2,
              height: 35,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: H14(text: tabText, color: tabIndex == step ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2), weight: FW.medium, maxLine: 2),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 2,
                      color: tabIndex == step ? AppColor_BlackText : AppColor_Selector_Border,
                    ),
                  )
                ],
              )),
        ],
      ),
      onTap: () {
        changeTab(step);
      },
    );
  }
}
