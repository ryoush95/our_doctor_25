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
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CommunityDetailPage extends StatefulWidget {
  CommunityDetailPage({Key? key, required this.uid, this.videoUrl,}) : super(key: key);

  String? uid;
  String? videoUrl;

  @override
  CommunityDetailPageState createState() => CommunityDetailPageState();
}

class CommunityDetailPageState extends BaseState<CommunityDetailPage> {
  final HttpService httpService = HttpService();

  CommunityDetailDto? dicDetailInfo;
  final replyController = TextEditingController();
  late FocusNode replyFocusNode;
  String replyContent = "";
  int replyCnt = 0;
  String parentUid = "0";
  int nPage = 0;
  bool isLast = true;
  List<ReplyDto> arrReplyList = [];
  bool _editReply = false;
  late String _prevContent;
  late String _editUid;

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
    _initYotubeController();
    controller = ScrollController()..addListener(_scrollListener);
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

  _initYotubeController() {
    if (widget.videoUrl != '' && widget.videoUrl != null) {
      final videoId = convertUrlToId(widget.videoUrl!);
      _videoController = YoutubePlayerController(
          initialVideoId: videoId,
          params: const YoutubePlayerParams(
            autoPlay: true,
            showControls: true,
            showFullscreenButton: true,
            desktopMode: false,
            mute: true,
          ));

      _videoController?.onEnterFullscreen = () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };

      _videoController?.onExitFullscreen = () {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      };
    }
  }

  //page 더보기
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getReplyList();
      }
    }
  }

  Future<bool> onBackPressed() async {
    Map obj = Map();
    obj["code"] = "300";
    obj["like"] = dicDetailInfo!.likeCnt!.toString();
    obj["comment"] = replyCnt.toString();
    Navigator.pop(context, obj);
    return true;
  }

  void viewMore() {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    if (dicDetailInfo!.userUid! == gUserInfo!.id) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ActionSheet(
                action1: LanguageService.trans('to_edit'),
                action2: LanguageService.trans('to_delete'),
                onAction1: () {
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => AddCommunityPage(
                              uid: widget.uid, info: dicDetailInfo)));
                },
                onAction2: () {
                  reqCommunityDel();
                });
          });
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ActionSheet1(
                action: LanguageService.trans('report'),
                onAction: () {
                  //FIXME: report
                  // onClickReport();
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => ReportPage(
                                uid: widget.uid.toString(),
                                writer: dicDetailInfo!.nickname!,
                                title: dicDetailInfo!.title!,
                              )));
                });
          });
    }
  }

  // void onClickReport() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return ReportDialog(
  //         onOk: (report) {
  //           if (report == '') {
  //             showToast(LanguageService.trans('msg_enter_report'));
  //             return;
  //           }
  //           Navigator.of(context).pop();
  //           reqReport("community", widget.uid!, report);
  //         },
  //       );
  //     },
  //   );
  // }

  //댓글 더보기
  void viewReplyMore(ReplyDto info, int index) {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    if (info.id == gUserInfo!.id) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ActionSheet(
                action1: LanguageService.trans('add_reply_reply'),
                action2: LanguageService.trans('to_delete'),
                action3: LanguageService.trans('edit_reply_reply'),
                onAction1: () {
                  parentUid = info.commentUid!;
                  replyFocusNode.requestFocus();
                },
                onAction2: () {
                  reqCommentDel(info.commentUid!, index);
                },
                onAction3: () {
                  _prevContent = info.content!;
                  _editUid = info.commentUid!;
                  _editReply = true;
                  setState(() {});
                });
          });
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ActionSheet(
                action1: LanguageService.trans('add_reply_reply'),
                action2: LanguageService.trans('report'),
                onAction1: () {
                  parentUid = info.commentUid!;
                  replyFocusNode.requestFocus();
                },
                onAction2: () {
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => ReportPage(
                                uid: info.commentUid.toString(),
                                writer: info.nickname!,
                                title: info.content!,
                                comment: true,
                              )));
                  // onClickReplyReport(info.commentUid!);
                });
          });
    }
  }

  //댓글 수정
  void _editComment(String uid, String content) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (content == "") {
      showToast(LanguageService.trans("input_reply_hint"));
      return;
    }

    isLoading = true;
    setState(() {});

    Future<DefaultResModel> info = httpService.commentEdit(uid, content);
    info.then((DefaultResModel value) {
      isLoading = false;
      setState(() {});

      if (value.result == 0) {
        showToast(LanguageService.trans("edit_reply"));
        clearInfo();
        getReplyList();
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          // token expiration.
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      isLoading = false;
      setState(() {});
      showToast(onError);
      clearInfo();
    });
  }

  clearInfo() {
    replyContent = "";
    replyController.clear();
    _prevContent = "";
    _editUid = "";
    _editReply = false;
  }

  // void onClickReplyReport(String uid) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return ReportDialog(
  //         onOk: (report) {
  //           if (report == '') {
  //             showToast(LanguageService.trans('msg_enter_report'));
  //             return;
  //           }
  //           Navigator.of(context).pop();
  //           reqReport("comment", uid, report);
  //         },
  //       );
  //     },
  //   );
  // }

  //대댓글 더보기
  void viewReplyReplyMore(ReplyReplyDto info, int pIdx, int cIdx) {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    if (info.id == gUserInfo!.id) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ActionSheet1(
                action: LanguageService.trans('to_delete'),
                action2: LanguageService.trans("edit_reply_reply"),
                onAction: () {
                  reqReplyCommentDel(info.commentUid!, pIdx, cIdx);
                },
                onAction2: () {
                  _prevContent = info.content!;
                  _editUid = info.commentUid!;
                  _editReply = true;
                  setState(() {});
                });
          });
    } else {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return ActionSheet1(
                action: LanguageService.trans('report'),
                onAction: () {
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => ReportPage(
                                uid: info.commentUid.toString(),
                                writer: info.nickname!,
                                title: info.content!,
                                comment: true,
                              )));
                  // onClickReplyReport(info.commentUid!);
                });
          });
    }
  }

  String getMaskName(String name) {
    if (name.length < 2) {
      return name;
    }

    String first = name[0];
    String last = name.substring(name.length - 1);
    String mask = "";
    for (int i = 0; i < name.length - 2; i++) {
      mask = mask + "*";
    }

    return first + mask + last;
  }

  Widget _getTiles(int index) {
    ReplyDto info = arrReplyList.elementAt(index);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H14(
                        text: info.delYn == "y"
                            ? LanguageService.trans("deleted_comment")
                            : info.content!,
                        weight: FW.regular,
                        maxLine: 100,
                        color: AppColor_BlackText,
                        align: TextAlign.left,
                        height: 1.3,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Visibility(
                            visible: info.userType != "normal",
                            child: Column(
                              children: [
                                Image.asset('assets/ic_small_notice.png',
                                    width: 12, height: 12),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          H12(
                            //text: info.userType != "normal" ? info.name! : getMaskName(info.name!) + " : " + diffTime(info.regTime!),
                            text: info.nickname! +
                                " ・ " +
                                diffTime(info.regTime!),
                            weight: FW.medium,
                            color: AppColor_BlackText.withOpacity(0.4),
                            align: TextAlign.left,
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              reqReplyLike(info.commentUid!, index, -1);
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  info.likeYn == "n"
                                      ? 'assets/ic_like_off.png'
                                      : 'assets/ic_like_on.png',
                                  width: 20,
                                ),
                                const SizedBox(width: 5),
                                H14(
                                  text: info.likeCnt!,
                                  color: AppColor_BlackText.withOpacity(0.4),
                                  weight: FW.regular,
                                  align: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  viewReplyMore(info, index);
                },
                child: Image.asset(
                  'assets/ic_more_reply.png',
                  width: 20,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: AppColor_Selector_Border,
        ),
        Visibility(
          visible: info.replyList != null && info.replyList!.isNotEmpty,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int idx) {
              if (arrReplyList
                      .elementAt(index)
                      .replyList!
                      .elementAt(idx)
                      .delYn ==
                  'y') {
                return const SizedBox();
              } else {
                return _getReplyTiles(index, idx);
              }
            },
            itemCount: (info.replyList == null || info.replyList!.isEmpty)
                ? 0
                : info.replyList!.length,
          ),
        ),
      ],
    );
  }

  Widget _getReplyTiles(int parentIdx, int childIdx) {
    ReplyReplyDto info =
        arrReplyList.elementAt(parentIdx).replyList!.elementAt(childIdx);
    String _parentNickname =
        arrReplyList.elementAt(parentIdx).nickname.toString();
    return Column(
      children: [
        Container(
          color: AppColor_Light_Gray,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20, left: 45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H12(
                        text: '@$_parentNickname ',
                        weight: FW.regular,
                        maxLine: 100,
                        color: AppColor_BlackText.withOpacity(.4),
                        align: TextAlign.left,
                      ),
                      const SizedBox(height: 4),
                      H14(
                        text: info.content!,
                        weight: FW.regular,
                        maxLine: 100,
                        color: AppColor_BlackText,
                        align: TextAlign.left,
                        height: 1.3,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Visibility(
                            visible: info.userType != "normal",
                            child: Column(
                              children: [
                                Image.asset('assets/ic_small_notice.png',
                                    width: 12, height: 12),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          H12(
                            //text: info.userType != "normal" ? info.name! : getMaskName(info.name!) + " : " + diffTime(info.regTime!),
                            text: info.nickname! +
                                " ・ " +
                                diffTime(info.regTime!),
                            weight: FW.medium,
                            color: AppColor_BlackText.withOpacity(0.4),
                            align: TextAlign.left,
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              reqReplyLike(
                                  info.commentUid!, parentIdx, childIdx);
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  info.likeYn == "n"
                                      ? 'assets/ic_like_off.png'
                                      : 'assets/ic_like_on.png',
                                  width: 20,
                                ),
                                const SizedBox(width: 5),
                                H14(
                                  text: info.likeCnt!,
                                  color: AppColor_BlackText.withOpacity(0.4),
                                  weight: FW.regular,
                                  align: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  viewReplyReplyMore(info, parentIdx, childIdx);
                },
                child: Image.asset(
                  'assets/ic_more_reply.png',
                  width: 20,
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        Container(
          height: 1,
          color: AppColor_Selector_Border,
        ),
      ],
    );
  }

  String getTopicName(String topic) {
    String result = "";
    if (topic == "notice") {
      result = "공지/이벤트";
    } else if (topic == "treatment") {
      result = "뉴스";
    } else if (topic == "school") {
      result = "교육";
    } else if (topic == "faq") {
      result = "질문";
    } else if (topic == "talk") {
      result = "자유게시판";
    } else {
      result = "우아팁";
    }

    return result;
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
          fit: BoxFit.fill,
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
        replyCnt = int.parse(dicDetailInfo!.commentCnt!);
        setState(() {});
        getReplyList();
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

  //커뮤니티 좋아요
  void reqCommunityLike() {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.communityLike(widget.uid!);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        getCommunityDetail();
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

  //댓글 추가
  void reqCommentAdd() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (replyContent == "") {
      showToast(LanguageService.trans("input_reply_hint"));
      return;
    }
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info =
        httpService.commentAdd(widget.uid!, parentUid, replyContent);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("add_reply"));
        replyContent = "";
        parentUid = "0";
        replyController.text = "";
        replyCnt = replyCnt + 1;

        nPage = 0;
        getReplyList();
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

  //댓글 삭제
  void reqCommentDel(String uid, int index) {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.commentDel(uid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("del_reply"));
        getCommunityDetail();
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

  //대댓글 삭제
  void reqReplyCommentDel(String uid, int pidx, int cIdx) {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.commentDel(uid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("del_reply"));
        replyCnt = replyCnt - 1;
        arrReplyList.elementAt(pidx).replyList!.removeAt(cIdx);
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

  //커뮤니티 삭제
  void reqCommunityDel() {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.communityDel(widget.uid!);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("del_community"));
        Map obj = Map();
        obj["code"] = "200";
        Navigator.pop(context, obj);
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

  //신고하기
  void reqReport(String type, String uid, String content) {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.report(type, uid, content);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("msg_report_success"));
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

  //댓글 리스트
  void getReplyList() {
    setState(() {
      isLoading = true;
    });

    Future<CommentListResModel> info =
        httpService.commentList(widget.uid!, nPage);
    info.then((CommentListResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0) {
          arrReplyList.clear();
        }
        arrReplyList.addAll(value.data!.contents!);
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

  //댓글 좋아요
  void reqReplyLike(String uid, int pIndex, int sIndex) {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.replyLike(uid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (sIndex == -1) {
          //댓글 좋아요
          int count = 0;
          String likeYn = arrReplyList.elementAt(pIndex).likeYn!;
          if (likeYn == "n") {
            arrReplyList.elementAt(pIndex).likeYn = "y";
            count = int.parse(arrReplyList.elementAt(pIndex).likeCnt!) + 1;
          } else {
            arrReplyList.elementAt(pIndex).likeYn = "n";
            count = int.parse(arrReplyList.elementAt(pIndex).likeCnt!) - 1;
          }
          arrReplyList.elementAt(pIndex).likeCnt = count.toString();
          setState(() {});
        } else {
          //대대슬 좋아요
          int count = 0;
          String likeYn = arrReplyList
              .elementAt(pIndex)
              .replyList!
              .elementAt(sIndex)
              .likeYn!;
          if (likeYn == "n") {
            arrReplyList.elementAt(pIndex).replyList!.elementAt(sIndex).likeYn =
                "y";
            count = int.parse(arrReplyList
                    .elementAt(pIndex)
                    .replyList!
                    .elementAt(sIndex)
                    .likeCnt!) +
                1;
          } else {
            arrReplyList.elementAt(pIndex).replyList!.elementAt(sIndex).likeYn =
                "n";
            count = int.parse(arrReplyList
                    .elementAt(pIndex)
                    .replyList!
                    .elementAt(sIndex)
                    .likeCnt!) -
                1;
          }
          arrReplyList.elementAt(pIndex).replyList!.elementAt(sIndex).likeCnt =
              count.toString();
          setState(() {});
        }
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          GestureDetector(
                            onTap: () {
                              viewMore();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              child: Image.asset(
                                'assets/ic_more.png',
                                width: 25,
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
                                child: Row(
                                  children: [
                                    H12(
                                      text: dicDetailInfo == null
                                          ? ""
                                          : getTopicName(dicDetailInfo!.topic!),
                                      color: AppColor_Primary,
                                      weight: FW.bold,
                                      align: TextAlign.left,
                                    ),
                                    const SizedBox(width: 5),
                                    Visibility(
                                      visible: (dicDetailInfo != null &&
                                          dicDetailInfo!.secret == "1"),
                                      child: Image.asset(
                                        'assets/ic_lock.png',
                                        width: 18,
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 9),
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
                              child: H14(
                                  text: dicDetailInfo?.content ?? "",
                                  maxLine: 150,
                                  weight: FW.regular,
                                  align: TextAlign.start,
                                  height: 1.3),
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
                            dicDetailInfo?.blogUrl != null &&
                                    dicDetailInfo?.blogUrl != "" &&
                                    dicDetailInfo?.topic != "team"
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        H14(
                                          text:
                                              '▶︎ ${LanguageService.trans('more_details')}',
                                          weight: FW.regular,
                                          align: TextAlign.start,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Linkify(
                                            onOpen: (link) {
                                              Navigator.push(
                                                  context,
                                                  SlideRightTransRoute(
                                                      builder: (context) =>
                                                          WooStoryWebView(
                                                              url: link.url)));
                                            },
                                            text: dicDetailInfo!.blogUrl!
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Visibility(
                              visible: dicDetailInfo != null &&
                                  dicDetailInfo!.topic! != "life",
                              child: Container(
                                width: 120,
                                height: 52,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: InkWell(
                                  onTap: reqCommunityLike,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        (dicDetailInfo == null ||
                                                dicDetailInfo!.likeYn == "n")
                                            ? 'assets/ic_like_off.png'
                                            : 'assets/ic_like_on.png',
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      H14(
                                        text: dicDetailInfo == null
                                            ? ""
                                            : dicDetailInfo!.likeCnt!,
                                        color:
                                            AppColor_BlackText.withOpacity(0.4),
                                        weight: FW.regular,
                                        align: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 8,
                              color: AppColor_Selector_Border,
                            ),
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                children: [
                                  H14(
                                    text: LanguageService.trans('reply'),
                                    color: AppColor_BlackText,
                                    weight: FW.regular,
                                    align: TextAlign.left,
                                  ),
                                  const SizedBox(width: 5),
                                  H14(
                                    text: replyCnt.toString(),
                                    color: AppColor_BlackText,
                                    weight: FW.regular,
                                    align: TextAlign.left,
                                  ),
                                  Expanded(child: Container()),
                                  InkWell(
                                    onTap: () {
                                      nPage = 0;
                                      getReplyList();
                                    },
                                    child: Image.asset(
                                      'assets/ic_rerfresh.png',
                                      width: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: AppColor_BlackText.withOpacity(0.1),
                            ),
                            Visibility(
                              visible: arrReplyList.isEmpty,
                              child: SizedBox(
                                height: 150,
                                child: Center(
                                  child: H14(
                                    text: LanguageService.trans('no_reply'),
                                    color: AppColor_BlackText.withOpacity(0.4),
                                    weight: FW.regular,
                                    align: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: arrReplyList.isNotEmpty,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: controller,
                                itemBuilder: (BuildContext context, int index) {
                                  final list = arrReplyList[index];
                                  if (list.delYn == 'y' &&
                                      list.replyList!.isEmpty) {
                                    return const SizedBox();
                                  } else if (list.delYn == 'y' &&
                                      list.replyList!.isNotEmpty) {
                                    final result = list.replyList!
                                        .where((e) => e.delYn == 'n');
                                    if (result.isNotEmpty) {
                                      return _getTiles(index);
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return _getTiles(index);
                                  }
                                },
                                itemCount: arrReplyList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    color: AppColor_Primary.withOpacity(0.05),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              //FIXME: 댓글 수정
                              input(_editReply),
                              btnAdd(_editReply),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  input(bool edit) => Expanded(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            focusNode: replyFocusNode,
            controller: replyController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            // textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: edit
                  ? _prevContent
                  : LanguageService.trans("input_reply_hint"),
              counterText: "",
              border: InputBorder.none,
              hintStyle: AppTextStyle.PD(AppColor_Hint, 14, weight: FW.regular),
              suffixIcon: replyController.text.length > 0
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        replyController.clear();
                        replyContent = '';
                        setState(() {});
                      },
                      child: const Icon(Icons.clear_rounded,
                          color: AppColor_Icon, size: 16),
                    )
                  : const SizedBox(),
            ),
            onChanged: (text) {
              replyContent = text;
              setState(() {});
            },
          ),
        ),
      );

  btnAdd(bool edit) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (edit) {
            if (replyController.text.length > 0) {
              _editComment(_editUid, replyContent);
            } else {
              _editReply = false;
              clearInfo();
              setState(() {});
            }
          } else {
            reqCommentAdd();
          }
          // edit ? _editComment(_editUid, replyContent) : reqCommentAdd();
        },
        child: SizedBox(
          width: 50,
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.centerRight,
            child: H14(
              text: edit
                  ? replyController.text.length > 0
                      ? LanguageService.trans('edit')
                      : LanguageService.trans('cancel1')
                  : LanguageService.trans('input'),
              color: edit
                  ? replyController.text.length > 0
                      ? AppColor_Primary
                      : AppColor_Red
                  : AppColor_Primary,
              weight: FW.medium,
              align: TextAlign.right,
            ),
          ),
        ),
      );
}
