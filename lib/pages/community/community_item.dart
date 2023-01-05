import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';

import 'community_detail.dart';

class CommunityItem extends StatefulWidget {
  CommunityItem({Key? key, required this.data, this.admin = "0"}) : super(key: key);

  CommunityDto data;
  String admin;

  @override
  State<CommunityItem> createState() => _CommunityItemState();
}

class _CommunityItemState extends State<CommunityItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: widget.admin == "1" ? AppColor_Primary : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              boxShadow: const [
                BoxShadow(
                  color: AppColor_Light_Gray,
                  blurRadius: 5.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Visibility(
                        visible: widget.admin == "1",
                        child: Image.asset('assets/ic_answer.png', width: 12),
                      ),
                      Visibility(
                        visible: widget.admin == "1",
                        child: const SizedBox(width: 2),
                      ),
                      H14(
                        text: widget.data.nickname!,
                        color: widget.admin == "1" ? Color(0xffB6D7FE) : Color(0xffA0A0A0),
                        weight: FW.regular,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      H14(
                        text: convertDate(widget.data.regTime!).substring(5),
                        color: widget.admin == "1" ? Color(0xffB6D7FE) : Color(0xffA0A0A0),

                        weight: FW.regular,
                      ),
                      const SizedBox(width: 10),
                    ]),
                    const SizedBox(height: 15),
                    H16(
                      text: widget.data.title!,
                      color: (widget.admin == "1") ? AppColor_White : Colors.black,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_border_outlined,
                          color: Color(0xffFF5252),
                          size: 18,
                        ),
                        H16(
                          text: " " + widget.data.likeCnt!,
                          color: (widget.admin == "1") ? AppColor_White : Color(0xffA0A0A0),
                          weight: FW.regular,
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Color(0xffA0A0A0),
                          size: 18,
                        ),
                        H16(
                          text: " " + widget.data.commentCnt!,
                          color: (widget.admin == "1") ? AppColor_White : Color(0xffA0A0A0),
                          weight: FW.regular,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              widget.data.imgUrls != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.data.imgUrls!,
                        width: 85,
                        height: 85,
                        fit: BoxFit.fill,
                      ),
                    )
                  : const SizedBox(width: 1),
            ],
          ),
        ),
      ],
    );
  }
}