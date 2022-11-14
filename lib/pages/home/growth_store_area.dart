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
import 'package:ourdoctor/pages/home/item_growth.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';

class GrowthStoreArea extends StatefulWidget {
  GrowthStoreArea({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;

  @override
  GrowthStoreAreaState createState() => GrowthStoreAreaState();
}

class GrowthStoreAreaState extends BaseState<GrowthStoreArea> {
  final HttpService httpService = HttpService();
  List<GrowthList>? arrGrowthList = [];

  @override
  void initState() {
    super.initState();

    getGrowthList();
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getGrowthList() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeDataResModel> info = httpService.homeData(widget.curCategory == 0 ? "home" : "monitor");
    info.then((HomeDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrGrowthList = value.data!.growthList;
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
              H20(text: LanguageService.trans('growth_store_home')),
              InkWell(
                  onTap: () {
                    Provider.of<ConvertScoreProvider>(context, listen: false).changeCareTab(0);
                    eventBus.fire(MoreHomeCareEvent(type: 0));
                  },
                  child: H14(
                    text: LanguageService.trans('view_more'),
                    weight: FW.medium,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 230,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: arrGrowthList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: ItemGrowth(info: arrGrowthList!.elementAt(index)),
                    onTap: () async {
                      String recv = await Navigator.push(context, SlideRightTransRoute(builder: (context) => ProductDetail(
                          pid: arrGrowthList!.elementAt(index).id!,
                        )));
                      if (recv != "") {
                        arrGrowthList!.elementAt(index).liked = recv;
                        setState(() {});
                      }
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
