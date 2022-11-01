import 'dart:developer' as developer;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/community/community_add.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h12.dart'; 
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/noline_input.dart';
import 'package:ourdoctor/pages/components/text_highlighting.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';

class CommunityFragment extends StatefulWidget {
  @override
  CommunityFragmenttState createState() => CommunityFragmenttState();
}

class CommunityFragmenttState extends BaseState<CommunityFragment> {
  final HttpService httpService = HttpService();
  int nTabIndex = 0;
  int nSubTabIndex = 0;
  String keyword = "";
  bool _isSearching = false;
  bool isLast = true;
  int nPage = 0;
  List<CommunityDto> arrCommunityList = [];
  var keywordController = TextEditingController();
  final searchController = TextEditingController();
  bool _canClear = false;

  //리스트뷰 컨트롤러
  ScrollController controller = ScrollController();
  List<String> CATEGORYS = ["공지\n이벤트", "뉴스", "교육", "우아팁", "질문", "자유\n게시판"];
  List<String> subCategories = ["0-12개월", "13-36개월", "37-72개월", "초1-3학년", "초4-6학년"];
  String? _selection = "최신순";

  int age = 0;

  @override
  void initState() {
    super.initState();

    controller = new ScrollController()..addListener(_scrollListener);
    getCommunityList();

    eventBus.on<AddCommunityEvent>().listen((event) {
      if (mounted) {
        nPage = 0;
        getCommunityList();
      }
    });

    eventBus.on<EditCommunityEvent>().listen((event) {
      if (mounted) {
        nPage = 0;
        getCommunityList();
      }
    });

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        refresh();
      }
    });

    final now = DateTime.now();
    int nowy = now.year;
    int nowm = now.month;
    final birth = DateTime.parse(gSelChildInfo!.birth!);
    int birthy = birth.year;
    int birthm = birth.month;
    age = ((nowy-birthy) * 12) + (nowm - birthm);
    setState(() {
      if(age <= 12){
        nSubTabIndex = 0;
      } else if(age > 12 || 36 >= age){
        nSubTabIndex = 1;
      }else if(age > 37 || 72 >= age){
        nSubTabIndex = 2;
      }else if(age > 73 || 108 >= age){
        nSubTabIndex = 3;
      }else {
        nSubTabIndex = 4;
      }
    });
  }

  void moveScroll() {
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.jumpTo(0);
    });
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 200));
    nPage = 0;
    getCommunityList();
  }

  //page 더보기
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (isLast) {
          return;
        }
        nPage = nPage + 1;
        getCommunityList();
      }
    }
  }

  Future<void> goWrite() async {
    String topic = "";
    if (nTabIndex == 4) {
      topic = "질문";
    } else if (nTabIndex == 5) {
      topic = "자유게시판";
    }
    Navigator.push(context, SlideRightTransRoute(builder: (context) => AddCommunityPage(uid: "", topic: topic)));
  }

  Widget _getTiles(int index) {
    CommunityDto info = arrCommunityList.elementAt(index);
    String img = getImg(info);
    if (info.secret == "1") {
      return Column(
        children: [
          InkWell(
            onTap: () async {
              if (info.admin == "1" || gUserInfo!.id == info.userUid) {
                Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: info.uid)));
                String code = received["code"];
                if (code == "200") {
                  arrCommunityList.removeAt(index);
                  setState(() {});
                } else if (code == "300") {
                  info.likeCnt = received["like"];
                  info.commentCnt = received["comment"];
                  setState(() {});
                }
              } else {
                showToast("작성자와 우아닥터 관리자만 확인 가능해요.");
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: AppColor_Light_Gray,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Image.asset('assets/ic_lock.png', width: 18),
                  const SizedBox(width: 5),
                  H16(text: "비밀글입니다.", weight: FW.semi_bold, color: AppColor_BlackText),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          // arrCommunityList.length - 1 == index 
          // ? btnToLoadMore()
          // : const SizedBox(),
        ],
      );
    } else {
      final iText = info.title!;
      
      if(info.topic! != "notice" && keyword.isNotEmpty && iText.contains(keyword)) {
        final keywordIdx = iText.indexOf(keyword);
        final fText = iText.substring(0, keywordIdx);
        final keywordText = iText.substring(keywordIdx, keywordIdx + keyword.length);
        final sText = iText.substring(keywordIdx + keyword.length, iText.length);
      }

      return  info.topic! == "notice" && nTabIndex != 0
      ? const SizedBox()
      : Column(
        children: [
          InkWell(
            onTap: () async {
              // if(info.topic! != "notice" && keyword.isNotEmpty && info.title!.contains(keyword)) {
              //   final iText = info.title!;
              //   final keywordIdx = iText.indexOf(keyword);     
              //   final substringed = iText.substring(
              //     keywordIdx, keywordIdx + keyword.length
              //   );
              //   final fText = iText.substring(0, keywordIdx);
              //   final sText = iText.substring(keywordIdx+keyword.length, iText.length);
              //   developer.log('$fText $substringed $sText');
              // }
              final Map received;
              if(nTabIndex == 3) {
                received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: info.uid, videoUrl: info.blogUrl)));
              } else {
                received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => CommunityDetailPage(uid: info.uid,)));
              }
              String code = received["code"];
              if (code == "200") {
                arrCommunityList.removeAt(index);
                setState(() {});
              } else if (code == "300") {
                info.likeCnt = received["like"];
                info.commentCnt = received["comment"];
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: (info.topic! == "notice" || info.fixed == "1") ? AppColor_Primary.withOpacity(0.05) : AppColor_Light_Gray,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 20, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isSearching
                          ? DynamicTextHighlighting(
                            text: info.topic! == "notice" 
                              ? ("[공지/이벤트]" + info.title!) 
                              : info.title!, 
                            highlights: [keyword],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: (info.topic! == "notice" || info.fixed == "1") 
                                ? AppColor_Primary 
                                : AppColor_BlackText,
                              height: 1.1,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            color: AppColor_Yellow,
                          )
                          : _noticeTitle(info),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Visibility(
                                visible: info.admin == "1",
                                child: Image.asset('assets/ic_answer.png', width: 12),
                              ),
                              Visibility(
                                visible: info.admin == "1",
                                child: const SizedBox(width: 2),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  getcontent(info),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColor_BlackText.withOpacity(.4),
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  maxFontSize: 12,
                                  minFontSize: 8,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: img == "" ? false : true,
                    child: Container(
                      // width: img == "" ? 0 : 100,
                      width: img != "" && info.topic == "team"
                        ? 90 
                        : img == ""
                          ? 0 
                          : 60,
                      height: img == "" ? 0 : 60,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          img,
                          width: img == "" ? 0 : 60,
                          height: img == "" ? 0 : 60,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          // arrCommunityList.length - 1 == index 
          // ? btnToLoadMore()
          // : const SizedBox(),
        ],
      );
    }
  }

  Widget _getTiles1(int index) {
    double mWidth = (MediaQuery.of(context).size.width - 60) / 6;
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            keyword = '';
            _isSearching = false;
            searchController.clear();
            nTabIndex = index;
            // nSubTabIndex = 0;
            setState(() {
              if(age <= 12){
                nSubTabIndex = 0;
              } else if(age > 12 && 36 >= age){
                nSubTabIndex = 1;
              }else if(age > 37 && 72 >= age){
                nSubTabIndex = 2;
              }else if(age > 73 && 108 >= age){
                nSubTabIndex = 3;
              }else {
                nSubTabIndex = 4;
              }
            });
            nPage = 0;
            Provider.of<ConvertScoreProvider>(context, listen: false).changeTab(index);
            getCommunityList();
          });
        },
        child: SizedBox(
          width: mWidth,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: H14(
                  text: CATEGORYS[index],
                  weight: FW.medium,
                  align: TextAlign.center,
                  maxLine: 2,
                  color: nTabIndex == index ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                ),
              ),
              Positioned(
                child: SizedBox(
                    width: mWidth,
                    height: 2,
                    child: Container(
                      width: 80,
                      height: MediaQuery.of(context).size.width,
                      color: nTabIndex == index ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.1),
                    )),
                bottom: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTiles2(int index) {
    return GestureDetector(
          onTap: () {
            setState(() {
              nSubTabIndex = index;
              nPage = 0;
              _isSearching = false;
              getCommunityList();
            });
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            margin: const EdgeInsets.only(right: 8),        
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: nSubTabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
            child: H14(
                    text: subCategories[index],
                    weight: FW.medium,
                    align: TextAlign.center,
                    color: nSubTabIndex == index ? Colors.white : AppColor_BlackText.withOpacity(0.2),
                  ),
            ),
          );
  }

  String getcontent(CommunityDto info) {
    String result = "";

    if (info.topic! == "notice") {
      result = "우아닥터·" + diffTime(info.regTime!) + "·좋아요 " + info.likeCnt.toString() + "·댓글 " + info.commentCnt.toString();
    } else if (info.topic! == "life") {
      result = info.nickname! + "·" + diffTime(info.regTime!) + "·댓글 " + info.commentCnt.toString();
    } else {
      result = info.nickname! + "·" + diffTime(info.regTime!) + "·좋아요 " + info.likeCnt.toString() + "·댓글 " + info.commentCnt.toString();
    }
    return result;
  }

  String getImg(CommunityDto info) {
    if (info.imgUrls!.isEmpty) {
      return "";
    }

    var imgUrls = info.imgUrls!;
    var lastChar = imgUrls.substring(imgUrls.length - 1, imgUrls.length);
    if (lastChar == ",") {
      imgUrls = imgUrls.substring(0, imgUrls.length - 1);
    }
    var arr = imgUrls.split(",");
    if (arr.isNotEmpty) {
      if (arr[0] == "") {
        return "";
      } else {
        return arr[0];
      }
    }
    return "";
  }

  // Network functions
  //////////////////////////////////
  //홈 데이터 얻기
  Future<void> getCommunityList() async {
    setState(() {
      isLoading = true;
      nTabIndex = Provider.of<ConvertScoreProvider>(context, listen: false).tab;
    });
    String topic = "";
    String age = "";
    if (nTabIndex == 0) {
      topic = "notice";
    } else if (nTabIndex == 1) {
      topic = "treatment";
    } else if (nTabIndex == 2) {
      topic = "school";
      age = nSubTabIndex.toString();
    } else if (nTabIndex == 4) {
      topic = "faq";
      age = nSubTabIndex.toString();
    } else if (nTabIndex == 5) {
      topic = "talk";
    } else if (nTabIndex == 3) {
      topic = "team";
      age = nSubTabIndex.toString();
    }


    String sort = _selection == "좋아요순" ? "like" : "recent";

    Future<CommunityListResModel> info = httpService.communityList(keyword, nPage, topic, sort, age);
    info.then((CommunityListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        
        if (nPage == 0 && arrCommunityList.isNotEmpty) {
          arrCommunityList.clear();
        }
        isLast = value.data!.isLast!;
        arrCommunityList.addAll(value.data!.contents!);
        setState(() {});
        if (nPage == 0) {
          moveScroll();
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

  //////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return PageLayout(
        isLoading: isLoading,
        isAvoidResize: false,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 86,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H20(
                              text: LanguageService.trans('community'),
                              weight: FW.bold,
                              color: AppColor_BlackText,
                            ),
                            Container(
                              // width: 100,
                              height: 30,
                              child: Center(
                                child: DropdownButton<String>(
                                  value: _selection,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  underline: Container(height: 0),
                                  borderRadius: BorderRadius.circular(15),
                                  onChanged: (status) {
                                    //onChangeOrder(status!);
                                    _selection = status;
                                    setState(() {});
                                    refresh();
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      child: H14(text: "좋아요순",color: AppColor_Primary,),
                                      value: "좋아요순",
                                    ),
                                    DropdownMenuItem(
                                      child: H14(text: "최신순",color: AppColor_Primary,),
                                      value: "최신순",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(top: 16),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return _getTiles1(index);
                            },
                            itemCount: CATEGORYS.length,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  // searchBar(),
                  // Container(
                  //   height: 42,
                  //   margin: const EdgeInsets.only(left: 30, right: 30, top: 16),
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor_Light_Gray),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       IconButton(
                  //         padding: const EdgeInsets.only(left: 20),
                  //         icon: const Icon(Icons.search_rounded, color: AppColor_Icon),
                  //         onPressed: () => {},
                  //       ),
                  //       Expanded(
                  //           child: Container(
                  //         padding: const EdgeInsets.only(bottom: 5),
                  //         child: TextField(
                  //           style: AppTextStyle.PD(Colors.black, 14, weight: FW.regular),
                  //           maxLength: 100,
                  //           controller: keywordController,
                  //           onEditingComplete: () {
                  //             setState(() {
                  //               nPage = 0;
                  //               getCommunityList();
                  //             });
                  //           },
                  //           keyboardType: TextInputType.text,
                  //           textInputAction: TextInputAction.search,
                  //           maxLines: 1,
                  //           decoration: InputDecoration(
                  //             counterText: "",
                  //             hintText: LanguageService.trans("faq_search_hint"),
                  //             hintStyle: AppTextStyle.PD(AppColor_GrayText, 14, weight: FW.medium),
                  //             border: InputBorder.none,
                  //           ),
                  //           onChanged: (text) {
                  //             keyword = text;
                  //           },
                  //         ),
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      child: RefreshIndicator(
                        onRefresh: refresh,
                        child: ListView(
                          shrinkWrap: true,
                          controller: controller,
                          physics: const ClampingScrollPhysics(),
                          children:[
                            ageFilters(),
                            searchBar(),
                            Column(
                              children: arrCommunityList
                                .asMap()
                                .map((idx, e) => MapEntry(idx, _getTiles(idx)))
                                .values
                                .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: nTabIndex == 4 || nTabIndex == 5,
              child: Positioned(
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
              ),
            )
          ],
        ));
  }

  Widget ageFilters() => Visibility(
    visible: nTabIndex == 2 || nTabIndex == 3 || nTabIndex == 4,
    child: Container(
      height: 28,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _getTiles2(index);
        },
        itemCount: subCategories.length,
      ),
    ),
  );

  Widget searchBar() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: 42,
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: AppColor_Selector_Border,
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/search_black_24dp.png', width: 20),
            const SizedBox(width: 10),
            Container(
              width: screenSize.width - 130,
              // margin: const EdgeInsets.only(bottom: 3),
              child: NolineInput(
                controller: searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                borderColor: AppColor_Light_Gray,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  nPage = 0;
                  _isSearching = true;
                  keyword = searchController.text.trim().toString();
                  setState(() {});
                  getCommunityList();
                },
                placeholder: "필요한 키워드를 검색해보세요.",
                canClear: _canClear,
                onChanged: (text){
                  _canClear = (searchController.text != "" && searchController.text != null);
                  setState(() {});
                },
                onClear: () {
                  keyword = "";
                  searchController.clear();
                  _canClear = false;
                  _isSearching = false;
                  getCommunityList();
                  setState(() {});
                },
              ),
            ), 
          ],
        ));
  }

  _noticeTitle(CommunityDto info) => Text(
    info.topic! == "notice" ? "[공지/이벤트]${info.title}" : info.title!,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: (info.topic! == "notice" || info.fixed == "1") ? AppColor_Primary : AppColor_BlackText,
      height: 1.1,
      fontSize: 14,
    ),
    textAlign: TextAlign.left,
    maxLines: 2,
  );
}
