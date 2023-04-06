import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

class MonitoringFoodTest extends StatefulWidget {
  const MonitoringFoodTest({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodTest> createState() => _MonitoringFoodTestState();
}

class _MonitoringFoodTestState extends BaseState<MonitoringFoodTest> {
  final List<bool> checkList = List.generate(5, (_) => false);

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  Widget foodHabitTestTile1(index) {
    return InkWell(
      onTap: () {
        setState(() {
          checkList[index] = !checkList[index];
        });
      },
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color:
                    checkList[index] ? AppColor_Primary : AppColor_Light_Gray),
            child: Icon(
              Icons.check_rounded,
              color: checkList[index] ? AppColor_White : Colors.grey,
              size: 50,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: checkList[index]
                      ? AppColor_Primary
                      : AppColor_Light_Gray),
              child: Center(
                  child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                child: H16(
                  text: "asdasd",
                  color: checkList[index] ? AppColor_White : Colors.black,
                  maxLine: 2,
                  align: TextAlign.start,
                  weight: FW.medium,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        child: Column(
      children: [
        SimpleHeader(
          title: "영양모니터링",
          onBackPressed: onBackPressed,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: H18(
                          text: "문제 행동",
                          color: AppColor_Primary,
                          align: TextAlign.start,
                        ),
                      ),
                      H18(
                        text: "체크리스트",
                        align: TextAlign.start,
                      ),
                      const SizedBox(height: 35),
                      Container(
                        height: 500,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 10),
                              height: 100,
                              child: foodHabitTestTile1(index),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 55),
                      MainTextButton(
                        text: "완료하기",
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.medium),
                        width: double.infinity,
                        height: 60,
                        radius: 10,
                        onPressed: () {

                        },
                      ),
                      const SizedBox(height: 55),
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
