import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/disease_report.dart';

class MonitoringResult2 extends StatefulWidget {
  const MonitoringResult2({Key? key}) : super(key: key);

  @override
  State<MonitoringResult2> createState() => _MonitoringResult2State();
}

class _MonitoringResult2State extends BaseState<MonitoringResult2> {
  int tabIndex = 0;
  List<String> category = ["질병", "수면", "영양", "맞춤검사"];
  List<ReportDto> reportList = [];
  List<ReportDto> reportList1 = [];
  List<ReportDto> reportList2 = [];

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  Widget _body() {
    if (tabIndex == 0) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: DiseaseReport(
              data: reportList,
              data1: reportList1,
              data2: reportList2,
              result: 1),
      );
    } else if (tabIndex == 1) {
      return Container();
    } else if (tabIndex == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H20(
            text: "우아냠냠 체크 리스트",
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                  width: 300,
                  height: 250,
                  padding: EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: AppColor_Light_Gray),
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(children: [
                            Image.asset(
                              "assets/ic_radio_on.png",
                              width: 20,
                            ),
                            Image.asset(
                              "assets/ic_radio_off.png",
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            H16(
                              text: "아이가 잘 먹고 있나요?",
                              weight: FW.regular,
                            )
                          ]),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  )),
              const SizedBox(height: 20),
              MainTextButton(
                text: "3개 미만",
                width: 200,
                height: 40,
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.semi_bold),
              ),
              const SizedBox(height: 10),
              MainTextButton(
                text: "3개 이상",
                width: 200,
                height: 40,
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.semi_bold),
              ),
              const SizedBox(height: 20),
            ],
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: gSelChildInfo!.name!,
              style: AppTextStyle.PD(AppColor_Primary, 20, weight: FW.bold),
            ),
            TextSpan(
              text: "의 영양식단을 추천해요!",
              style: AppTextStyle.PD(Colors.black, 20, weight: FW.bold),
            )
          ])),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            height: 1200,
            child: ListView.builder(
              itemCount: 4,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: 300,
                      height: 250,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: AppColor_Gray),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          H18(text: "아침 식사"),
                          Expanded(child: H18(text: "아침 식사")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else if (tabIndex == 3) {
      return Container();
    }
    return CircularProgressIndicator();
  }

  Widget categoryTile(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          tabIndex = index;
          print(tabIndex);
        });
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: tabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
          child: SizedBox(
            child: Stack(
              children: [
                Center(
                  child: H14(
                    text: category[index],
                    weight: FW.bold,
                    align: TextAlign.center,
                    maxLine: 1,
                    color: tabIndex == index
                        ? AppColor_White
                        : AppColor_BlackText.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: "모니터링 결과",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: screenSize.width,
                      height: 40,
                      margin: EdgeInsets.all(25),
                      child: GridView.builder(
                        // scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return categoryTile(index);
                        },
                        itemCount: category.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 2.5 / 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                      ),
                    ),
                    _body(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
