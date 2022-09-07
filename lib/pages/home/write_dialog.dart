import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/components/h22.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class WriteDialog extends StatefulWidget {
  const WriteDialog({Key? key}) : super(key: key);

  @override
  WriteDialogState createState() => WriteDialogState();
}

class WriteDialogState extends State<WriteDialog> {
  final HttpService httpService = HttpService();
  bool valid = false;
  var contentController = TextEditingController();
  String content = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void onLeaveMessage() {
    Navigator.pop(context);
  }

  void checkValid() {
    setState(() {
      valid = content.isNotEmpty;
    });
  }

  // Network functions
  //////////////////////////////////
  //결과메시지 남기기
  Future<void> reqSendMsg() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo = httpService.sendMsg(content);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('send_msg_success'));
        Navigator.pop(context);
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: onBackPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Image.asset(
                    "assets/clear_black_24dp.png",
                    width: 20,
                  ),
                ),
              )),
          H22(
            text: LanguageService.trans("treatment_complete"),
          ),
          const SizedBox(height: 20),
          Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), border: Border.all(color: AppColor_Gray)),
            child: TextField(
              controller: contentController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium),
              decoration: InputDecoration(
                counterText: "",
                hintText: LanguageService.trans("review_input_hint"),
                hintStyle: AppTextStyle.PD(AppColor_Gray, 14, weight: FW.medium),
                border: InputBorder.none,
              ),
              onEditingComplete: () {
                onLeaveMessage();
              },
              maxLines: 100,
              onChanged: (text) => {content = text, checkValid()},
            ),
          ),
          const SizedBox(height: 30),
          MainTextButton(
            text: LanguageService.trans("leave_msg"),
            backgroundColor: AppColor_Primary,
            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
            width: 350,
            disable: !valid,
            disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
            onPressed: () {
              reqSendMsg();
            },
          ),
          const SizedBox(height: 30),
        ]),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
    );
  }
}
