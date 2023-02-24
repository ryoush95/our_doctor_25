
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product/test2_quiz_list_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/care/inspection_test2_answer.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

class PlusTest4FirstPage extends StatefulWidget {
  final ProductDetailDto data;

  PlusTest4FirstPage({Key? key,required this.data}) : super(key: key);

  @override
  PlusTest4FirstPageState createState() =>
      PlusTest4FirstPageState();
}

class PlusTest4FirstPageState
    extends BaseState<PlusTest4FirstPage> {
  final HttpService httpService = HttpService();
  List<Test2QuizDto> list = [];

  @override
  void initState() {
    // TODO: implement initState
    getQuizList();
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

  void getQuizList() async {
    Future<Test2QuizListModel> info = httpService.getTest2QuizList(widget.data.id!);
    info.then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        list = value.data!;
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SimpleHeader(
                title: widget.data.name,
                onBackPressed: onBackPressed,
              ),
              Image.network(widget.data.detailImage!),
              Container(
                padding: EdgeInsets.all(30),
                child: MainTextButton(
                  text: "시작하기",
                  backgroundColor: AppColor_Primary,
                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                  height: 70,
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        SlideRightTransRoute(builder: (context) => InspectionTest2AnswerPage(listData: list, info: widget.data,)),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
