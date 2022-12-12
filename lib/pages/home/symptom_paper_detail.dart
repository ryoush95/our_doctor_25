import 'dart:developer' as developer;

import 'package:dots_indicator/dots_indicator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/convert_youtube_id.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/comment_list_res_model.dart';
import 'package:ourdoctor/models/community_detail_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout1.dart';
import 'package:ourdoctor/pages/community/community_add.dart';
import 'package:ourdoctor/pages/components/action_sheet.dart';
import 'package:ourdoctor/pages/components/action_sheet1.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/dialog/report.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:ourdoctor/pages/woo_story_webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SymptomPaperDetailPage extends StatefulWidget {
  SymptomPaperDetailPage({Key? key, this.uid = "2041", this.videoUrl,}) : super(key: key);

  String? uid;
  String? videoUrl;

  @override
  SymptomPaperDetailPageState createState() => SymptomPaperDetailPageState();
}

class SymptomPaperDetailPageState extends BaseState<SymptomPaperDetailPage> {
  final HttpService httpService = HttpService();

  CommunityDetailDto? dicDetailInfo;
  final replyController = TextEditingController();
  late FocusNode replyFocusNode;
  String parentUid = "0";
  bool isLast = true;
  List<ReplyDto> arrReplyList = [];

  //리스트뷰 컨트롤러
  late ScrollController controller;
  int _selectedImgIndex = 0;
  List<String> arrImgList = [];

  YoutubePlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    replyFocusNode = FocusNode();
    getCommunityDetail();
    eventBus.on<EditCommunityEvent>().listen((event) {
      if (mounted) {
        getCommunityDetail();
      }
    });
  }

  @override
  void dispose() {
    replyFocusNode.dispose();
    _videoController?.close();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Map obj = Map();
    obj["code"] = "300";
    obj["like"] = dicDetailInfo!.likeCnt!.toString();
    Navigator.pop(context, obj);
    return true;
  }

  List<String> getImgs() {
    if (dicDetailInfo == null || dicDetailInfo!.imgUrls!.isEmpty) {
      return [];
    }

    var imgUrls = dicDetailInfo!.imgUrls!;
    var lastChar = imgUrls.substring(imgUrls.length - 1, imgUrls.length);
    if (lastChar == ",") {
      imgUrls = imgUrls.substring(0, imgUrls.length - 1);
    }
    var arr = imgUrls.split(",");
    return arr;
  }

  // 타일
  Widget _getImgTiles(int index) {
    String img = arrImgList.elementAt(index);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () {
          if (arrImgList.length > 0) {
            Navigator.push(
                context,
                SlideRightTransRoute(
                    builder: (context) =>
                        PhotoViewPage(imgs: arrImgList, type: 0)));
          }
        },
        child: ExtendedImage.network(
          img,
          fit: BoxFit.contain,
          cache: true,
        ),
      ),
    );
  }

  // Network functions
  //////////////////////////////////
  //커뮤니티 상세정보 얻기
  void getCommunityDetail() {
    setState(() {
      isLoading = true;
    });

    Future<CommunityDetailResModel> info =
        httpService.communityDetail(widget.uid!);
    info.then((CommunityDetailResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (value.data!.uid == "") {
          showToast(LanguageService.trans("deleted_community"));
          Navigator.pop(context);
          return;
        }
        dicDetailInfo = value.data!;
        arrImgList = getImgs();
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
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout1(
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              child: Column(
                children: [
                  Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              onBackPressed();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              child: Image.asset(
                                'assets/path_12225.png',
                                width: 10,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: H18(
                                text: dicDetailInfo == null
                                    ? ""
                                    : dicDetailInfo!.title!,
                                color: AppColor_BlackText,
                                weight: FW.regular,
                                maxLine: 10,
                                align: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: H12(
                                text: dicDetailInfo == null
                                    ? ""
                                    : (dicDetailInfo!.nickname! +
                                        " ・ " +
                                        diffTime(dicDetailInfo!.regTime!)),
                                color: AppColor_BlackText.withOpacity(0.4),
                                weight: FW.medium,
                                align: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 1,
                              color: AppColor_BlackText.withOpacity(0.1),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                            ),
                            //NOTE: content
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              margin: EdgeInsets.only(top: 25),
                              child:
                              Linkify(text: dicDetailInfo?.content ?? "",
                              maxLines: 150,
                              textAlign: TextAlign.start,
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },),
                            ),

                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 25),
                            //   margin: const EdgeInsets.only(top: 20.0),
                            //   child: Linkify(
                            //     onOpen: (link) {
                            //       Navigator.push(context, SlideRightTransRoute(builder: (context) => WooStoryWebView(url: link.url)));
                            //     },
                            //     text: dicDetailInfo == null ? "" : dicDetailInfo!.content!,
                            //     maxLines: 150,
                            //   ),
                            // ),
                            // Visibility(
                            //   visible: dicDetailInfo != null && dicDetailInfo!. != "",
                            //   child: InkWell(
                            //     onTap: () {
                            //       if (dicDetailInfo == null || dicDetailInfo!.imgUrl!.isEmpty) {
                            //         return;
                            //       }
                            //       List<String> imgs = [];
                            //       imgs.add(dicDetailInfo!.imgUrl!);
                            //       Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: imgs, type: 0)));
                            //     },
                            //     child: Container(
                            //       width: MediaQuery.of(context).size.width - 60,
                            //       margin: const EdgeInsets.only(top: 30.0, left: 30, right: 30),
                            //       child: Image.network(
                            //         dicDetailInfo == null ? "" : dicDetailInfo!.imgUrl!,
                            //         width: MediaQuery.of(context).size.width - 60,
                            //         fit: BoxFit.fitWidth,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            //FIXME: youtube
                            widget.videoUrl != '' && widget.videoUrl != null
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                        bottom: 25,
                                        top: 30),
                                    child: YoutubePlayerIFrame(
                                      controller: _videoController,
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: arrImgList.length > 0
                                        ? MediaQuery.of(context).size.width - 50
                                        : 0,
                                    margin: const EdgeInsets.only(top: 30.0),
                                    child: StreamBuilder<Object>(
                                      stream: null,
                                      builder: (context, snapshot) {
                                        return Stack(
                                          children: <Widget>[
                                            PageView.builder(
                                              itemCount: arrImgList.length,
                                              controller: PageController(
                                                  viewportFraction: 1),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _getImgTiles(index);
                                              },
                                              onPageChanged: (int index) =>
                                                  setState(() =>
                                                      _selectedImgIndex =
                                                          index),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                            arrImgList.length > 1
                                ? Visibility(
                                    visible: arrImgList.isNotEmpty,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: Center(
                                        child: DotsIndicator(
                                          dotsCount: arrImgList.isEmpty
                                              ? 1
                                              : arrImgList.length,
                                          position:
                                              _selectedImgIndex.toDouble(),
                                          decorator: DotsDecorator(
                                            color: const Color(0xFF000000)
                                                .withOpacity(
                                                    0.12), // Inactive color
                                            activeColor:
                                                const Color(0xFF332A2F),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
