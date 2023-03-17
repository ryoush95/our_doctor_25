
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product/test4_quiz_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product/test2_quiz_list_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/inspection_test2_answer.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

import 'inspection_test4_answer.dart';

class InspectionTest2FirstPage extends StatefulWidget {
  final ProductDetailDto data;

  InspectionTest2FirstPage({Key? key,required this.data}) : super(key: key);

  @override
  InspectionTest2FirstPageState createState() =>
      InspectionTest2FirstPageState();
}

class InspectionTest2FirstPageState
    extends BaseState<InspectionTest2FirstPage> {
  final HttpService httpService = HttpService();
  List<Test2QuizDto> list2 = [];
  List<Test4QuizDto> list4 = [];

  @override
  void initState() {
    // TODO: implement initState
    if(widget.data.category2 == "TEST2") {
      getQuizList2();
    }
    if(widget.data.category2 == "TEST4") {
      getQuizList4();
    }
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

  void getQuizList2() async {
    Future<Test2QuizListModel> info = httpService.getTest2QuizList(widget.data.id!);
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list2 = value.data!;
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void getQuizList4() async {
    if (widget.data.id == "52"){
      widget.data.id = widget.data.category3;
    }
    Future<Test4QuizModel> info = httpService.getTest4QuizList(widget.data.id!);
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list4 = value.data!;
        setState(() {});
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: widget.data.name,
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: precacheImage(CachedNetworkImageProvider(widget.data.detailImage!), context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return CachedNetworkImage(imageUrl: widget.data.detailImage!,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            );
                          } else {
                            return const SizedBox(
                              height: 85,
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                        }
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: MainTextButton(
                        text: "시작하기",
                        backgroundColor: AppColor_Primary,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        height: 70,
                        onPressed: () {
                          if(widget.data.category2 == "TEST2") {
                            Navigator.pushReplacement(context,
                              SlideRightTransRoute(builder: (context) =>
                                  InspectionTest2AnswerPage(listData: list2, info: widget.data,)),
                            );
                          }
                          if (widget.data.category2 == "TEST4"){
                            Navigator.pushReplacement(context,
                              SlideRightTransRoute(builder: (context) =>
                                  InspectionTest4AnswerPage(listData: list4, info: widget.data,)),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Image.network(widget.data.detailImage!),

          ],
        ));
  }
}
