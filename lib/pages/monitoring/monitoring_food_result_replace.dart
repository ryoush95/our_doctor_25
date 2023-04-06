import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/accordion.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/radar_chart.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_habit.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test2.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonitoringFoodResultReplace extends StatefulWidget {
  final int months;
  final int dif;

  const MonitoringFoodResultReplace(
      {Key? key, required this.months, required this.dif})
      : super(key: key);

  @override
  State<MonitoringFoodResultReplace> createState() =>
      _MonitoringFoodResultReplaceState();
}

class _MonitoringFoodResultReplaceState
    extends State<MonitoringFoodResultReplace> {
  TextEditingController weightController = TextEditingController();
  TextEditingController calculateController = TextEditingController();
  String weight = "70";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  Widget monitor1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H20(
                  text: "일일 수유량 계산기",
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  Stack(
                    children: [
                      TextField(
                        maxLength: 4,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'(^\d*\.?\d*)')),
                        ],
                        keyboardType: TextInputType.number,
                        controller: weightController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                            isDense: true,
                            counterText: ""),
                        onChanged: (val) {
                          setState(() {
                            weight = val;
                            var intVal = int.parse(val);
                            String calVal = (intVal * 2).toString();
                            calculateController.text = calVal;
                          });
                        },
                      ),
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: H20(
                          text: "Kg",
                          align: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: H16(
                      text: "체중을 입력하세요",
                      weight: FW.medium,
                      color: AppColor_BlackText.withOpacity(0.6),
                      maxLine: 1,
                      height: 1.3,
                      align: TextAlign.left,
                    ),
                  ),
                ],
              )),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.red,
            size: 80.0,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        H18(
                          text: "우리아이의",
                          align: TextAlign.left,
                        ),
                        H18(
                          text: "하루 수유량은",
                          align: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      TextField(
                        controller: calculateController,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.blue),
                            ),
                            isDense: true,
                            counterText: ""),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: H20(
                          text: "cc",
                          align: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              )),

          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: CachedNetworkImage(
              imageUrl:
                  "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/file/monitoringReplace/%E1%84%89%E1%85%AE%E1%84%8B%E1%85%B2+%E1%84%8B%E1%85%B5%E1%86%AF%E1%84%85%E1%85%A5%E1%84%89%E1%85%B3%E1%84%90%E1%85%B3_1.jpg",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Accordion(
                  defaultOpen: true,
                    leadingImagePath: 'https://www.woolha.com/media/2020/03/eevee.png',
                    title: H18(
                      text: '모유 수유 중이라면?',
                      align: TextAlign.left,
                      color: Colors.blueAccent,),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H17(
                          text: "모유는 분유와 칼로리는 비슷하지만 직수를 하는 경우,\n수유량 계산이 어려울 수 있어요.\n이때, 체중 증가 정도로 수유량이 적절한지 알 수 있답니다.",
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.6),
                          maxLine: 15,
                          height: 1.3,
                          align: TextAlign.left,
                        ),
                        SizedBox(height: 30,),
                        H17(
                          text: "생후 ~ 6개월",
                          color: Colors.blueAccent,
                          height: 1.5,
                          align: TextAlign.left,
                        ),
                        H17(
                          text: "하루 20~30g 체중이 증가하면 적당해요.",
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.6),
                          height: 1.5,
                          align: TextAlign.left,
                        ),
                        H17(
                          text: "6개월 ~ 12개월",
                          color: Colors.blueAccent,
                          height: 1.5,
                          align: TextAlign.left,
                        ),
                        H17(
                          text: "하루 12~15g 체중이 증가하면 적당해요.",
                          weight: FW.medium,
                          color: AppColor_BlackText.withOpacity(0.6),
                          height: 1.5,
                          align: TextAlign.left,
                        ),
                      ],
                    ),
                ),
                Accordion(
                  defaultOpen: false,
                  leadingImagePath: 'https://www.woolha.com/media/2020/03/eevee.png',
                  title: H18(
                    text: '분유 수유 중이라면?',
                    align: TextAlign.left,
                    color: Colors.blueAccent,),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H17(
                        text: "분유를 수유 할 때 중요한 것은 분유의 농도예요.\n분유에 따라 조금씩 다르므로 분유마다 제공되는 권장 제조량으로 농도를 맞추어 주세요.\n분유의 농도가 권장량보다 진할 경우,분유에 함유된 인단백질같은 물질이 굳어서 단단해지는 분유석(bezoar)이 형성될 수 있어요.\n간혹 아이의 변이나 체중을 위해 임의로 농도를 조절하는 경우가 있는데 소아과 전문의의 처방이 있는 게 아니라면, 분유 농도는 임의로 조절하지 않도록 해주세요.",
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.6),
                        maxLine: 15,
                        height: 1.3,
                        align: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Accordion(
                  defaultOpen: false,
                  leadingImagePath: 'https://www.woolha.com/media/2020/03/eevee.png',
                  title: H18(
                    text: '분유 + 모유 수유 중이라면?',
                    align: TextAlign.left,
                    color: Colors.blueAccent,),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H17(
                        text: "모유 수유량이 적은 경우, 분유로 보충을 하거나 수면 교육을 위해 혼유를 하는 경우도 많아요.\n마지막 수유로 분유를 먹이실 경우, 모유와 칼로리는 같으나 소화에 더 오랜 시간이 걸리기때문에 공복감을 지연시킬 수 있어요. 영양이나 면역학적으로는 모유가 우수하겠으나 엄마 수면의 양과 질을 위해서라도 수면교육을 하는 동안의 아기에게 적용해보셔도 좋아요.\n수유하는 엄마의 건강과 상황에 따라 알맞게 조절하되, 체중이 백분위보다 크게 증가하지 않도록 모유와 분유량을 잘 조절해야 해요.",
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.6),
                        maxLine: 15,
                        height: 1.3,
                        align: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          // explain(),
        ],
      ),
    );
  }

  Widget monitor2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H20(
                  text: "우리 아이",
                  align: TextAlign.start,
                ),
                H20(
                  text: "이유식 시작해도 될까?",
                  align: TextAlign.start,
                  height: 1.3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CachedNetworkImage(
              imageUrl:
              "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/file/monitoringReplace/%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%B2%E1%84%89%E1%85%B5%E1%86%A8+%E1%84%8E%E1%85%A6%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%84%89%E1%85%B3%E1%84%90%E1%85%B3_1.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CachedNetworkImage(
              imageUrl:
              "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/file/monitoringReplace/%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%B2%E1%84%89%E1%85%B5%E1%86%A8+%E1%84%8E%E1%85%A6%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%84%89%E1%85%B3%E1%84%90%E1%85%B3_%E1%84%89%E1%85%A5%E1%86%AF%E1%84%86%E1%85%A7%E1%86%BC.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Accordion(
                  defaultOpen: true,
                  leadingImagePath: 'https://www.woolha.com/media/2020/03/eevee.png',
                  title: H18(
                    text: '밤중 수유는 NO!',
                    align: TextAlign.left,
                    color: Colors.blueAccent,),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H17(
                        text: "밤중 수유를 하게되면 밤에 깊은 잠을 자기 어렵기도 하고,수유,이유식 리듬이 지켜지기 어려울 수 있어요.\n자기 전, 마지막 수유 때 충분히 먹이고푹 잘 수 있는 환경을 만들어주어야 다음날 이유식도 잘 먹을 수 있어요!",
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.6),
                        maxLine: 15,
                        height: 1.3,
                        align: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Accordion(
                  defaultOpen: false,
                  leadingImagePath: 'https://www.woolha.com/media/2020/03/eevee.png',
                  title: H18(
                    text: '하루 일과는 일정하게!',
                    align: TextAlign.left,
                    color: Colors.blueAccent,),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H17(
                        text: "하루 일과가 일정해야 아이에게도 하루의 루틴이 생겨나요.\n매일 비슷한 시간에 식사를 하고, 식사 전후의 리듬에 아이가 익숙해진다면 규치적인 식습관 형성은 물론, 아이의 생활리듬도 유지된답니다.",
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.6),
                        maxLine: 15,
                        height: 1.3,
                        align: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Accordion(
                  defaultOpen: false,
                  leadingImagePath: 'https://www.woolha.com/media/2020/03/eevee.png',
                  title: H18(
                    text: '체중이 많이 나가지 않도록 주의!',
                    align: TextAlign.left,
                    color: Colors.blueAccent,),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H17(
                        text: "이유식 시작 전에 체중이 많이 나가는 경우,이유식을 제대로 먹이기 힘들거나, 이유식 이후 체중 증가 폭이 더 커질 수 있어요.\n이 시기에는 세포 수 자체가 증가하는 시기이므로, 비만이 될 확률이 높아질 수 있어요.",
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.6),
                        maxLine: 15,
                        height: 1.3,
                        align: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          // explain(),
        ],
      ),
    );
  }

  Widget monitor3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl:
                  "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/file/monitoringReplace/%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%B2%E1%84%80%E1%85%B5+%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A1(7~12%E1%84%80%E1%85%A2%E1%84%8B%E1%85%AF%E1%86%AF)+%E1%84%8B%E1%85%B3%E1%86%B7%E1%84%89%E1%85%B5%E1%86%A8_1.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl:
              "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/file/monitoringReplace/%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%B2%E1%84%80%E1%85%B5+%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A1(7~12%E1%84%80%E1%85%A2%E1%84%8B%E1%85%AF%E1%86%AF)+%E1%84%8B%E1%85%B3%E1%86%B7%E1%84%89%E1%85%B5%E1%86%A8_2.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CachedNetworkImage(
              imageUrl:
              "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/file/monitoringReplace/%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%B2%E1%84%80%E1%85%B5+%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A1(7~12%E1%84%80%E1%85%A2%E1%84%8B%E1%85%AF%E1%86%AF)+%E1%84%8B%E1%85%B3%E1%86%B7%E1%84%89%E1%85%B5%E1%86%A8%E1%84%91%E1%85%AD_1.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // explain(),
        ],
      ),
    );
  }

  Widget monitor31() {
    print(gUserInfo!.accessToken!);
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              H18(
                text: "미션을 수행하며\n건강한 식습관을 가져보세요!",
                maxLine: 2,
              ),
              Divider(),
              MainTextButton(
                text: "다시 점검하기",
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                width: 185,
                height: 40,
                radius: 6,
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                        builder: (context) => MonitoringFoodTest2(),
                      ));
                },
              ),
            ],
          ),
          MonitoringFoodHabit(),
        ],
      ),
    );
  }

  Widget _body() {
    if (widget.months <= 5) {
      return monitor1();
    } else if (widget.months == 6) {
      return monitor2();
    } else {
      return monitor3();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      onBack: onBackPressed,
      child: Column(
        children: [
          SimpleHeader(
            title: "영양모니터링",
            onBackPressed: onBackPressed,
          ),
          Expanded(
            child: _body(),
          ),
        ],
      ),
    );
  }
}
