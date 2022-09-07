import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';

class ItemStroy extends StatefulWidget {
  const ItemStroy({Key? key, required this.item}) : super(key: key);

  final StoryList item;

  @override
  ItemStroyState createState() => ItemStroyState();
}

class ItemStroyState extends BaseState<ItemStroy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 218,
      height: 200,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor_Selector_Border),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H14(text: widget.item.title!, weight: FW.semi_bold),
          const SizedBox(height: 10),
          H12(
            text: widget.item.contents!,
            weight: FW.medium,
            color: AppColor_GrayText,
            height: 1.5,
            align: TextAlign.start,
            maxLine: 5,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
