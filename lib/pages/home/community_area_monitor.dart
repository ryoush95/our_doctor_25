import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/item_community.dart';
import 'package:ourdoctor/pages/intro/first.dart';

import 'item_community_monitor.dart';

class CommunityArea2 extends StatefulWidget {
  CommunityArea2({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;

  @override
  CommunityAreaState createState() => CommunityAreaState();
  
}

class CommunityAreaState extends BaseState<CommunityArea2> {
  final HttpService httpService = HttpService();
  List<CommunityList>? arrCommunityList;

  @override
  void initState() {
    super.initState();

    getCommunityList();
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getCommunityList() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeDataResModel> info = httpService.homeData(widget.curCategory == 0 ? "home" : "monitor");
    info.then((HomeDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrCommunityList = value.data!.communityList;
        setState(() {});
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
      final subArrCommunityList = arrCommunityList?.sublist(0, 10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H20(text: LanguageService.trans('community')),
              InkWell(
                onTap: () {
                  eventBus.fire(MoreCommunityEvent());
                },
                child: H14(text: LanguageService.trans('more'), weight: FW.medium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          subArrCommunityList != null && subArrCommunityList.length > 1 
          ? SizedBox(
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: subArrCommunityList.length,
                itemBuilder: (BuildContext context, int index) {
                  CommunityList info = subArrCommunityList.elementAt(index);
                  return InkWell(
                    child: ItemCommunity2(item: info),
                    onTap: () {
                      if(widget.curCategory == 0) {
                        Navigator.push(context, SlideRightTransRoute(
                        builder: (context) => CommunityDetailPage(
                          uid: info.uid,
                          videoUrl: info.blogUrl,
                        )));
                      } else {
                        Navigator.push(context, SlideRightTransRoute(
                        builder: (context) => CommunityDetailPage(
                          uid: info.uid,
                        )));
                      }
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
