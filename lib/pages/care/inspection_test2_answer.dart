import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/test2_quiz_list_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/inspection_test2_final.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
    endAlert();

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  void selectQuiz(String s) {
    list[quizNum].answer = s;
    quizResult.add(s);

    if (quizNum < list.length-1) {
      setState(() {
        quizNum++;
        Future.delayed(const Duration(milliseconds: 200));
      });
    } else {
      String r = '0';
      if(quizResult.indexOf('0') < quizResult.indexOf('1')){
        r = '1';
      }

      Navigator.of(context).pushReplacement(SlideRightTransRoute(builder: (context) =>
          InspectionTest2FinalPage(list: widget.listData, testName : widget.testName, result: r)),);
      quizNum = 0;
      quizResult.clear();
    }
  }

  void backQuiz() {
    if(quizNum > 0) {
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
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            backQuiz();
                          },
                          child: Container(
                            width : 40,
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child : const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Center(child: H18(text: widget.testName, color: AppColor_Primary,)),
                        const SizedBox(width: 40,),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: Text("${quizNum + 1} / ${list.length}"),
                    ),
                    LinearPercentIndicator(progressColor: AppColor_Primary, percent: (quizNum+1) / list.length),
                    const SizedBox(height: 20,),
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
                    const SizedBox(height: 20),
                    list[quizNum].type == '0'
                        ? GestureDetector(
                            onTap: () {
                              selectQuiz('0');
                            },
                            child:FutureBuilder(
                                future: precacheImage(CachedNetworkImageProvider(list[quizNum].quiz1Image!), context),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return CachedNetworkImage(
                                      imageUrl: list[quizNum].quiz1Image!,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    );
                                  } else {
                                    return const SizedBox(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                }
                            ))
                            // Image.network(list[quizNum].quiz1Image!))
                        : GestureDetector(
                            onTap: () {
                              selectQuiz('1');
                            },
                            child:FutureBuilder(
                                future: precacheImage(CachedNetworkImageProvider(list[quizNum].quiz2Image!), context),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return CachedNetworkImage(
                                      imageUrl: list[quizNum].quiz2Image!,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    );
                                  } else {
                                    return const SizedBox(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                }
                            )),
                    SizedBox(
                      width: screenSize.width,
                      height: 40,
                      child: const Center(
                        child: Text(
                          "VS",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Recipekorea',
                              color: AppColor_Red),
                        ),
                      ),
                    ),
                    list[quizNum].type == '0'
                        ? GestureDetector(
                        onTap: () {
                          selectQuiz('1');
                        },
                        child:
                        CachedNetworkImage(
                          imageUrl: list[quizNum].quiz2Image!,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: CircularProgressIndicator(value: downloadProgress.progress)),))
                        // Image.network(list[quizNum].quiz2Image!))
                        : GestureDetector(
                        onTap: () {
                          selectQuiz('0');
                        },
                        child: CachedNetworkImage(imageUrl: list[quizNum].quiz1Image!
                        ,progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: CircularProgressIndicator(value: downloadProgress.progress)),))
                        // Image.network(list[quizNum].quiz1Image!)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
