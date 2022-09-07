import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/monitoring/second_step.dart';

import 'first_step.dart';

class MonitorWriteDto {
  String uid;
  String regDate;
  String regTime;
  String temperature;
  String oxygen;
  String heartCnt;
  String symptom;
  String pillUrl;
  String speciality;
  String? stepTimes;

  MonitorWriteDto({
    required this.uid,
    required this.regDate,
    required this.regTime,
    required this.temperature,
    required this.oxygen,
    required this.heartCnt,
    required this.symptom,
    required this.pillUrl,
    required this.speciality,
    required this.stepTimes,
  });
}

class MonitoringMainPage extends StatefulWidget {
  const MonitoringMainPage({Key? key, required this.page}) : super(key: key);
  final int page;

  @override
  MonitoringMainPageState createState() => MonitoringMainPageState();
}

class MonitoringMainPageState extends BaseState<MonitoringMainPage> with TickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  final HttpService httpService = HttpService();
  @override
  void initState() {
    super.initState();
    tabIndex = widget.page;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      changeTab(tabController.index);
    });
    if (tabIndex > 0) {
      changeTab(tabIndex);
    }
  }

  Future<bool> onBackPressed() async {
    // showModalBottomSheet(
    //     backgroundColor: Colors.transparent,
    //     context: context,
    //     builder: (context) {
    //       return const BackConfirmDialog();
    //     });
    if (tabIndex == 0) {
      Navigator.of(context).pop();
    } else {
      changeTab(0);
    }
    return true;
  }

  void onSaveRecord() {
    //
  }

  void changeTab(int tab) {
    setState(() {
      tabIndex = tab;
      tabController.index = tabIndex;
    });
  }

  void onToRecord() {
    FocusScope.of(context).requestFocus(FocusNode());
    changeTab(tabIndex + 1);
  }

  // Network functions
  //////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SimpleHeader(
                title: LanguageService.trans('diagnosis_of_the_day'),
                onBackPressed: onBackPressed,
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      body: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      FirstStepPage(selPhysical: [], selBrain: []),
                      SecondStepPage(selBrain: [], hasDisease: 2, surgeryList: [], hasphotoList: []),
                    ],
                  )),
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H18(
                    text: (tabIndex + 1).toString(),
                    weight: FW.bold,
                  ),
                  H18(
                    text: ' / 2',
                    weight: FW.regular,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              MainTextButton(
                text: LanguageService.trans("next"),
                backgroundColor: AppColor_Primary,
                style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                radius: 0,
                height: 66,
                onPressed: () {
                  onToRecord();
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildTabHeaderItem(String tabText, int step) {
    return InkWell(
      child: Stack(
        children: [
          SizedBox(
              width: (MediaQuery.of(context).size.width - 20) / 5,
              height: 35,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: H14(text: tabText, color: tabIndex == step ? Colors.black : AppColor_Tab_Unselected, weight: FW.regular, maxLine: 2),
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
        // changeTab(step);  //상단 탭 눌렀을때
      },
    );
  }
}
