import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/heath_result_model.dart';
import 'package:ourdoctor/models/monitoring/solution_area_model.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/home/school_area.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/models/monitor_development_list_model.dart';
import 'package:ourdoctor/provider/monitoring_note_profile_provider.dart';
import 'package:provider/provider.dart';

class SolutionArea extends StatefulWidget {
  const SolutionArea({Key? key}) : super(key: key);

  @override
  State<SolutionArea> createState() => _SolutionAreaState();
}

class _SolutionAreaState extends State<SolutionArea> {
  final HttpService httpService = HttpService();

  // SolutionAreaDto data = SolutionAreaDto(communityUid: "2072", imgUrl: "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/community/slide_images/2064/detail_CK_ta0111a1401_n.jpg",title: "솔루션1",type: "community", url: "");
  List<RecommendList> solList = [];

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<MonitoringNoteProfileProvider>(context, listen: false);
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
              itemCount: solList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (solList[index].type! == "community") {
                      Navigator.push(
                          context,
                          SlideRightTransRoute(
                            builder: (context) => CommunityDetailPage(
                                uid: solList[index].id),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          SlideRightTransRoute(
                            builder: (context) =>
                                ProductDetail(pid: solList[index].id!),
                          ));
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: CachedNetworkImage(
                            imageUrl: solList[index].imageUrl!,
                            width: 84,
                            height: 84,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 150,
                          child: H18(
                            text: solList[index].title!,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
