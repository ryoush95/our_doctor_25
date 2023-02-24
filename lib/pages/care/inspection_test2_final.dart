
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/models/product/test2_quiz_list_model.dart';
import 'package:ourdoctor/models/product/test_quiz_result_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class InspectionTest2FinalPage extends StatefulWidget {
  final List<Test2QuizDto> list;
  final String testName;
  final TestResultDto result;

  InspectionTest2FinalPage({Key? key, required this.list, required this.testName, required this.result}) : super(key: key);

  @override
  InspectionTest2FinalPageState createState() =>
      InspectionTest2FinalPageState();
}

class InspectionTest2FinalPageState
    extends BaseState<InspectionTest2FinalPage> {
  final HttpService httpService = HttpService();
  Test2QuizDto res = new Test2QuizDto();
  String img = "";

  @override
  void initState() {
    // TODO: implement initState
    for(var i in widget.list){
      if(i.result == 'result'){
        res = i;
      }
    }

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
              Center(child: H18(text: widget.testName, color: AppColor_Primary,)),
              const SizedBox(height: 20,),
              LinearPercentIndicator(progressColor: AppColor_Primary, percent: 1),
              const SizedBox(height: 20,),
              Center(
                child: FutureBuilder(
                    future: precacheImage(CachedNetworkImageProvider(widget.result.resultImage!), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CachedNetworkImage(
                          imageUrl: widget.result.resultImage!,
                          width: MediaQuery.of(context).size.width - 60,
                          fit: BoxFit.fill,
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
              ),
              Container(
                padding: const EdgeInsets.all(30),
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
