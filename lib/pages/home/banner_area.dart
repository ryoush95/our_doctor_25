import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/home_banner_model.dart';
import 'package:ourdoctor/models/monitoring/solution_area_model.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerArea extends StatefulWidget {
  const BannerArea({Key? key}) : super(key: key);

  @override
  State<BannerArea> createState() => _BannerAreaState();
}

class _BannerAreaState extends State<BannerArea> {
  final HttpService httpService = HttpService();
  PageController pageController = PageController();
  int position = 0;
  List<BannerDto> bannerList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBannerList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  Future<void> getBannerList() async {
    Future<HomeBannerModel> info = httpService.getBanner();
    await info.then((HomeBannerModel value) async {
      if (value.result == 0) {
        setState(() {
          bannerList = value.data!.values.toList();
        });
      } else {
        if (value.result != 106) {
          showToast(value.msg ?? "");
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Widget bannerItem() {
    var screen = MediaQuery.of(context).size;
    return PageView.builder(
      controller: pageController,
      itemCount: bannerList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            final ban = bannerList[index];
            if(ban.type == "url") {
              launch(ban.url!);
            } else if (ban.type == "community") {
              Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: ban.uid!),));
            } else if (ban.type == "product") {
              Navigator.push(context, SlideRightTransRoute(builder: (context) => ProductDetail(pid: ban.uid!),));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: bannerList[index].imgUrl!,
              width: screen.width,
              height: screen.width / 2,
              fit: BoxFit.fill,
              progressIndicatorBuilder:
                  (context, url, downloadProgress) => Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress)),
            ),
          ),
        );
      },
      onPageChanged: (i) {
        setState(() {
          position = i;
        });
      },
    );
  }

  _dotIndicator() {
    // List _items = [mData.mainImage!, mData.mainImage!];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DotsIndicator(
        dotsCount: bannerList.length,
        position: position.toDouble(),
        decorator: DotsDecorator(
          color: const Color(0xFF000000).withOpacity(0.12), // Inactive color
          activeColor: AppColor_Primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            width: screen.width - 10,
            height: screen.width / 2 - 10,
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: AppColor_Light_Gray,
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
              ),
            ]),
            child: bannerList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : bannerItem()),
        bannerList.isEmpty ? const SizedBox() : Center(child : _dotIndicator()),
      ],
    );
  }
}
