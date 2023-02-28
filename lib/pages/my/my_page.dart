import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/child_mangement.dart';
import 'package:ourdoctor/pages/my/my_posts.dart';
import 'package:ourdoctor/pages/my/order_history.dart';
import 'package:ourdoctor/pages/my/profile_view.dart';
import 'package:ourdoctor/pages/my/review_fragment.dart';
import 'package:ourdoctor/pages/tab_main.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPagePage extends StatefulWidget {
  @override
  MyPagePageState createState() => MyPagePageState();
}

class MyPagePageState extends BaseState<MyPagePage> {
  String profileImage = "";
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();

  String? chatNum = "";

  final List<MyPageCategory> categories = [
    MyPageCategory(title: "my_info", icon: "ic_my_info.png", route: ProfileViewPage()),
    MyPageCategory(title: "order_history", icon: "ic_order_his.png", route: OrderHistoryPage()),
    MyPageCategory(title: "my_review", icon: "ic_my_review.png", route: ReviewFragment()),
    MyPageCategory(title: "좋아요 게시물", icon: "ic_jjim_product.png", route: MyPostsPage(like: 1,)),
    MyPageCategory(title: "family_child_history", icon: "ic_child_manage.png", route: ChildManagementPage()),
    MyPageCategory(title: "view_my_posts", icon: "ic_pencil.svg", route: MyPostsPage(like: 0,)),
  ];

  @override
  void initState() {
    super.initState();

    getUserInfo();
    eventBus.on<AddChildrenEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });
    eventBus.on<UpdateUserEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  Future<void> getUserInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<UserInfoResModel> info = httpService.userInfo2();
    info.then((UserInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gUserInfo = value.data;
        gUserInfo!.childList = value.data!.childList!;
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
              title: LanguageService.trans("mypage"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),
                            H14(
                              text: LanguageService.trans("welcome"),
                              color: AppColor_GrayText,
                              weight: FW.medium,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                H20(text: gUserInfo!.nickname!),
                                const SizedBox(width: 7),
                                H20(text: LanguageService.trans('nim'), weight: FW.bold),
                              ],
                            )
                          ],
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(onPressed: (){
                          launch("http://pf.kakao.com/_xgkwexj");
                        }, icon: const Icon(Icons.chat_bubble_rounded), label: const Text("카카오 상담")),
                        const SizedBox(width: 15),
                        ElevatedButton.icon(onPressed: (){
                          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => TabMainPage(pageIdx: 4,),));
                          Provider.of<ConvertScoreProvider>(context, listen: false).changeTab(4);
                        }, icon: const Icon(Icons.chat_bubble_rounded), label: const Text("질문 게시판")),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ...categories
                      .asMap()
                      .map((idx, e) => MapEntry(idx, category(e, idx)))
                      .values
                      .toList(),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(context, SlideRightTransRoute(builder: (context) => ProfileViewPage()));
                    //   },
                    //   child: Container(
                    //     height: 60,
                    //     margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    //     child: Row(
                    //       children: [
                    //         Image.asset('assets/ic_my_info.png', width: 25),
                    //         const SizedBox(width: 20),
                    //         H16(
                    //           text: LanguageService.trans("my_info"),
                    //           weight: FW.medium,
                    //           color: AppColor_BlackText,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 1,
                    //   color: AppColor_Divider,
                    //   margin: const EdgeInsets.only(left: 30, right: 30),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(context, SlideRightTransRoute(builder: (context) => OrderHistoryPage()));
                    //   },
                    //   child: Container(
                    //     height: 60,
                    //     margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    //     child: Row(
                    //       children: [
                    //         Image.asset('assets/ic_order_his.png', width: 25),
                    //         const SizedBox(width: 20),
                    //         H16(
                    //           text: LanguageService.trans("order_history"),
                    //           weight: FW.medium,
                    //           color: AppColor_BlackText,
                    //         ),
                    //         const SizedBox(width: 5),
                    //         Container(
                    //             width: 30,
                    //             height: 30,
                    //             padding: const EdgeInsets.symmetric(vertical: 7.5),
                    //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: AppColor_Selector_Border),
                    //             child: H14(
                    //               text: gUserInfo!.orderCount.toString(),
                    //               weight: FW.regular,
                    //             ))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 1,
                    //   color: AppColor_Divider,
                    //   margin: const EdgeInsets.only(left: 30, right: 30),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(context, SlideRightTransRoute(builder: (context) => ReviewFragment()));
                    //   },
                    //   child: Container(
                    //     height: 60,
                    //     margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    //     child: Row(
                    //       children: [
                    //         Image.asset('assets/ic_my_review.png', width: 25),
                    //         const SizedBox(width: 20),
                    //         H16(
                    //           text: LanguageService.trans("my_review"),
                    //           weight: FW.medium,
                    //           color: AppColor_BlackText,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: 1,
                    //   color: AppColor_Divider,
                    //   margin: const EdgeInsets.only(left: 30, right: 30),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(context, SlideRightTransRoute(builder: (context) => ChildManagementPage()));
                    //   },
                    //   child: Container(
                    //     height: 60,
                    //     margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    //     child: Row(
                    //       children: [
                    //         Image.asset('assets/ic_child_manage.png', width: 25),
                    //         const SizedBox(width: 20),
                    //         H16(
                    //           text: "가족력, 아이 관리",
                    //           weight: FW.medium,
                    //           color: AppColor_BlackText,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  category(MyPageCategory category, int idx) => GestureDetector(
    onTap:() {
      if(idx == 1){
        launch("https://wooadoctor.com/mypage/applications?token=${gUserInfo!.accessToken!}");
        return;
      }
        Navigator.push(context,
            SlideRightTransRoute(builder: (context) => category.route));
    },
    behavior: HitTestBehavior.translucent,
    child: Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColor_Divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
          children: [
            Container(
              width: 25,
              child: category.icon.contains(".svg") ?
              SvgPicture.asset('assets/${category.icon}', width: 25) :
              Image.asset('assets/${category.icon}', width: 25)
            ),
            const SizedBox(width: 18),
            H16(
              text: LanguageService.trans(category.title),
              weight: FW.medium,
              color: AppColor_BlackText,
            ),
            idx == 1
            ? orderHistory()
            : const SizedBox(),
          ],
        ),
    ),
  );

  orderHistory() => Container(
    width: 30,
    height: 30,
    padding: const EdgeInsets.symmetric(vertical: 7.5),
    margin: const EdgeInsets.only(left: 14),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: AppColor_Selector_Border),
    child: H14(
      text: gUserInfo!.orderCount.toString(),
      weight: FW.regular,
    ));
}

class MyPageCategory {
  final String title;
  final String icon;
  final Widget route;

  MyPageCategory({
    required this.title,
    required this.icon,
    required this.route,
  });
}