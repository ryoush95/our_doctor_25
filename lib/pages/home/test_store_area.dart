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
import 'package:ourdoctor/pages/care/product_list.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/home/item_growth.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';

import 'item_test.dart';

class TestStoreArea extends StatefulWidget {
  TestStoreArea({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;

  @override
  TestStoreAreaState createState() => TestStoreAreaState();
}

class TestStoreAreaState extends BaseState<TestStoreArea> {
  final HttpService httpService = HttpService();
  List<TestList>? arrTestList = [];

  @override
  void initState() {
    super.initState();

    getTestList();
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getTestList() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeDataResModel> info = httpService.homeData("home");
    info.then((HomeDataResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        arrTestList = value.data!.testList;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 230,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: arrTestList!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: ItemTest(info: arrTestList!.elementAt(index)),
                  onTap: () async {
                    Provider.of<ConvertScoreProvider>(context, listen: false).changeCareTab(2);
                    eventBus.fire(MoreHomeCareEvent(type: 0));
                  },
                );
              }),
        )
      ],
    );
  }
}
