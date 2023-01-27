import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_dash_line.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/home_fragment.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:screenshot/screenshot.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'dart:ui' as ui;
import '../tab_main.dart';

class CustomMbtiInspectionResultPage extends StatefulWidget {
  final mbti;

  const CustomMbtiInspectionResultPage({Key? key, required this.mbti})
      : super(key: key);

  @override
  CustomMbtiInspectionResultPageState createState() =>
      CustomMbtiInspectionResultPageState();
}

class CustomMbtiInspectionResultPageState extends BaseState<CustomMbtiInspectionResultPage> with TickerProviderStateMixin {

  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey _key = GlobalKey();
  String mainImage = "";
  String mainText = "";
  String friend1 = "";
  String friend1Text = "";
  String friend2 = "";
  String friend2Text = "";

  @override
  void initState() {
    super.initState();
    selectImage(widget.mbti);
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }
  void selectImage(String mbti) {
    // 1
    if (mbti == "intj") {
      mainImage = "assets/mbti_intj.png";
      mainText = "assets/intj.png";
      friend1 = "assets/mbti_enfp.png";
      friend1Text = "assets/enfp.png";
      friend2 = "assets/mbti_entp.png";
      friend2Text = "assets/entp.png";
    }
    // 2
    else if(mbti == "intp") {
      mainImage = "assets/mbti_intp.png";
      mainText = "assets/intp.png";
      friend1 = "assets/mbti_entj.png";
      friend1Text = "assets/entj.png";
      friend2 = "assets/mbti_estj.png";
      friend2Text = "assets/estj.png";
    }
    // 3
    else if(mbti == "entj") {
      mainImage = "assets/mbti_entj.png";
      mainText = "assets/entj.png";
      friend1 = "assets/mbti_infp.png";
      friend1Text = "assets/infp.png";
      friend2 = "assets/mbti_intp.png";
      friend2Text = "assets/intp.png";
    }
    // 4
    else if(mbti == "entp") {
      mainImage = "assets/mbti_entp.png";
      mainText = "assets/entp.png";
      friend1 = "assets/mbti_infj.png";
      friend1Text = "assets/infj.png";
      friend2 = "assets/mbti_intj.png";
      friend2Text = "assets/intj.png";
    }
    // 5
    else if(mbti == "infj") {
      mainImage = "assets/mbti_infj.png";
      mainText = "assets/infj.png";
      friend1 = "assets/mbti_enfp.png";
      friend1Text = "assets/enfp.png";
      friend2 = "assets/mbti_intp.png";
      friend2Text = "assets/intp.png";
    }
    // 6
    else if(mbti == "infp") {
      mainImage = "assets/mbti_infp.png";
      mainText = "assets/infp.png";
      friend1 = "assets/mbti_enfj.png";
      friend1Text = "assets/enfj.png";
      friend2 = "assets/mbti_entj.png";
      friend2Text = "assets/entj.png";
    }
    // 7
    else if(mbti == "enfj") {
      mainImage = "assets/mbti_enfj.png";
      mainText = "assets/enfj.png";
      friend1 = "assets/mbti_infp.png";
      friend1Text = "assets/infp.png";
      friend2 = "assets/mbti_intp.png";
      friend2Text = "assets/intp.png";
    }
    // 8
    else if(mbti == "enfp") {
      mainImage = "assets/mbti_enfp.png";
      mainText = "assets/enfp.png";
      friend1 = "assets/mbti_intj.png";
      friend1Text = "assets/intj.png";
      friend2 = "assets/mbti_infj.png";
      friend2Text = "assets/infj.png";
    }
    // 9
    else if(mbti == "istj") {
      mainImage = "assets/mbti_istj.png";
      mainText = "assets/istj.png";
      friend1 = "assets/mbti_esfp.png";
      friend1Text = "assets/esfp.png";
      friend2 = "assets/mbti_estp.png";
      friend2Text = "assets/estp.png";
    }
    // 10
    else if(mbti == "isfj") {
      mainImage = "assets/mbti_isfj.png";
      mainText = "assets/isfj.png";
      friend1 = "assets/mbti_estp.png";
      friend1Text = "assets/estp.png";
      friend2 = "assets/mbti_esfp.png";
      friend2Text = "assets/esfp.png";
    }
    // 11
    else if(mbti == "estj") {
      mainImage = "assets/mbti_estj.png";
      mainText = "assets/estj.png";
      friend1 = "assets/mbti_intp.png";
      friend1Text = "assets/intp.png";
      friend2 = "assets/mbti_infp.png";
      friend2Text = "assets/infp.png";
    }
    // 12
    else if(mbti == "esfj") {
      mainImage = "assets/mbti_esfj.png";
      mainText = "assets/esfj.png";
      friend1 = "assets/mbti_isfj.png";
      friend1Text = "assets/isfj.png";
      friend2 = "assets/mbti_istp.png";
      friend2Text = "assets/istp.png";
    }
    // 13
    else if(mbti == "istp") {
      mainImage = "assets/mbti_istp.png";
      mainText = "assets/istp.png";
      friend1 = "assets/mbti_esfj.png";
      friend1Text = "assets/esfj.png";
      friend2 = "assets/mbti_estj.png";
      friend2Text = "assets/estj.png";
    }
    // 14
    else if(mbti == "isfp") {
      mainImage = "assets/mbti_isfp.png";
      mainText = "assets/isfp.png";
      friend1 = "assets/mbti_enfj.png";
      friend1Text = "assets/enfj.png";
      friend2 = "assets/mbti_esfj.png";
      friend2Text = "assets/esfj.png";
    }
    // 15
    else if(mbti == "estp") {
      mainImage = "assets/mbti_estp.png";
      mainText = "assets/estp.png";
      friend1 = "assets/mbti_isfj.png";
      friend1Text = "assets/isfj.png";
      friend2 = "assets/mbti_istj.png";
      friend2Text = "assets/istj.png";
    }
    // 16
    else if(mbti == "esfp") {
      mainImage = "assets/mbti_esfp.png";
      mainText = "assets/esfp.png";
      friend1 = "assets/mbti_istj.png";
      friend1Text = "assets/istj.png";
      friend2 = "assets/mbti_isfj.png";
      friend2Text = "assets/isfj.png";
    }
  }

  Future<bool> takeScreenshot() async {
    RenderRepaintBoundary boundary =
    _key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Saving the screenshot to the gallery
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 90,
          name: 'screenshot-${DateTime.now()}.png');

      if (kDebugMode) {
        print(result);
      }
      setState(() {
        showToast("화면이 캡쳐되었습니다.");
      });
    }
    return true;
  }

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
                title: LanguageService.trans('우리 아이 성격테스트'),
                onBackPressed: onBackPressed,
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        childRecommendation(),
                        Container(
                          height: 862,
                          width: double.infinity,
                          color: AppColor_Banner_Count,
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              jobRecommendationBox(),
                              const SizedBox(height: 60),
                              bestFriendsBox(),
                              const SizedBox(height: 40),
                              backgroundImageButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        )
    );
  }

  Widget topText() {
    return Container(
      child: Column(
        children: [
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .width - 70),
            height: 140,
            child: Column(
              children: [
                Row(
                  children: [
                    H20(
                      text: "우리 아이 성격에 딱 맞는 유명인은 \n누가 있을까?",
                      maxLine: 2,
                      align: TextAlign.left,
                      weight: FW.semi_bold,
                      height: 1.4,
                    ),
                  ],
                ), const SizedBox(height: 20,),
                Container(
                  height: 50,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 120),
                  decoration: const BoxDecoration(
                    color: AppColor_Primary,
                    borderRadius:
                    BorderRadius.all(Radius.circular(100)),
                  ),
                  child: const Center(
                    child: H22(
                      text: "우리 아이의 성격테스트!",
                      align: TextAlign.center,
                      color: Colors.white,
                      weight: FW.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget childRecommendation() {
    return RepaintBoundary(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 630,
            width: double.infinity,
            color: AppColor_Banner_Count,
            child: Column(
              children: [
                const SizedBox(height: 50),
                topText(),
                const SizedBox(height: 20),
                myMbtiTopBox(),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 470,
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.1), BlendMode.dstATop),
                        image: AssetImage("assets/back_mark.png"),

                      ),
                    )
                 ),
                Positioned(
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.mbti == "intj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "이 어린이는 친구를 많이 사귀기 보다는 몇명의 깊은 친구를 사귀는 편이에요. 다른 친구들에 비해 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "상상의 범위가 매우 구체적이고 풍성해 창의력도 좋은 편",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "입니다. 반복적인 작업을 요구하는 일은 좋아하지 않아요. 평소 질문이 아주 많은 편이고, 경험해 본 방법보다 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "좀 더 나은 방법을 생각해내는 능력",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "도 좋습니다. 결단력 있고 단호한 편이지만, 편한 친구들과 함께 할때면 유쾌하고, 관계에 누구보다 집중하는 모습을 보여줄 거에요.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "intp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "이 어린이는 대부분 진지하고 무뚝뚝한 편입니다. 계획대로 행동하기보다는 즉흥적으로 행동하는 것을 좋아해요. 머릿 속에 떠오르는 아이디어가 많아 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "갈팡질팡 변덕스러워 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "보이기도 합니다. 그 아이디어는 대게 현실적인 것보다는 미래지향적인 이론과 추상적 생각으로 이루어져있어요. 다소 게으르고 공감 능력도 부족하지만, ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "늘 흥미롭고 예상치 못한 이야기들",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(text: "이야기들을 해주는 재밌는 친구가 될거에요.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "entj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "이 어린이는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "천부적으로 타고난 리더",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "리더로, 반장, 부반장은 따 놓은 당상입니다! ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "새로운 것에 대한 호기심과 열정이 가득한 편",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "으로, 큰 목표가 생기면 달려가느라 작은 것들은 놓치기도 합니다. 어려운 목표를 만나도 계획한 것을 달성하고자 하는 의지가 자극이 되어 해결해내고야 마는 멋진 어린이에요. 다만 이런 의지가 성급한 결정을 만들기도 하니, 양육자의 꼼꼼하고 세세한 조력이 도움이 될 거에요.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "entp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "이 어린이는 표현이 적극적이며, 활동적이면서도 독립적인 성향을 가지고 있습니다. 논리적인 사고에 기반한 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "협상, 토론 등에도 강합니다. 가치관이 뚜렷해 본인의 입장으로 결론이 나길 바라는 자신만만한 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "어린이에요. 충동적인 성향으로 재미있다면 하던 일도 마다하고 뛰어듭니다. 지칠 줄 모르는 에너지의 소유자로 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "두뇌 회전도 빠르고, 갈등해결이나 복잡한 문제 해결 능력이 뛰어",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(text: "납니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "infj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "이 어린이는",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: " 새로운 일이나 만남을 좋아하지 않습니다",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: ". 친하고 마음 맞는 친구와 둘이 오붓하게 지내는 것을 훨씬 편해 합니다. 타인과의 갈등보다는 내면에서 발생하는 갈등이 훨씬 많고 복잡할 거에요. ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "자신의 의견을 쉽게 전달하는 능력은 부족할지 모르나, 시간을 들이는 글과 같은 비언어 전달에는 강할 수 있으니",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: " 시간을 주는 것도 좋은 방법입니다. 순수학문, 수학, 과학 연구 등의 분야를 지원해 주는 것은 어떨까요? 우리 아이는 성실하고 계획적이면서도 독창적인 아이디어가 번뜩일테니까요!",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "infp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "이 어린이는",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: " 최악의 상황이나 나쁜 사람한테서마저 좋은 면이나 긍정적인 면을 발견할 줄 아는 따뜻한 아이",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "입니다. 개인적인 성취나 보상 불이익에 집중하지 않고 살아갈 확률이 높아요. 아주 사려 깊고 집중력이 뛰어난 편이니 집중에 도움이 될만한 환경을 만들어주세요. 규칙이나 규율이 엄격하지 않고, ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "창조적이고 따뜻한 일을 만들어낼 수 있는 환경이면 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(text: "좋겠습니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "enfj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "이 어린이는",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: " 성실하고 책임감이 있는 편입니다",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: ". 낙천적인데다가 공감 능력까지 좋아 어떤 상황에서나 친구들에게 최고의 리액션을 보여줍니다. ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "사람들과의 관계를 소중하게 생각하기 때문",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "에 거절이 어렵고, 갈등이나 어려움은 덮고 회피하는 경향이 있습니다. 다른 친구들보다 비판 받는 것에 대한 스트레스가 높고 비판하는 것도 어려워합니다. 하여 이 어린이에게는 경쟁이나 갈등 상황이 적으면서도 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "타인을 위한 의미 있는 활동을 하는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(text: "직업을 추천합니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "enfp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "다채로운 매력의 이 어린이는 사람과의 만남을 즐기며, 반복적인 일상을 지루해 합니다. 관심 없는 곳에는 인내력이 부족하지만 관심이 있는 곳이라면 달라요. ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "분위기 메이커에, 감성적이면서도 열정적인 톡톡 튀는 재주",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "가 있거든요. 다만, 주변 사람들에게 인정 받고자 하는 욕망이 강해서 타인의 눈치도 많이 보는 편입니다. 혼자 있으면 몰두하다가도 금방 관두지만, 여럿이 있는 곳에서 소통하며 공부하면 다를거에요. 자유로울 수 있는 환경을 제공해주세요! ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "istj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "조용하고 안정성을 추구하는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "이 어린이는 모험도 썩 즐기지는 않습니다. 동시에 도전적이고 변화무쌍한 친구를 사귀는 것도 불편해요. 여느 또래 친구들보다 창의성이 부족하지만, 반복되는 일에는 오히려 강한 모습을 보여줍니다. ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "집중력도 강하고, 돌발 상황이 발생해도 크게 동요하지 않고 침착하게 극복",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "합니다. 스트레스나 화는 속에 쌓아 두다가 한번에 터뜨리기도 하니, 양육자의 세심한 관찰이 필요해요.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "isfj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "이 어린이는 한 편으론 내향적이고 신중하지만, 외향적이라고 착각이 들만큼 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "적응력이 뛰어납니다",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: ". 갈등이나 경쟁하는 것을 싫어해 그냥 꾹 참아 버리기도 하는 어른스러운 아이이기도 합니다. 다른 아이들보다 인정 욕구가 강하지 않아 겸손해 보이기도 하고, ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "새로운 것보다는 정해진 규칙이나 규율을 잘 지키는 것을 중요하게",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: " 생각해요. 뛰어난 적응력에 더해 따뜻한 사교성까지 겸비한 이 어린이는 친구들에게도 인기 만점일거에요!",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "estj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "이 어린이는 매사에 의지가 활활 타오르고, 원하는 것이 있으면 꼭 해내고야 마는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "열정적인 어린이",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "입니다. 정해진 규칙을 따르는 것을 좋아해, 급하게 바뀐 놀이규칙에 불편해 할수도 있어요. 다소 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "독불장군처럼 느껴지는 독단적이고 통제적인 성향",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "도 가졌지만, 그만큼 정해진 계획을 성실하고 계획적으로 지킬 줄 아는 멋진 친구입니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "esfj",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "이 어린이는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "태생적으로 사교성이 뛰어납니다",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: ". 주변 모든 사람들에게 관심이 많으나, 그 초점이 혼자만의 행복이 아닌 모두의 행복에 있습니다. 정해져 있는 규칙에 대한 옳고 그름을 분명하게 정의하는 것을 좋아합니다. 그리고 그 규칙을 모두에게 적용해 모두를 위한 행복에 적극적으로 힘을 냅니다. 이 어린이에게는 소통하며 결정하거나 추상적인 제안을 주기보다 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "스스로 결정하거나, 가이드가 분명한 환경을 제공",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "제공하는 것이 도움이 됩니다. 낙천적이면서도 이타적인 마음 덕에 다른 사람을 도우며 힘을 얻을거에요. 언제나 도움이 된다는 칭찬을 잊지 말아주세요!",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "istp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "이 어린이는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "외유내강이라는 단어",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "가 어울리네요. 조용하지만 주변 상황에 대한 관찰력도 좋아 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "몰입도와 적응력 모두 훌륭한 편",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "입니다. 몰입도가 좋은 만큼 정밀함을 필요로 하는 일에 강점을 보입니다. 주관이 뚜렷해 자신의 생각을 고집하는 면도 있습니다. 그러나 이만큼 적극적인 생각에 비해 행동이 재빠른 편은 아닙니다. 해서 지속적인 자극이 있는 일을 하는 것을 추천합니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "isfp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "차분하고 인내심이 많은",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: " 이 유형의 어린이는 편안한 상태의 현재를 중시합니다. 행동이 느리고 혼자 있는 것을 즐기는 차분하고 내향적인 성향을 가지고 있어요. 스트레스에 취약하기 때문에 억지로 친구들을 만나게 하거나 강압적으로 뭔가를 시키기보다는 원하는 만큼 혼자 있을 시간을 주거나 자유롭게 두는 것이 좋아요. 자유로운 상태에서 내면에 가지고 있는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "호기심이나 통찰력을 충분히 발휘시킬 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "수 있을 거에요. 그런 호기심과 통찰력은 세심한 주의력을 요하는 일에서 강점을 보여줍니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "estp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "최고의 친화력을 가진 이 어린이는 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "모르는 사람에게도 쉽게 쉽게 말을 겁니다",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: ". 발표나 토론에서도 대화를 주도하는 리더의 성향이 짙어요. 그런 대화 중 말투가 세서 가끔 화가 나 보일 수도 있습니다. 그러나 ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(
                                        text: "재치있는 입담이 돌발적인 갈등 상황에서도 대처 능력이 능하니 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "걱정할 것은 없어요. 다소 즉흥적이며 끊임없이 새로운 것을 시도하고 모르는 영역을 탐험하는 것을 즐기는 편이에요. 이런 행동력으로 얻은 지식과 기술 경험이 멋진 도움을 줄거에요. ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mbti == "esfp",
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: "천상 연예인 같은 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "이 어린이는 다른 친구들에 비해 불안함을 거의 느끼지 않아요. 해서 만사의 일을 발등에 불이 떨어져야 움직이기도 합니다. 장기적인 계획 세우기에는 약할지도 모르나 활동적이고 실질적인 일처리에는 능합니다.",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: " 사교적인 환경에서 많은 사람과 ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(
                                        text: "유대감을 가지고 지낼 때 가장 매력적이에요. 호기심도 많고, ",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                      TextSpan(text: "낙천적인 성격이 강점이니,  ",
                                        style: AppTextStyle.PD(
                                            AppColor_Primary, 18,
                                            weight: FW.bold, height: 1.8),),
                                      TextSpan(text: "고립되는 상황은 피해주세요!",
                                        style: AppTextStyle.PD(
                                            AppColor_BlackText, 18,
                                            weight: FW.regular, height: 1.8),),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ))

              ],
            ),

          ),
          MainTextButton(
            text: LanguageService.trans("결과 저장하기"),
            backgroundColor: AppColor_Primary,
            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
            width: 150,
            height: 45,
            onPressed: () {
              takeScreenshot();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget myMbtiTopBox() {
    double screenSize = (MediaQuery
        .of(context)
        .size
        .width - 70);
    return Container(
      child: Column(
        children: [
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .width - 70),
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15)),
                    child: Image.asset(
                        mainText, width: screenSize, fit: BoxFit.cover)
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .width - 70),
            height: 290,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15)),
            ),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15)),
                    child: Image.asset(
                        mainImage, width: screenSize,
                        fit: BoxFit.cover)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget backgroundImageButton() {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SizedBox(
              child: Image.asset(
                  "assets/mbti_background_change_image.png"),
            ),
            Positioned(
                top: 210,
                child: Center(
                  child: MainTextButton(
                    text: LanguageService.trans("홈 이동"),
                    backgroundColor: AppColor_Primary,
                    style: AppTextStyle.PD(
                        Colors.white, 18,
                        weight: FW.bold),
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width -
                        70),
                    height: 56,
                    disableBackground:
                    AppColor_Primary_Disable,
                    onPressed: () {
                      Navigator.push(
                          context,
                          SlideRightTransRoute(
                              builder: (context) =>
                                  TabMainPage()));
                      // const CustomMbtiInspectionMainPage();
                    },
                  ),
                )),
           Positioned(
                top: 280,
                child: Center(
                  child: Row(
                    children: [
                      H14(text: "© 2021. mingling Inc.All rights reserved.\n 모든 저작권은 (주)밍글링에 있습니다. ",
                        maxLine: 2,
                      color: Colors.black45,height: 1.2,)
                    ],
                  )
                )),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }

  Widget bestFriendsBox() {
    double screenSize = (MediaQuery
        .of(context)
        .size
        .width - 80) / 2;
    return Container(
      child: Column(
        children: [
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .width - 70),
            height: 60,
            decoration: const BoxDecoration(
              color: AppColor_Yellow,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15)),
            ),
            child: const Center(
              child: H22(
                text: "최고의 친구!",
                color: Colors.white,
                weight: FW.semi_bold,
              ),
            ),
          ),
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .width - 70),
            height: 170,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: CircleAvatar(
                            backgroundImage: AssetImage(friend1),
                            radius: 50)
                    ),
                    const SizedBox(height: 8,),
                    Image.asset(friend1Text, width: screenSize, height: 50)
                  ],
                ),
                const DottedLine(
                  direction: Axis.vertical,
                  dashColor: AppColor_Yellow,
                  lineThickness: 1.5,
                  dashLength: 7,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: CircleAvatar(
                            backgroundImage: AssetImage(friend2),
                            radius: 50)
                    ),
                    const SizedBox(height: 8,),
                    Container(
                        child: Image.asset(
                            friend2Text, width: screenSize, height: 50)
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget jobRecommendationBox() {
    return Container(
      child: Column(
        children: [
          Container(
            width: (MediaQuery
                .of(context)
                .size
                .width - 70),
            height: 50,
            decoration: const BoxDecoration(
              color: AppColor_Yellow,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15)),
            ),
            child: const Center(
              child: H22(
                text: "이 아이는 커서...",
                color: Colors.white,
                weight: FW.semi_bold,
              ),
            ),
          ),
          Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width - 70),
              height: 70,
              decoration: const BoxDecoration(

                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15)),
              ),
              child: Container(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: widget.mbti == "intj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "판사 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 결단력 있는 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "enfp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "모험적이면서 톡톡 튀는",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: " 영화 감독",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: " 같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "intp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "사진 작가",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(
                                    text: "처럼 매일 창의적인 결과를 낼 수 있는 일은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "entj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "자신의 역량을 펼치며 논리적인 해결책을 생각해내는",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: " 컨설턴트",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: " 같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "entp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "창의적인 협상과 토론에 능한",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: " 정치인",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: " 같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "infj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "직관적이고 깊은 통찰력으로 사람들의 호감을 얻는",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: " 예술가",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: " 같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "infp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "땨뜻한 마음으로 사람들을 헤아려줄 수 있는 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "상담가 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "enfj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "사회 운동가 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 정의로운 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "istj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "체계나 규칙이 중요한 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "공무원 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "isfj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "용감함과 신중함이 필요한 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "의사 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "estj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "엄격하면서도 열정적인 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "군인 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "esfj",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "사람들에게 많은 관심을 가지고 사교적인 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "외교관 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "istp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "관찰력과 정밀함이 필요한 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "개발자 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "isfp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "따뜻한 마음을 가진",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: " 사육사",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: " 같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "estp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "개척과 모험을 즐기는 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "CEO",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                      Visibility(
                          visible: widget.mbti == "esfp",
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "신나고 재미있는 일이 가득한 ",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                  TextSpan(
                                    text: "유튜버 ",
                                    style: AppTextStyle.PD(
                                        AppColor_Primary, 17,
                                        weight: FW.bold, height: 1.4),),
                                  TextSpan(text: "같은 직업은 어떨까요?",
                                    style: AppTextStyle.PD(
                                        AppColor_BlackText, 17,
                                        weight: FW.semi_bold, height: 1.4),),
                                ],
                              ))
                      ),
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }
}
