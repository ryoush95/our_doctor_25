import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/solution_area_model.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/home/school_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:url_launcher/url_launcher.dart';

class SolutionArea extends StatefulWidget {
  const SolutionArea({Key? key}) : super(key: key);

  @override
  State<SolutionArea> createState() => _SolutionAreaState();
}

class _SolutionAreaState extends State<SolutionArea> {
  final HttpService httpService = HttpService();
  SolutionAreaDto data = SolutionAreaDto(communityUid: "201", imgUrl: "",title: "솔루션1",type: "community", url: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getSolution() async {
    Future<SolutionAreaModel> info = httpService.getSolutionArea();
    info.then((value) async {

      if (value.result == 0) {
        //input
        data = value.data!;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 306,
      width: MediaQuery.of(context).size.width - 50,
      // margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: AppColor_White,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: AppColor_Light_Gray,
              blurRadius: 3.0, // soften the shadow
              spreadRadius: 4.0, //extend the shadow
            )
          ]),
      child: Column(
        children: [
          const SizedBox(height: 20),
          H16(text: "솔루션 추천"),
          // SchoolArea(curCategory: 2),//교육
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if(data.type == "community") {
                      Navigator.push(context, SlideRightTransRoute(builder:
                      (context) => CommunityDetailPage(uid: data.communityUid),));
                    } else {
                      launch(data.url!);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                          child: Image.asset("assets/icon_good.png",width: 84, height: 84, fit: BoxFit.fill,),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 150,
                          child: H18(
                            text: data.title!,
                            weight: FW.regular,
                            maxLine: 2,
                            align: TextAlign.center,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },),
          ),
        ],
      ),
    );
  }
}