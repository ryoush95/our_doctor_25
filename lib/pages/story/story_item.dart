import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/story_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/woo_story_webview.dart';
import 'package:sprintf/sprintf.dart';
import 'package:substring_highlight/substring_highlight.dart';

// for test

class StoryDto {
  int uid;
  String dateTime;
  String type;
  String title;
  String link;
  int lookCnt;

  StoryDto({
    required this.uid,
    required this.dateTime,
    required this.type,
    required this.title,
    required this.link,
    required this.lookCnt,
  });
}

class StoryItem extends StatefulWidget {
  StoryInfo? item;

  StoryItem({required this.item});

  @override
  StoryItemState createState() => StoryItemState();
}

class StoryItemState extends BaseState<StoryItem> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  String type = "";
  String title = "";
  String dateTime = "";

  @override
  void initState() {
    super.initState();

    dateTime = DateFormat("yyyy.MM.dd hh:mm").format(dateFormat.parse(widget.item!.createdAt!));
    type = sprintf("[%s]", [widget.item!.categoryName!]);
    title = type + " " + widget.item!.title!;
  }

  void onClick() {
    // launch(widget.item!.url!);
    Navigator.push(context, SlideRightTransRoute(builder: (context) => WooStoryWebView(url: widget.item!.url!)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
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
                Row(
                  children: [
                    H12(
                      text: dateTime,
                      weight: FW.medium,
                      color: AppColor_GrayText,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Image.asset(
                      "assets/ic_view.png",
                      width: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    H12(
                      text: widget.item!.viewCnt!,
                      weight: FW.medium,
                      color: AppColor_GrayText,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 1,
                  color: AppColor_Divider,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
