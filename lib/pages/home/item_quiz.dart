import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/models/community_detail_res_model.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';

class ItemQuiz extends StatefulWidget {
  const ItemQuiz({Key? key, required this.item}) : super(key: key);

  final CommunityDto item;

  @override
  ItemQuizState createState() => ItemQuizState();
}

class ItemQuizState extends BaseState<ItemQuiz> {
  CommunityDetailDto? dicDetailInfo;
  List<CommunityDto> arrCommunityList = [];

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
      width: MediaQuery.of(context).size.width * .7,
      height: 55,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

      /* decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor_Selector_Border),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),*/
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: widget.item.imgUrl! != "",
            child: Container(
              //margin: const EdgeInsets.only(top: 10,bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: ExtendedImage.network(
                  widget.item.imgUrl!,
                  width: 50,
                  height: 35,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  H14(
                      text: "[" + getTopicName(widget.item.topic!) + "]",
                      weight: FW.semi_bold,
                      color: AppColor_Primary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: H14(
                      text: widget.item.title!,
                      weight: FW.semi_bold,
                      align: TextAlign.start,
                      color: AppColor_BlackText,
                      ellipsis: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: AutoSizeText(
                  getcontent(widget.item),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColor_BlackText.withOpacity(.4),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  maxFontSize: 12,
                  minFontSize: 8,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  String getcontent(CommunityDto info) {
    String result = "";

    if (info.topic! == "notice") {
      result = "우아닥터·" +
          diffTime(info.regTime!) +
          "·좋아요 " +
          info.likeCnt.toString() +
          "·댓글 " +
          info.commentCnt.toString();
    } else if (info.topic! == "life") {
      result = info.nickname! +
          "·" +
          diffTime(info.regTime!) +
          "·댓글 " +
          info.commentCnt.toString();
    } else {
      result = info.nickname! +
          "·" +
          diffTime(info.regTime!) +
          "·좋아요 " +
          info.likeCnt.toString() +
          "·댓글 " +
          info.commentCnt.toString();
    }
    return result;
  }
}
