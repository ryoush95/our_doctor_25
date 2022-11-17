import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/child_quiz_list_res_model.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/test2_quiz_list_model.dart';
import 'package:ourdoctor/pages/alarm/alarm.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/inspection_test2_final.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:ourdoctor/provider/child_quiz_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class InspectionTest2AnswerPage extends StatefulWidget {
  final List<Test2QuizDto> listData;
  final String testName;

  InspectionTest2AnswerPage({Key? key, required this.listData, required this.testName}) : super(key: key);

  @override
  InspectionTest2AnswerPageState createState() => InspectionTest2AnswerPageState();
}

class InspectionTest2AnswerPageState extends BaseState<InspectionTest2AnswerPage> {
  final HttpService httpService = HttpService();
  late ScrollController _listController;
  List<Test2QuizDto> list = [];
  int quizNum = 0;
  List<String> quizResult = [];

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    for (var i in widget.listData) {
      if(i.result != 'result'){
        list.add(i);
      }
    }
    setState(() {});
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
        content: Text('검사를 중단하시겠습니까?\n차감된 포인트는 환급되지 않습니다.'),
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
            },
            child: const Text('네'),
          ),
        ],
      ),
    );
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  bool checkValid() {
    if (list
        .sublist(0, list.length)
        .where((element) => element.answer == "")
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  void selectQuiz(String s) {
    list[quizNum].answer = s;
    quizResult.add(s);

    if (quizNum < list.length-1) {
      setState(() {
        quizNum++;
      });
    } else {
      String r = '0';
      if(quizResult.indexOf('0') < quizResult.indexOf('1')){
        r = '1';
      }

      Navigator.of(context).pushReplacement(SlideRightTransRoute(builder: (context) =>
          InspectionTest2FinalPage(list: widget.listData, testName : widget.testName, result: r)),);
    }
  }

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
                    SizedBox(height: 20,),
                    Center(child: H18(text: widget.testName, color: AppColor_Primary,)),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: Text("${quizNum + 1} / ${list.length}"),
                    ),
                    LinearPercentIndicator(progressColor: AppColor_Primary, percent: (quizNum+1) / list.length),
                    SizedBox(height: 20,),
                    Container(
                      width: screenSize.width,
                      child: Text(
                        "${list[quizNum].page!}. " + list[quizNum].title!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontFamily: 'Recipekorea'),
                      ),
                    ),
                    SizedBox(height: 20),
                    list[quizNum].type == '0'
                        ? GestureDetector(
                            onTap: () {
                              selectQuiz('0');
                            },
                            child: Image.network(list[quizNum].quiz1Image!))
                        : GestureDetector(
                            onTap: () {
                              selectQuiz('1');
                            },
                            child: Image.network(list[quizNum].quiz2Image!)),
                    SizedBox(height: 60),
                    list[quizNum].type == '0'
                        ? GestureDetector(
                        onTap: () {
                          selectQuiz('1');
                        },
                        child: Image.network(list[quizNum].quiz2Image!))
                        : GestureDetector(
                        onTap: () {
                          selectQuiz('0');
                        },
                        child: Image.network(list[quizNum].quiz1Image!)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
