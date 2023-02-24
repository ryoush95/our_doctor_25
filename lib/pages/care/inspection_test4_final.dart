import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/models/product/test2_quiz_list_model.dart';
import 'package:ourdoctor/models/product/test_quiz_result_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class InspectionTest4FinalPage extends StatefulWidget {
  final ProductDetailDto info;
  final TestResultDto result;

  InspectionTest4FinalPage({Key? key, required this.info, required this.result,}) : super(key: key);

  @override
  InspectionTest4FinalPageState createState() =>
      InspectionTest4FinalPageState();
}

class InspectionTest4FinalPageState
    extends BaseState<InspectionTest4FinalPage> {
  final HttpService httpService = HttpService();
  Test2QuizDto res = new Test2QuizDto();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Center(child: H18(text: widget.info.name!, color: AppColor_Primary,)),
              const SizedBox(height: 20,),
              LinearPercentIndicator(progressColor: AppColor_Primary, percent: 1),
              const SizedBox(height: 20,),
              Center(
                child: Image.network(
                  widget.info.mainImage!,
                  width: MediaQuery.of(context).size.width - 60,
                ),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: MainTextButton(
                  text: "홈으로",
                  backgroundColor: AppColor_Primary,
                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                  height: 70,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // ListView.builder(
              //   itemCount: widget.list.length,
              //     itemBuilder: (context, index) {
              //   return Text(widget.list[index].answer);
              // }),
            ],
          ),
        ));
  }
}
