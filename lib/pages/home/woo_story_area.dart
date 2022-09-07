import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/item_story.dart';
import 'package:ourdoctor/pages/intro/first.dart';

import '../woo_story_webview.dart';

class WooStoryArea extends StatefulWidget {
  WooStoryArea({Key? key, this.curCategory}) : super(key: key);
  int? curCategory;

  @override
  WooStoryAreaState createState() => WooStoryAreaState();
}

class WooStoryAreaState extends BaseState<WooStoryArea> {
  String name = 'test';
  int age = 4;
  String finalMeasureDate = '2020.12.19';
  final HttpService httpService = HttpService();
  List<StoryList>? arrStoryList;

  @override
  void initState() {
    super.initState();

    getHomeStoryList();
  }

  // Future<Metadata> getData(String _url) async {
  //   var data = await MetadataFetch.extract(_url);
  //   print(data!.title);
  //   print(data.image);
  //   return data;
  // }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getHomeStoryList() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeDataResModel> info = httpService.homeData("home");
    info.then((HomeDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrStoryList = value.data!.storyList;
        // if (arrStoryList!.isNotEmpty) {
        //   for (int i = 0; i < arrStoryList!.length - 1; i++) {
        //     getData(arrStoryList!.elementAt(i).url!).then((value) => {arrStoryList!.elementAt(i).thumbTitle = value.title, arrStoryList!.elementAt(i).thumbImg = value.image, setState(() {})});
        //   }
        // }
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H20(text: LanguageService.trans('woo_story')),
              InkWell(
                onTap: () {
                  eventBus.fire(MoreStoryEvent());
                },
                child: H14(text: LanguageService.trans('more'), weight: FW.medium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 148,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: arrStoryList == null ? 0 : arrStoryList!.length,
                itemBuilder: (BuildContext context, int index) {
                  StoryList info = arrStoryList!.elementAt(index);
                  return InkWell(
                    child: ItemStroy(item: info),
                    onTap: () {
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => WooStoryWebView(url: info.url!)));
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
