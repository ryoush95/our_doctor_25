import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    Future<CommunityListResModel> info = httpService.communityList("", 0, "talk", "recent", "");
    info.then((CommunityListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        // arrNewsList.addAll(value.data!.contents!);
        var l = value.data!.contents!;
        for(var i in l){
          if(i.topic == "talk"){
            arrNewsList.add(i);
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

  @override
  Widget build(BuildContext context) {
    final subArrNewsList = arrNewsList.sublist(0, 5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H20(text: LanguageService.trans('자유게사판')),
              InkWell(
                onTap: () {
                  eventBus.fire(MoreCommunityEvent());
                },
                child: H14(text: LanguageService.trans('more'), weight: FW.medium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          subArrNewsList != null && subArrNewsList.length > 1
              ? SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: ListView.separated(
                      //shrinkWrap: false,
                      //scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                      itemCount: subArrNewsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        CommunityDto info =
                            subArrNewsList.elementAt(index);
                        return InkWell(
                          child: ItemQuiz(item: info),
                          onTap: () {
                              Navigator.push(
                                  context,
                                  SlideRightTransRoute(
                                      builder: (context) => CommunityDetailPage(
                                            uid: info.uid,
                                            videoUrl: null,
                                          )),
                              );
                          },
                        );
                      },separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1);},
                      ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
