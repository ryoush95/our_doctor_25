import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/ask_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/ask_add.dart';
import 'package:sprintf/sprintf.dart';

class AskHistoryPage extends StatefulWidget {
  @override
  AskHistoryPageState createState() => AskHistoryPageState();
}

class AskHistoryPageState extends BaseState<AskHistoryPage> {
  final HttpService httpService = HttpService();
  bool isLast = true;
  int nPage = 0;
  List<AskDto> arrAskHistoryList = [];

  //리스트뷰 컨트롤러
  late ScrollController controller;

  @override
  void initState() {
    super.initState();

    controller = ScrollController()..addListener(_scrollListener);
    getAskHistoryList();

    eventBus.on<AddAskEvent>().listen((event) {
      if (mounted) {
        nPage = 0;
        getAskHistoryList();
      }
    });
  }

  //page 더보기
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getAskHistoryList();
      }
    }
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  Future<void> goWrite() async {
    Navigator.push(context, SlideRightTransRoute(builder: (context) => AddAskPage()));
  }

  Widget _getTiles(int index) {
    AskDto info = arrAskHistoryList.elementAt(index);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColor_Light_Gray,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 10),
                      child: H16(
                        text: info.title!,
                        weight: FW.semi_bold,
                        maxLine: 100,
                        align: TextAlign.left,
                        color: AppColor_BlackText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Visibility(
                    visible: info.answer! != "",
                    child: Image.asset(
                      'assets/ic_radio_on.png',
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: H14(
                  text: info.answer! == "" ? sprintf("%s %s", [LanguageService.trans("waiting_for_reply"),diffTime(info.regTime!)]) : sprintf("%s %s", [LanguageService.trans("answer_finish"),diffTime(info.regTime!)]),
                  weight: FW.medium,
                  align: TextAlign.left,
                  color: AppColor_BlackText.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 37),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: H16(
                  text: info.content!,
                  weight: FW.regular,
                  maxLine: 100,
                  align: TextAlign.left,
                  color: AppColor_BlackText,
                ),
              ),
              Visibility(
                visible: info.imgUrl != "",
                child: Container(
                  margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      info.imgUrl!,
                      width: MediaQuery.of(context).size.width - 104,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: info.answer! != "",
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          H14(
                            text: LanguageService.trans("app_name"),
                            weight: FW.semi_bold,
                            align: TextAlign.left,
                            color: AppColor_Primary,
                          ),
                          const SizedBox(width: 8),
                          H12(
                            text: info.answer! == "" ? "" : diffTime(info.answerTime!),
                            weight: FW.medium,
                            align: TextAlign.left,
                            color: AppColor_BlackText.withOpacity(0.4),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: H14(
                          text: info.answer!,
                          weight: FW.regular,
                          maxLine: 100,
                          align: TextAlign.left,
                          color: AppColor_BlackText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 8,
        ),
      ],
    );
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getAskHistoryList() async {
    setState(() {
      isLoading = true;
    });

    Future<AskListResModel> info = httpService.askList(nPage);
    info.then((AskListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (nPage == 0 && arrAskHistoryList.isNotEmpty) {
          arrAskHistoryList.clear();
        }
        isLast = value.data!.isLast!;
        arrAskHistoryList.addAll(value.data!.contents!);
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

  //////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SimpleHeader(
                    title: LanguageService.trans("inquiry"),
                    onBackPressed: onBackPressed,
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Stack(
                          children: [
                            Visibility(
                              visible: arrAskHistoryList.isNotEmpty,
                              child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                controller: controller,
                                itemBuilder: (BuildContext context, int index) {
                                  return _getTiles(index);
                                },
                                itemCount: arrAskHistoryList.length,
                              ),
                            ),
                            Visibility(
                              visible: arrAskHistoryList.isEmpty,
                              child: Center(
                                child: H16(
                                  text: LanguageService.trans("no_inquiry"),
                                  color: AppColor_BlackText.withOpacity(0.4),
                                  weight: FW.regular,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
              child: InkWell(
                onTap: goWrite,
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    highlightElevation: 0,
                    focusElevation: 0,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: const CircleBorder(),
                    onPressed: goWrite,
                    child: Image.asset("assets/ic_com_write.png"),
                  ),
                ),
              ),
              right: 12,
              bottom: 12,
            )
          ],
        ));
  }
}
