import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/community_detail_res_model.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/item_community.dart';
import 'package:ourdoctor/pages/intro/first.dart';

import 'item_community_monitor.dart';
import 'item_school.dart';

class SchoolArea extends StatefulWidget {
  SchoolArea({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;

  @override
  SchoolAreaState createState() => SchoolAreaState();
}

class SchoolAreaState extends BaseState<SchoolArea> {
  final HttpService httpService = HttpService();
  List<CommunityDto> arrSchoolList = [];

  @override
  void initState() {
    super.initState();

    getSchoolList();
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getSchoolList() async {
    setState(() {
      isLoading = true;
    });

    Future<CommunityListResModel> info =
        httpService.communityList("", 0, "school", "recent", "");
    info.then((CommunityListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        // arrNewsList.addAll(value.data!.contents!);
        var l = value.data!.contents!;
        for (var i in l) {
          if (arrSchoolList.length >= 10) break;
          if (i.topic == "school" && i.imgUrl != "") {
            arrSchoolList.add(i);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H18(text: "교육"),
              InkWell(
                onTap: () {
                  eventBus.fire(MoreCommunityEvent(type: 2));
                },
                child:
                    H14(text: LanguageService.trans('more'), weight: FW.medium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          !isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: arrSchoolList.length,
                      itemBuilder: (BuildContext context, int index) {
                        CommunityDto info = arrSchoolList.elementAt(index);
                        return InkWell(
                          child: ItemSchool(item: info),
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
                      }),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
