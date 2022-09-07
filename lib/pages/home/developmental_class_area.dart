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
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/item_development.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:url_launcher/url_launcher.dart';

class DevelopmentalClassArea extends StatefulWidget {
  DevelopmentalClassArea({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;
  @override
  DevelopmentalClassAreaState createState() => DevelopmentalClassAreaState();
}

class DevelopmentalClassAreaState extends BaseState<DevelopmentalClassArea> {
  final HttpService httpService = HttpService();
  List<DevelopmentList>? arrDeveloperList = [];

  @override
  void initState() {
    super.initState();

    getDeveloperhList();
  }

  _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getDeveloperhList() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeDataResModel> info = httpService.homeData(widget.curCategory == 0 ? "home" : "monitor");
    info.then((HomeDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrDeveloperList = value.data!.developmentList;
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
              H20(text: LanguageService.trans('growth_store_home1')),
              InkWell(
                  onTap: () {
                    eventBus.fire(MoreHomeCareEvent(type: 1));
                  },
                  child: H14(
                    text: LanguageService.trans('view_more'),
                    weight: FW.medium,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 406,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: arrDeveloperList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: ItemDevelopment(info: arrDeveloperList!.elementAt(index)),
                    onTap: () {
                      String _link = arrDeveloperList!.elementAt(index).videoLink!;
                      if (_link == "") {
                        showToast("비디오링크가 존재하지 않습니다.");
                      }
                      //_launchURL(_link);
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => ProductDetail(
                        pid: arrDeveloperList!.elementAt(index).id!,
                      )));
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
