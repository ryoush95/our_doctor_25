import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_floating_button.dart';
import 'package:ourdoctor/pages/components/h14.dart';

import 'faq_fragment.dart';
import 'info_fragment.dart';

class StoryFragment extends StatefulWidget {
  @override
  StoryFragmentState createState() => StoryFragmentState();
}

class StoryFragmentState extends BaseState<StoryFragment> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  static const platform = const MethodChannel('doctor.flutter.dev');
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      changeTab(tabController.index);
    });

    tabController.index = faqFromSide ? 1 : 0;
  }

  void changeTab(int tab) {
    setState(() {
      tabIndex = tab;
      tabController.index = tabIndex;
    });
  }

  Future<void> goChatting() async {
    try {
      final int result = await platform.invokeMethod('talk', {"uid": gUserInfo!.id, "name": gUserInfo!.name});
    } on PlatformException catch (e) {
      showToast("'${e.message}'.");
    }
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
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTabHeaderItem(LanguageService.trans("story_health_information"), 0),
                      _buildTabHeaderItem(LanguageService.trans("faq"), 1),
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
                    children: [InfoFragment(), FaqFragment()],
                  )),
                )),
              ],
            ),
            Visibility(
              visible: false,
              child: Positioned(
                child: AppFloatingButton(onPressed: goChatting),
                right: 12,
                bottom: 12,
              ),
            )
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
                    child: H14(text: tabText, color: tabIndex == step ? Colors.black : AppColor_Tab_Unselected, weight: FW.medium, maxLine: 2),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 3,
                      color: tabIndex == step ? Colors.black : AppColor_Tab_Unselected,
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
