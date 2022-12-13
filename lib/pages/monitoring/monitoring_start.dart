import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_checkbox.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/first_step.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_v2.dart';
import 'package:ourdoctor/pages/monitoring/second_step.dart';
import 'package:sprintf/sprintf.dart';

class MonitoringStartPage extends StatefulWidget {
  MonitoringStartPage({Key? key, this.uid = ""}) : super(key: key);
  String? uid;

  @override
  MonitoringStartPageState createState() => MonitoringStartPageState();
}

class MonitoringStartPageState extends BaseState<MonitoringStartPage> {
  var days = [
    LanguageService.trans('monday'),
    LanguageService.trans('tuesday'),
    LanguageService.trans('wednesday'),
    LanguageService.trans('thursday'),
    LanguageService.trans('friday'),
    LanguageService.trans('saturday'),
    LanguageService.trans('sunday'),
  ];
  var weekday = DateTime.now().weekday - 1;
  String month = DateTime.now().month.toString();
  String day = DateTime.now().day.toString();
  String noon = DateTime.now().hour > 12 ? LanguageService.trans("afternoon") : LanguageService.trans("morning");

  List<String> physicalDevelopment = <String>[
    LanguageService.trans("height"),
    LanguageService.trans("weight"),
    LanguageService.trans("sleep"),
    LanguageService.trans("nutrition"),
    LanguageService.trans("disease"),
  ];
  List<String> brainDevelopment = <String>[
    LanguageService.trans("language"),
    LanguageService.trans("work_out"),
    LanguageService.trans("sociability"),
  ];
  List<int> selPhysical = [];
  List<int> selBrain = [];
  bool isStart = true;
  HomeMonitorDto? dicHomeDataInfo;
  final HttpService httpService = HttpService();
  @override
  void initState() {
    super.initState();
    print("MonitoringStartPageState");
    getMonitor2HomeDataInfo();
  }

  Future<void> getStatus() async {
    // String status = await LocalService.getMonitoringStatus();
    if (dicHomeDataInfo!.totalScore == 0) {
      isStart = true;
      selPhysical = [0, 1, 2, 3, 4];
      if (!isMoreBirth1(85)) {
        //85개월이상이 아닌 경우
        selBrain = [0, 1, 2];
      }
    } else {
      isStart = false;
      int diff = checkSelDate(gUserInfo!.createdAt!);
      if (diff % 30 == 0) {
        selPhysical.add(0);

        if (!isMoreBirth1(85)) {
          //85개월이상이 아닌 경우
          selBrain.add(0);
          selBrain.add(1);
          selBrain.add(2);
        }
      }
      selPhysical.add(1);
      selPhysical.add(2);
      selPhysical.add(3);
      selPhysical.add(4);
    }
    setState(() {});
  }

  String getName() {
    String result = "";

    // if (selPhysical.contains(0)) {
    //   result = "신장, 체중, 수면, 영양, 질병";
    // } else {
    //   result = "체중, 수면, 영양, 질병";
    // }

    for (int i = 0; i < selPhysical.length; i++) {
      if (result == "") {
        result = physicalDevelopment[selPhysical[i]];
      } else {
        result = result + ", " + physicalDevelopment[selPhysical[i]];
      }
    }

    for (int i = 0; i < selBrain.length; i++) {
      if (result == "") {
        result = result + brainDevelopment[selBrain[i]];
      } else {
        result = result + ", " + brainDevelopment[selBrain[i]];
      }
    }

    if (selPhysical.isEmpty && selBrain.isEmpty) {
      return "";
    }

    List<String> arr = result.split(",");
    result = result + sprintf(" 총 %d개 항목의 업데이트가 필요합니다.", [arr.length]);
    return result;
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  Future<void> onStartRecording() async {
    if (selPhysical.isEmpty && selBrain.isEmpty) {
      showToast("1개 항목 이상 선택하여야 합니다.");
      return;
    }
    //Navigator.push(context, SlideRightTransRoute(builder: (context) => const MonitoringMainPage(page: 0)));
    if (selPhysical.isEmpty) {
      String _recv = await Navigator.push(context, SlideRightTransRoute(builder: (context) => SecondStepPage(selBrain: selBrain, hasDisease: 2, surgeryList: [], hasphotoList: [], uid: widget.uid)));
      if (_recv != null && _recv != "") {
        // uid = _recv;
        widget.uid = _recv;
      }
    } else {
      String _recv = await Navigator.push(context, SlideRightTransRoute(builder: (context) => FirstStepPage(selPhysical: selPhysical, selBrain: selBrain, uid: widget.uid)));
      if (_recv != null && _recv != "") {
        // uid = _recv;
        widget.uid = _recv;
      }
    }
  }

  void onSelect(int type, int index, bool selected) {
    if (isStart) {
      showToast("최초 1회 모니터링시 전체 항목에 대한 업데이트를 하셔야 합니다.");
      return;
    }
    switch (type) {
      case 0:
        if (selected) {
          selPhysical.add(index);
        } else {
          selPhysical.remove(index);
        }
        break;
      case 1:
        if (selected) {
          selBrain.add(index);
        } else {
          selBrain.remove(index);
        }
        break;
    }
    setState(() {});
  }

  // Network functions
  //////////////////////////////////
  //홈 발달 리포트 얻기
  Future<void> getMonitor2HomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeMonitorResModel> info = httpService.homeMonitorInfo();
    info.then((HomeMonitorResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeDataInfo = value.data!;
        getStatus();
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SimpleHeader(
                  title: LanguageService.trans('monitoring'),
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          H24B(
                            text: sprintf("%s%s %s%s %s", [month, LanguageService.trans("month"), day, LanguageService.trans("day"), days[weekday]]),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              H24B(
                                text: LanguageService.trans("daily_monitoring"),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(noon == LanguageService.trans("morning") ? "assets/ic_daily_monitoring.png" : "assets/ic_icon3.png", width: 25)
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              H18(
                                text: gSelChildInfo!.name!, //gSelChildInfo!.name!,
                                weight: FW.bold,
                                color: AppColor_Primary,
                              ),
                              const SizedBox(width: 5),
                              H18(
                                text: LanguageService.trans("we_support_healthy_growth_of_children"),
                                weight: FW.regular,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Container(
                            // height: 475,
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor_Light_Gray),
                            child: Column(
                              children: [
                                H18(
                                  text: isStart ? LanguageService.trans("monitoring_start_guide") : getName(),
                                  weight: FW.bold,
                                  height: 1.4,
                                  maxLine: 4,
                                  align: TextAlign.justify,
                                ),
                                const SizedBox(height: 20),
                                H16(
                                  text: LanguageService.trans("physical_development"),
                                  weight: FW.medium,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(color: AppColor_White, borderRadius: BorderRadius.circular(20)),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: physicalDevelopment.length,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 5, mainAxisSpacing: 5, crossAxisSpacing: 15),
                                      itemBuilder: (BuildContext context, int index) {
                                        return AppCheckbox(
                                          text: physicalDevelopment[index],
                                          checked: selPhysical.contains(index) ? true : false,
                                          padding: 0.0,
                                          withBorder: false,
                                          onChecked: (checked) => {
                                            onSelect(0, index, checked!),
                                          },
                                        );
                                      }),
                                ),
                                Visibility(
                                  visible: !isMoreBirth1(85), //85개월 이상인 경우  false
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 35),
                                      H16(
                                        text: LanguageService.trans("brain_development"),
                                        weight: FW.medium,
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        decoration: BoxDecoration(color: AppColor_White, borderRadius: BorderRadius.circular(20)),
                                        child: GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: brainDevelopment.length,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 5, mainAxisSpacing: 5, crossAxisSpacing: 15),
                                            itemBuilder: (BuildContext context, int index) {
                                              return AppCheckbox(
                                                text: brainDevelopment[index],
                                                checked: selBrain.contains(index) ? true : false,
                                                padding: 0.0,
                                                withBorder: false,
                                                onChecked: (checked) => {
                                                  onSelect(1, index, checked!),
                                                },
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                                // Image.asset("assets/ic_icon4.png", width: 270)
                              ],
                            ),
                          ),
                          Center(
                            child: MainTextButton(
                              text: LanguageService.trans("ㄴㄴㄴㄴ"),
                              backgroundColor: AppColor_Primary,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                              width: screenSize.width - 60,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MonitoringMain2(),));
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: MainTextButton(
                              text: LanguageService.trans("start_recording"),
                              backgroundColor: AppColor_Primary,
                              style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                              width: screenSize.width - 60,
                              onPressed: () {
                                onStartRecording();
                              },
                            ),
                          ),
                          const SizedBox(height: 50)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
