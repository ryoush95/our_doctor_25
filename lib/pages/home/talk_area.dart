import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/community_add_res_model.dart';
import 'package:ourdoctor/models/community_detail_res_model.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/item_news.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';

import '../app_event.dart';
import 'item_community.dart';
import 'item_news.dart';
import 'item_quiz.dart';

class TalkArea extends StatefulWidget {
  TalkArea({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;

  @override
  TalkAreaState createState() => TalkAreaState();
}

class TalkAreaState extends BaseState<TalkArea> {
  final HttpService httpService = HttpService();

  // CommunityListResModel? arrNewsList;
  CommunityDetailDto? dicDetailInfo;
  List<CommunityDto> arrNewsList = [];

  @override
  void initState() {
    super.initState();

    getNewsList();
  }

  //홈 데이터 얻기
  Future<void> getNewsList() async {
    setState(() {
      isLoading = true;
    });

    Future<CommunityListResModel> info =
        httpService.communityList("", 0, "talk", "recent", "");
    info.then((CommunityListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        // arrNewsList.addAll(value.data!.contents!);
        var l = value.data!.contents!;
        for (var i in l) {
          if (arrNewsList.length >= 10) break;
          if (i.topic == "talk") {
            if (arrNewsList.isEmpty && i.admin == "1") {
              arrNewsList.add(i);
            }
            if (i.admin == "0") {
              arrNewsList.add(i);
            }
          }
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  void tileTap(a) {
    if (widget.curCategory == 0) {
      Navigator.push(
        context,
        SlideRightTransRoute(
            builder: (context) => CommunityDetailPage(
              uid: a.uid,
              videoUrl:
              a.blogUrl,
            )),
      );
    } else {
      Navigator.push(
        context,
        SlideRightTransRoute(
            builder: (context) => CommunityDetailPage(
              uid: a.uid,
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // arrNewsList.sublist(1, 6);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    H20(text: '자유게시판'),
                    InkWell(
                      onTap: () {
                        eventBus.fire(MoreCommunityEvent(type: 5));
                      },
                      child: H14(
                          text: LanguageService.trans('more'),
                          weight: FW.medium),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                arrNewsList[0].imgUrl == ""
                    ? Container()
                    : InkWell(
                        onTap: () {
                          tileTap(arrNewsList.elementAt(0));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor_Gray,
                                  blurRadius: 5.0, // soften the shadow
                                  spreadRadius: 5.0, //extend the shadow
                                )
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  H16(
                                    text: arrNewsList.elementAt(0).name!,
                                    color: const Color(0xffA0A0A0),
                                  ),
                                  const Spacer(),
                                  H16(
                                    text: convertDate(
                                        arrNewsList.elementAt(0).regTime!),
                                    color: const Color(0xffA0A0A0),
                                    weight: FW.regular,
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Color(0xffFF5252),
                                    size: 18,
                                  ),
                                  H16(
                                    text:
                                        " " + arrNewsList.elementAt(0).likeCnt!,
                                    color: const Color(0xffA0A0A0),
                                    weight: FW.regular,
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Color(0xffA0A0A0),
                                    size: 18,
                                  ),
                                  H16(
                                    text: " " +
                                        arrNewsList.elementAt(0).commentCnt!,
                                    color: const Color(0xffA0A0A0),
                                    weight: FW.regular,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              H18(text: arrNewsList.elementAt(0).title!),
                              const SizedBox(height: 10),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          arrNewsList.elementAt(0).imgUrl!)),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                !isLoading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: ListView.builder(
                            itemCount: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              CommunityDto a = arrNewsList.elementAt(index + 1);
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      tileTap(a);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor_Gray,
                                              blurRadius: 5.0, // soften the shadow
                                              spreadRadius: 5.0, //extend the shadow
                                            )
                                          ]),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  H16(
                                                    text: a.nickname!,
                                                    color: const Color(0xffA0A0A0),
                                                  ),
                                                  const Spacer(),
                                                  H16(
                                                    text: convertDate(a.regTime!),
                                                    color: const Color(0xffA0A0A0),
                                                    weight: FW.regular,
                                                  ),
                                                  const SizedBox(width: 10),
                                                ]),
                                                const SizedBox(height: 10),
                                                H16(
                                                  text: a.title!,
                                                  align: TextAlign.start,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.favorite_border_outlined,
                                                      color: Color(0xffFF5252),
                                                      size: 18,
                                                    ),
                                                    H16(
                                                      text: " " + a.likeCnt!,
                                                      color: const Color(0xffA0A0A0),
                                                      weight: FW.regular,
                                                    ),
                                                    const SizedBox(width: 20),
                                                    const Icon(
                                                      Icons.chat_bubble_outline,
                                                      color: Color(0xffA0A0A0),
                                                      size: 18,
                                                    ),
                                                    H16(
                                                      text: " " + a.commentCnt!,
                                                      color: const Color(0xffA0A0A0),
                                                      weight: FW.regular,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: a.imgUrls != "",
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: CachedNetworkImage(
                                                imageUrl: a.imgUrls!,
                                                width: 84,
                                                height: 84,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }),
                      )
                    : Container(),
              ],
            )
          : Container(),
    );
  }

  String convertDate(String d) {
    var date = DateTime.parse(d);
    String c = DateFormat("MM/dd").format(date);

    return c;
  }
}
