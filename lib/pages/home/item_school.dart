import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';

class ItemSchool extends StatefulWidget {
  const ItemSchool({Key? key, required this.item}) : super(key: key);

  final CommunityDto item;
  @override
  ItemSchoolState createState() => ItemSchoolState();
}

class ItemSchoolState extends BaseState<ItemSchool> {
  String getTopicName(String topic) {
    String result = "";
    if (topic == "notice") {
      result = "공지/이벤트";
    } else if (topic == "treatment") {
      result = "뉴스";
    } else if (topic == "school") {
      result = "교육";
    } else if (topic == "faq") {
      result = "질문";
    } else if (topic == "talk") {
      result = "자유게시판";
    } else {
      result = "우아팁";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 230,
      margin: const EdgeInsets.only(right: 10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: AppColor_Selector_Border),
      //   borderRadius: const BorderRadius.all(Radius.circular(8)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: widget.item.imgUrl! != "",
            child: Container(
              margin: const EdgeInsets.only(top: 10,bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: ExtendedImage.network(
                  widget.item.imgUrl!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Row(
            children: [
              H14(text: "[" + getTopicName(widget.item.topic!) + "]", weight: FW.semi_bold, color: AppColor_Primary),
              const SizedBox(width: 5),
              // Expanded(
              //   child: Text(
              //     widget.item.title!,
              //     textAlign: TextAlign.start,
              //     style: const TextStyle(
              //       fontWeight: FontWeight.w600,
              //       color: AppColor_BlackText,
              //     ),
              //     maxLines: 1,
              //   )
              // ),
              Expanded(
                child: H14(
                  text: widget.item.title!,
                  weight: FW.medium,
                  align: TextAlign.start,
                  color: AppColor_BlackText,
                  ellipsis: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
