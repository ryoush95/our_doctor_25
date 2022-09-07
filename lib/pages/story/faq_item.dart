import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/models/faq_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:substring_highlight/substring_highlight.dart';

class FaqItem extends StatefulWidget {
  FaqListDto item;

  FaqItem({required this.item});

  @override
  FaqItemState createState() => FaqItemState();
}

class FaqItemState extends BaseState<FaqItem> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  String type = "";
  String title = "";
  String dateTime = "";
  bool showDetail = false;
  String htmlData = "";

  @override
  void initState() {
    super.initState();

    dateTime = DateFormat("yyyy.MM.dd hh:mm").format(dateFormat.parse(widget.item.createdAt!));
    String temp = widget.item.category!;
    if (temp == "signup") {
      type = "[회원가입]";
    } else if (type == "login") {
      type = "[로그인]";
    } else if (temp == "home") {
      type = "[홈케어]";
    } else if (temp == "error") {
      type = "[오류]";
    }
    // type = sprintf("[%s]", [widget.item.category!]);
    title = type + " " + widget.item.question!;
    htmlData = widget.item.answer!;
  }

  void onClick() {
    setState(() {
      showDetail = !showDetail;
    });
  }

  String getCategoryName(String type) {
    String result = "";
    if (type == "[signup]") {
      result = "회원가입";
    } else if (type == "[login]") {
      result = "로그인";
    } else if (type == "[home]") {
      result = "홈케어";
    } else if (type == "[error]") {
      result = "오류";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubstringHighlight(
                  text: title,
                  term: type,
                  textStyle: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.medium, height: 1.5),
                  textStyleHighlight: AppTextStyle.PD(AppColor_Primary, 14, weight: FW.medium),
                ),
                const SizedBox(
                  height: 15,
                ),
                H12(
                  text: dateTime,
                  weight: FW.medium,
                  color: AppColor_GrayText,
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: showDetail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColor_Light_Gray,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // H14(
                        //   text: widget.item.answer!,
                        //   weight: FW.medium,
                        //   maxLine: 100,
                        //   height: 1.5,
                        //   align: TextAlign.start,
                        // ),
                        // Html(
                        //   data: htmlData,
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // ExtendedImage(
                        //   //image: NetworkImage(widget.item.image),
                        //   image: NetworkImage(""),
                        //   width: double.infinity,
                        //   fit: BoxFit.fill,
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColor_Light_Gray,
          )
        ],
      ),
    );
  }
}
