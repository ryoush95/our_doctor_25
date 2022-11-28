import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/test2_quiz_list_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/inspection_test2_answer.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlusTest4AnswerPage extends StatefulWidget {
  //final ProductDetailDto data;

  PlusTest4AnswerPage({
    Key? key,
    /*required this.data*/
  }) : super(key: key);

  @override
  PlusTest4AnswerPageState createState() => PlusTest4AnswerPageState();
}

class PlusTest4AnswerPageState extends BaseState<PlusTest4AnswerPage> {
  final HttpService httpService = HttpService();
  List<Test2QuizDto> list = [];
  late ScrollController _listController;
  int quizNum = 0;
  List<String> quizResult = [];

  //FIXME
  String answer = "1";

  @override
  void initState() {
    // TODO: implement initState
    // getQuizList();
    _listController = ScrollController();
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('검사 중단'),
        titleTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.semi_bold),
        content: const Text('검사를 중단하시겠습니까?\n차감된 포인트는 환급되지 않습니다.'),
        contentTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.regular),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              return;
            },
            child: const Text('네'),
          ),
        ],
      ),
    );
    return false;
  }

  void backQuiz() {
    if (quizNum > 0) {
      setState(() {
        quizResult.removeLast();
        quizNum--;
      });
    } else {
      endAlert();
    }
  }

  void endAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('검사 중단'),
        titleTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.semi_bold),
        content: const Text('검사를 중단하시겠습니까?\n차감된 포인트는 환급되지 않습니다.'),
        contentTextStyle: AppTextStyle.PD(Colors.black, 18, weight: FW.regular),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              return;
            },
            child: const Text('네'),
          ),
        ],
      ),
    );
  }

  // void getQuizList() async {
  //   Future<Test2QuizListModel> info =
  //       httpService.getTest2QuizList(widget.data.id!);
  //   info.then((value) async {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     if (value.result == 0) {
  //       list = value.data!;
  //       setState(() {});
  //     }
  //   }).catchError((onError) {
  //     print(onError.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            backQuiz();
                          },
                          child: Container(
                            width: 40,
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Center(
                            child: H18(
                          text: "ㄹㅇㅁㄴㄹㅇㄴㅁ",
                          color: AppColor_Primary,
                        )),
                        const SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: Text(/*"${quizNum + 1} / ${list.length}"*/ "ㅁㄴㅇ"),
                    ),
                    // LinearPercentIndicator(
                    //     progressColor: AppColor_Primary,
                    //     percent: (quizNum + 1) / list.length),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "우리 아이에게\n",
                                  style: AppTextStyle.PD(AppColor_Primary, 20,
                                      weight: FW.regular, height: 1.2),
                                ),
                                TextSpan(
                                  text: "어떤 양육을 하고 있을까?\n\n\n",
                                  style: AppTextStyle.PD(AppColor_BlackText, 18,
                                      weight: FW.regular, height: 1.2),
                                ),
                                TextSpan(
                                  text: "다음 질문에 응답해 주세요.\n\n\n",
                                  style: AppTextStyle.PD(AppColor_BlackText, 19,
                                      weight: FW.bold),
                                ),
                                TextSpan(
                                  text: "${quizNum + 1} / 5 ",
                                  style: AppTextStyle.PD(
                                      AppColor_Table_DateTime, 15,
                                      weight: FW.regular),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: AppColor_Table_DateTime,
                            thickness: 1,
                          ),
                          const SizedBox(height: 30),
                          //  _itemBuilder( context, 0)

                          ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: _itemBuilder,
                              itemCount: 1, //widget.list.length,
                              controller: _listController)
                        ],
                      ),
                    )

                    //  Image.network(list[quizNum].quiz1Image!)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Q${index + 1}\n\n",
                style: AppTextStyle.PD(AppColor_Table_DateTime, 18,
                    weight: FW.bold),
              ),
              TextSpan(
                text: "asd", //widget.list[index].quiz!,
                style: AppTextStyle.PD(AppColor_BlackText, 17,
                    weight: FW.regular, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        checkbox(index),
        const SizedBox(height: 30)
      ]),
    );
  }

  Widget checkbox(int index) {
    return Column(
      children: [
        Row(
          children: [
            answer == "1" || answer == "2"
                ? Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor_Primary,
                      border: Border.all(color: AppColor_Primary),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 3),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.asset(
                                "assets/check_icon.png",
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: H16(
                              text: LanguageService.trans("아니다"),
                              weight: FW.medium,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ))
                : Container(
                    width: 80,
                    height: 30,
                    child: H16(
                      text: LanguageService.trans("아니다"),
                      weight: FW.medium,
                      color: AppColor_BlackText,
                    ),
                  ),
          ],
        ),
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    answer = "1";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      answer == "1"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    answer = "2";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      answer == "2"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    answer = "3";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      answer == "3"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    answer = "4";
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      answer == "4"
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            answer == "3" || answer == "4"
                ? Container(
                    alignment: Alignment.bottomLeft,
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColor_Primary,
                      border: Border.all(color: AppColor_Primary),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 3),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.asset(
                                "assets/check_icon.png",
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: H16(
                              text: LanguageService.trans("그렇다"),
                              weight: FW.medium,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ))
                : Container(
                    width: 80,
                    height: 30,
                    child: H16(
                      text: LanguageService.trans("그렇다"),
                      weight: FW.medium,
                      color: AppColor_BlackText,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
