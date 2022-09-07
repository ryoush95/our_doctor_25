import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/date_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/active_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/final_result_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_main.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_result.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_start.dart';
import 'package:ourdoctor/pages/my/ask_history.dart';

class AlarmPage extends StatefulWidget {
  AlarmPage({Key? key, required this.type}) : super(key: key);
  int? type;

  @override
  AlarmPageState createState() => AlarmPageState();
}

class AlarmPageState extends BaseState<AlarmPage> {
  ScrollController scrollController = ScrollController();
  int nTabIndex = 0;
  bool isLast = false;
  int page = 0;
  final HttpService httpService = HttpService();
  List<ActiveDto>? arrAlarmList = [];
  FinalresultDto? dicInfo;

  @override
  void initState() {
    super.initState();
    nTabIndex = widget.type!;
    scrollController = ScrollController()..addListener(loadMore);
    getAlarmList();
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    page = 0;
    getAlarmList();
  }

  void loadMore() {
    if (!isLoading) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        page = page + 1;
        getAlarmList();
      }
    }
  }

  String getTypeName(ActiveDto info) {
    String type = info.notificationType!;
    String result = "";
    if (type == "notice_start") {
      result = "welcome";
    } else if (type == "notice_monitor") {
      result = "공지";
    } else if (type == "monitor_result") {
      result = "공지";
    } else if (type == "notice_story") {
      result = "공지";
    } else if (type == "community_added") {
      //result = LanguageService.trans("community");
      result = "커뮤니티에 글이 등록되었습니다.";
    } else if (type == "reply_added") {
      //result = LanguageService.trans("rereply");
      result = "대댓글이 추가되었습니다.";
    } else if (type == "comment_added") {
      //result = LanguageService.trans("reply");
      result = "댓글이 추가되었습니다.";
    } else if (type == "ask_answer") {
      //result = LanguageService.trans("ask");
      result = "문의하신 질문에 답변이 등록되었습니다.";
    } else if (type == "order_complete") {
      result = "주문이 완료되었습니다.";
    }

    return result;
  }

  String getContent(ActiveDto info) {
    String result = "";
    String type = info.notificationType!;
    if (type == "notice_start") {
      result = info.description!;
    } else if (type == "notice_monitor") {
      result = info.description!;
    } else if (type == "monitor_result") {
      result = info.description!;
    } else if (type == "notice_story") {
      result = info.description!;
    } else if (type == "community_added") {
      result = info.description!;
    } else if (type == "reply_added") {
      result = info.description!;
    } else if (type == "comment_added") {
      result = info.description!;
    } else if (type == "ask_answer") {
      result = info.description!;
    } else if (type == "order_complete") {
      result = "주문이 완료되었어요.";
    }

    return result;
  }

  // 2022-01-14 06:36:39.000000 - > 2022.01.14
  String getDate(String date) {
    String result = "";
    String temp = date.substring(0, 10);
    result = temp.replaceAll("-", ".");

    return result;
  }

  void goDetailPage(ActiveDto info) {
    if (info.notificationType == "notice_start") {
      //회원등록page로 이행.
    } else if (info.notificationType == "notice_monitor") {
      //모니터시작page로 이행.
      getFinalResultInfo(true);
    } else if (info.notificationType == "monitor_result") {
      //모니터결과page로 이행.
      getFinalResultInfo(false);
    } else if (info.notificationType == "notice_story") {
      //faq 또는 storypage로 이행.
      Navigator.pop(context, "story");
    } else if (info.notificationType == "ask_answer") {
      //1 : 1 문의 page로 이행.
      Navigator.push(context, SlideRightTransRoute(builder: (context) => AskHistoryPage()));
    } else if (info.notificationType == "community_added") {
      if (info.data == "") {
        return;
      }
      Map<String, dynamic> data = json.decode(info.data!);
      String uid = data["uid"];
      if (uid == "") {
        return;
      }
      Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: uid)));
    } else if (info.notificationType == "reply_added") {
      if (info.data == "") {
        return;
      }
      Map<String, dynamic> data = json.decode(info.data!);
      String uid = data["uid"];
      if (uid == "") {
        return;
      }
      Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: uid)));
    } else if (info.notificationType == "comment_added") {
      if (info.data == "") {
        return;
      }
      Map<String, dynamic> data = json.decode(info.data!);
      String uid = data["uid"];
      if (uid == "") {
        return;
      }
      Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: uid)));
    } else if (info.notificationType == "order_complete") {
      /*
      if (info.data == "") {
        return;
      }
      Map<String, dynamic> data = json.decode(info.data!);
      int uid = fromJsonInt(data["uid"]);
      if (uid == 0) {
        return;
      }
      Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderSheetPage(orderId: uid.toString())));
       */
    }
  }

  void goMonitorStart() {
    /*
    var hour = DateTime.now().hour;
    var min = DateTime.now().minute;
    if (isMorning()) {
      if (hour < 9 || (hour > 10 && min > 0)) {
        showToast(LanguageService.trans('disable_am_time'));
        return;
      }
    } else {
      if (hour < 15 || (hour > 16 && min > 0)) {
        showToast(LanguageService.trans('disable_pm_time'));
        return;
      }
    }
    */
    if (dicInfo == null) {
      return;
    }
    String makeDate = getCurrentDate();
    DateTime now = DateTime.now();
    String makeTime = DateFormat('HH:mm:ss').format(now);
    dicWriteDto = MonitorWriteDto(uid: "", regDate: makeDate, regTime: makeTime, temperature: "", oxygen: "", heartCnt: "", symptom: "", pillUrl: "", speciality: "", stepTimes: "");
    if (dicInfo!.regtime! == "") {
      Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
      return;
    }

    String regtime = dicInfo!.regtime!;
    String oldDate = regtime.substring(0, 10);
    int oldHour = int.parse(regtime.substring(11, 13));
    String currentDate = getCurrentDate();
    if (oldDate != currentDate) {
      Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
    } else {
      var dt = DateTime.now();
      int curHour = dt.hour;
      if (curHour < 12) {
        //오전 시간
        if (oldHour < 12) {
          dicWriteDto!.uid = dicInfo!.uid!;
        }
        Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
      } else {
        //오후 시간
        if (oldHour > 12) {
          dicWriteDto!.uid = dicInfo!.uid!;
        }
        Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringStartPage()));
      }
    }
  }

  void goMonitorResult() {
    if (dicInfo == null) {
      return;
    }
    String makeDate = getCurrentDate();
    DateTime now = DateTime.now();
    String makeTime = DateFormat('HH:mm:ss').format(now);
    dicWriteDto =
        MonitorWriteDto(uid: dicInfo!.uid!, regDate: makeDate, regTime: makeTime, temperature: dicInfo!.temperature!, oxygen: dicInfo!.oxygen!, heartCnt: dicInfo!.heartCnt!, symptom: dicInfo!.symptom!, pillUrl: dicInfo!.pillUrl!, speciality: dicInfo!.speciality!, stepTimes: dicInfo!.stepTimes!);

    Navigator.push(context, SlideRightTransRoute(builder: (context) => MonitoringResultPage()));
  }

  String getImgName(ActiveDto info) {
    String result = "";
    if (nTabIndex == 0) {
      result = 'assets/ic_alarm.png';
    } else {
      if (info.notificationType == "community_added") {
        result = info.likeYn == "y" ? 'assets/ic_like_on.png' : 'assets/ic_like_off1.png';
      } else if (info.notificationType == "reply_added") {
        result = 'assets/ic_talk.png';
      } else if (info.notificationType == "comment_added") {
        result = 'assets/ic_talk.png';
      } else if (info.notificationType == "order_complete") {
        result = 'assets/ic_order_his.png';
      } else {
        result = 'assets/ic_talk.png';
      }
    }
    return result;
  }

  // Network functions
  //////////////////////////////////
  //활동리스트 얻기
  Future<void> getAlarmList() async {
    setState(() {
      isLoading = true;
    });

    Future<ActiveListResModel> info = httpService.activeList(page, nTabIndex);
    info.then((ActiveListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (page == 0 && arrAlarmList!.isNotEmpty) {
          arrAlarmList!.clear();
        }
        arrAlarmList!.addAll(value.data!.list!);
        isLast = value.data!.isLast!;
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

  //최종 모니터 정보 얻기
  Future<void> getFinalResultInfo(bool start) async {
    setState(() {
      isLoading = true;
    });

    Future<FinalResultResModel> info = httpService.finalResult();
    info.then((FinalResultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicInfo = value.data!;
        if (start) {
          goMonitorStart();
        } else {
          goMonitorResult();
        }
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

  //커뮤니티 좋아요
  void reqCommunityLike(String uid, int index) {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.communityLike(uid);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (arrAlarmList!.elementAt(index).likeYn == "y") {
          arrAlarmList!.elementAt(index).likeYn = "n";
        } else {
          arrAlarmList!.elementAt(index).likeYn = "y";
        }
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
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("alarm"),
              onBackPressed: onBackPressed,
            ),
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        nTabIndex = 0;
                        page = 0;
                        getAlarmList();
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          Center(
                            child: H14(
                              text: LanguageService.trans('notice1'),
                              weight: FW.medium,
                              align: TextAlign.center,
                              color: nTabIndex == 0 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                            ),
                          ),
                          Positioned(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: nTabIndex == 0 ? 2 : 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  color: AppColor_BlackText,
                                )),
                            bottom: 0,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        nTabIndex = 1;
                        page = 0;
                        getAlarmList();
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          Center(
                            child: H14(
                              text: LanguageService.trans('action'),
                              weight: FW.medium,
                              align: TextAlign.center,
                              color: nTabIndex == 1 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                            ),
                          ),
                          Positioned(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: nTabIndex == 1 ? 2 : 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  color: AppColor_BlackText,
                                )),
                            bottom: 0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: AppColor_Divider,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      ActiveDto info = arrAlarmList!.elementAt(index);
                      return InkWell(
                        onTap: () {
                          goDetailPage(info);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: H18(
                                    text: getTypeName(info),
                                  ),
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: () {
                                    if (info.notificationType == "community_added") {
                                      if (info.data == null || info.data == "") {
                                        return;
                                      }
                                      reqCommunityLike(info.data!, index);
                                    }
                                  },
                                  child: Image.asset(
                                    getImgName(info),
                                    width: 25,
                                  ),
                                ), // temp delete
                                const SizedBox(width: 30),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: H12(
                                text: getDate(info.createdAt!),
                                color: AppColor_Table_DateTime,
                                weight: FW.regular,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: H14(
                                //text: getContent(info),
                                text: info.description!,
                                color: AppColor_BlackText,
                                weight: FW.regular,
                                maxLine: 2,
                                align: TextAlign.start,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              // child: Html(
                              //   data: info.description,
                              // ),
                            ),
                            Container(
                              height: 10,
                              color: AppColor_Divider,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: arrAlarmList!.length),
              ),
            )
          ],
        ));
  }
}
