import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/home/item_news.dart';
import 'package:ourdoctor/pages/home/test_store_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';

import '../app_event.dart';
import 'item_community.dart';
import 'item_news.dart';

class WeatherArea extends StatefulWidget {
  WeatherArea({Key? key, this.curCategory = 0}) : super(key: key);
  int? curCategory;

  @override
  WeatherAreaState createState() => WeatherAreaState();
}

class WeatherAreaState extends BaseState<WeatherArea> {
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H20(text: '오늘의 건강 정보'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 84,
                    width: 84,
                    child: Image.asset('assets/home_temp.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text('기온', style: TextStyle(color: AppColor_GrayText)),
                  const SizedBox(height: 10),
                  H24B(
                    text: "30" + "°C",
                    color: AppColor_Red,
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 84,
                    width: 84,
                    child: Image.asset('assets/home_water.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text('습도', style: TextStyle(color: AppColor_GrayText)),
                  const SizedBox(height: 10),
                  H24B(
                    text: "30" + "%",
                    color: AppColor_Primary,
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 84,
                    width: 84,
                    child: Image.asset('assets/home_dust.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text('미세먼지', style: TextStyle(color: AppColor_GrayText)),
                  const SizedBox(height: 10),
                  H24B(
                    text: "좋음",
                    color: AppColor_Green,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
