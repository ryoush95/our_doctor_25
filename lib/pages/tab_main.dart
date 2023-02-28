import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/fcm.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/basket_list_res_model.dart';
import 'package:ourdoctor/models/childinfo_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/live_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/care_fragment.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/community/community_fragment.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h13.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/home/add_children1.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_fragment2.dart';
import 'package:ourdoctor/pages/my/faq_list.dart';
import 'package:ourdoctor/pages/my/favorite_product.dart';
import 'package:ourdoctor/pages/my/my_page.dart';
import 'package:ourdoctor/pages/my/my_point.dart';
import 'package:ourdoctor/pages/my/my_posts.dart';
import 'package:ourdoctor/pages/my/order_complete.dart';
import 'package:ourdoctor/pages/my/shopping_basket.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'alarm/alarm.dart';
import 'base/page_layout.dart';
import 'components/drawer_navigation.dart';
import 'components/h14.dart';
import 'components/h16.dart';
import 'components/h18.dart';
import 'home/home_fragment.dart';
import 'monitoring/monitoring_fragment.dart';

class TabMainPage extends StatefulWidget {
  TabMainPage({Key? key, this.pageIdx = 1, this.infoTabIdx = 0})
      : super(key: key);

  int? pageIdx;
  int? infoTabIdx;

  @override
  TabMainPageState createState() => TabMainPageState();
}

class TabMainPageState extends BaseState<TabMainPage>
    with TickerProviderStateMixin {
  int shipping_fee = 0;
  List<bool> checkStatus = [];
  var textEditingControllers = <TextEditingController>[];

  List<BasketDto> basketList = [];
  int backButtonTimestamp = 0;
  MainTab currentTab = MainTab.home;
  String title = "";
  late TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final HttpService httpService = HttpService();
  bool isBadge = false;

  final sideMenuList = [
    SideMenuCategory(
        icon: 'ic_ua_point.png', title: 'ua_point', route: MyPointPage()),
    // SideMenuCategory(
    //     icon: 'ic_basket.png',
    //     title: 'shopping_basket',
    //     route: ShoppingBasketPage()),
    SideMenuCategory(
        icon: 'ic_jjim_product.png',
        title: 'favorite_product',
        route: FavoriteProductPage()),
    // SideMenuCategory(icon: 'ic_pencil.svg', title: 'view_my_posts', route: MyPostsPage()),
    SideMenuCategory(
        icon: 'ic_my_info.png', title: 'my_page', route: MyPagePage()),
    SideMenuCategory(
        icon: 'ic_faq.png', title: 'notice_faq', route: FaqListPage()),
    SideMenuCategory(icon: '9c_ask.png', title: 'inquiry'),
    SideMenuCategory(icon: 'ic_databook.png', title: 'archives'),
  ];

  void changeTab(MainTab tab) {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    setState(() {
      currentTab = tab;
      tabController.index = tab.index;
    });
  }

  void showLeftMenu() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
    } else {
      scaffoldKey.currentState!.openEndDrawer();
    }
  }

  Future<void> goAlarmPage() async {
    String result = await Navigator.push(context,
        SlideRightTransRoute(builder: (context) => AlarmPage(type: 0)));
    if (result == "story") {
      setState(() {
        tabController.index = 3;
      });
    } else {
      getLiveInfo();
    }
  }

  // void goPoint() {
  //   showLeftMenu();
  //   Navigator.push(context, SlideRightTransRoute(builder: (context) => MyPointPage()));
  // }

  // void goProfile() {
  //   showLeftMenu();
  //   //Navigator.push(context, SlideRightTransRoute(builder: (context) => ProfileViewPage()));
  //   Navigator.push(context, SlideRightTransRoute(builder: (context) => MyPagePage()));
  // }

  // void goFaq() {
  //   showLeftMenu();
  //   Navigator.push(context, SlideRightTransRoute(builder: (context) => FaqListPage()));
  //   // if (currentTab == MainTab.community) {
  //   //   return;
  //   // }
  //   // changeTab(MainTab.community);
  // }

  // void goAsk() {
  //   showLeftMenu();
  //   //Navigator.push(context, SlideRightTransRoute(builder: (context) => AskHistoryPage()));
  //   _launchURL(KAKAOTALK_CHAT);
  // }

  // void goDateBook() {
  //   showLeftMenu();
  //   //Navigator.push(context, SlideRightTransRoute(builder: (context) => AskHistoryPage()));
  //   _laudnchURL(DATEBOOK_URL);
  // }

  // void goBasket() {
  //   showLeftMenu();
  //   Navigator.push(context, SlideRightTransRoute(builder: (context) => ShoppingBasketPage()));
  // }

  // void goFavproduct() {
  //   showLeftMenu();
  //   Navigator.push(context, SlideRightTransRoute(builder: (context) => FavoriteProductPage()));
  // }

  // void doLogout() {
  //   LocalService.removeUser();
  //
  //   Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => IntroPage()));
  // }

  void onLogout() {
    showLeftMenu();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                H18(
                    text: LanguageService.trans('logout_confirm'),
                    height: 1.5,
                    weight: FW.regular),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Container(
                          width: 80,
                          height: 35,
                          child: H16(
                              text: LanguageService.trans('confirm'),
                              color: AppColor_Red,
                              weight: FW.medium),
                        ),
                        onTap: reqLogout,
                      ),
                      InkWell(
                        child: Container(
                          width: 80,
                          height: 35,
                          child: H16(
                              text: LanguageService.trans('cancel'),
                              weight: FW.medium),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void onDelChild(String uid) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                H18(
                    text: LanguageService.trans('delete_child_alert'),
                    height: 1.5,
                    weight: FW.regular),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: SizedBox(
                          width: 80,
                          height: 35,
                          child: H16(
                              text: LanguageService.trans('confirm'),
                              color: AppColor_Red,
                              weight: FW.medium),
                        ),
                        onTap: () {
                          showLeftMenu();
                          Navigator.pop(context);
                          reqDelChild(uid);
                        },
                      ),
                      InkWell(
                        child: Container(
                          width: 80,
                          height: 35,
                          child: H16(
                              text: LanguageService.trans('cancel'),
                              weight: FW.medium),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    if (currentTab != MainTab.home) {
      changeTab(MainTab.home);
      setState(() {});
      return false;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - backButtonTimestamp < 2000) {
      exit(0);
    } else {
      showToast(LanguageService.trans('press_twice_to_exit'));
    }
    backButtonTimestamp = now;
    return false;
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);

    tabController.addListener(() {
      int idx = tabController.index;
      switch (idx) {
        case 0:
          currentTab = MainTab.home;
          break;
        case 1:
          currentTab = MainTab.monitoring;
          break;
        case 2:
          currentTab = MainTab.home_care;
          break;
        case 3:
          currentTab = MainTab.community;
          break;

        default:
          currentTab = MainTab.home;
          break;
      }
      setState(() {});
    });

    getLiveInfo();

    eventBus.on<MoreStoryEvent>().listen((event) {
      if (mounted) {
        faqFromSide = false;
        changeTab(MainTab.home_care);
      }
    });

    eventBus.on<MoreCommunityEvent>().listen((event) {
      if (mounted) {
        Provider.of<ConvertScoreProvider>(context, listen: false).changeTab(event.type);
        changeTab(MainTab.community);
      }
    });

    eventBus.on<MoreMonitoring>().listen((event) {
      if (mounted) {
        changeTab(MainTab.monitoring);
      }
    });

    eventBus.on<MoreHomeCareEvent>().listen((event) {
      if (mounted) {
        int category = event.type;
        changeTab(MainTab.home_care);
        Future.delayed(const Duration(milliseconds: 1000), () {
          eventBus.fire(HomeCareTabEvent(type: category));
        });
      }
    });

    eventBus.on<AddChildrenEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });

    eventBus.on<UpdateChildEvent>().listen((event) {
      if (mounted) {
        getChildInfo();
      }
    });

    eventBus.on<ReceivePushEvent>().listen((event) {
      if (mounted) {
        getLiveInfo();
      }
    });

    // enableIOSNotifications();
    // registerNotificationListeners();
    setupFcmListener(_recvMessage, _clickMessage);

     Future.delayed(const Duration(milliseconds: 100), () {
       if (widget.pageIdx == 2) {
         changeTab(MainTab.monitoring);
        // eventBus.fire(InfoTabEvent(type: widget.infoTabIdx!));
       } else if (widget.pageIdx == 4){
         changeTab(MainTab.community);
       }
     });
    BasketList();
  }

  Future<void> BasketList() async {
    setState(() {
      isLoading = true;
    });
    Future<BasketListResModel> info = httpService.getBasketList();
    info.then((BasketListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        shipping_fee = int.parse(value.data!.deliver_price!);
        basketList.addAll(value.data!.lists!);

        List.generate(basketList.length, (index) => checkStatus.add(false));
        for (int i = 0; i < basketList.length; i++) {
          var textEditingController =
              TextEditingController(text: basketList[i].count.toString());
          textEditingControllers.add(textEditingController);
        }
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {}
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     processMessage(message.data, false);
//   }
//
//   processMessage(Map<String, dynamic> data, bool isForeground) async {
//     String notiContent = data['body'] ?? "";
//     String title = data['title'] ?? "";
//     String payload = json.encode(data);
//     showNotification(title, notiContent, payload);
//   }
//
//   Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
//
//   registerNotificationListeners() async {
//     AndroidNotificationChannel channel = androidNotificationChannel();
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//
//     var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSSettings = const IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//     var initSetttings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
//     flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: (message) async {
//       // This function handles the click in the notification when the app is in foreground
//       // Get.toNamed(NOTIFICATIOINS_ROUTE);
//     });
// // onMessage is called when the app is in foreground and a notification is received
//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//       // Get.find<HomeController>().getNotificationsNumber();
//       print(message);
//
//       String payload = json.encode(message!.data);
//       String title = message.data["title"];
//       String content = message.data["body"];
//       showNotification(title, content, payload);
//     });
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//   Future onSelectNotification(String? payload) async {
//     if (payload != null && payload.isNotEmpty) {
//       Map<String, dynamic> data = json.decode(payload);
//       String type = data['type'] ?? "";
//       if (type == "" || type == "main") {
//         return;
//       }
//     }
//   }
//
//   androidNotificationChannel() => const AndroidNotificationChannel(
//         'Ourdoctor_high_importance_channel', // id
//         'Ourdoctor High Importance Notifications', // title
//         description: 'This channel is used for Ourdoctor important notifications.', // description
//         importance: Importance.max,
//       );
//   enableIOSNotifications() async {
//     await FirebaseMessaging.instance
//         .requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     )
//         .then((settings) {
//       print('User granted permission: ${settings.authorizationStatus}');
//     });
//
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: false, // Required to display a heads up notification
//       badge: false,
//       sound: false,
//     );
//   }
//
//   Future<void> showNotification(String title, String message, String payload) async {
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
//
//     String rnd = DateTime.now().millisecondsSinceEpoch.toString();
//     String name = "your channel name";
//     String desc = "your channel description";
//
//     Map<String, dynamic> data = json.decode(payload);
//     String img_url = data['img_url'] ?? "";
//
//     var iosPlatformChannelSpecifics = new IOSNotificationDetails(presentSound: true);
//     var androidPlatformChannelSpecifics = null;
//     if (img_url != "") {
//       final String bigPicturePath = await _downloadAndSaveFile(img_url, 'bigPicture');
//       final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath), largeIcon: null, contentTitle: title, htmlFormatContentTitle: true, summaryText: message, htmlFormatSummaryText: true);
//
//       androidPlatformChannelSpecifics = new AndroidNotificationDetails(rnd, name, enableVibration: false, playSound: true, importance: Importance.max, priority: Priority.high, ticker: 'ticker', styleInformation: bigPictureStyleInformation);
//     } else {
//       androidPlatformChannelSpecifics = new AndroidNotificationDetails(rnd, name, enableVibration: false, playSound: true, importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//     }
//     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(0, title, message, platformChannelSpecifics, payload: payload);
//   }
  // main activity에서 설정
  Future<void> setupFcmListener(
      void Function(Map<String, dynamic> data) onReceive,
      void Function(Map<String, dynamic> data) onClick) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      // eventBus.fire(ReceivePushEvent());
      showNotification(data);
      onReceive(message.data);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      onClick(initialMessage.data);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => {onClick(message.data)});

    initLocalNotification(onClick);
  }

  void _recvMessage(Map<String, dynamic> data) {
    // if (data['type'] == 'chat' || data['type'] == 'chatting_add' || data['type'] == 'purchase') {
    //   getIt<EventBus>().fire(ChatChanged(data));
    // }
    print(data);
    if (data['type'] == 'order_complete') {
      String orderID = data['uid'];
      // eventBus.fire(PaymentFinish(order_id: orderID));
      Navigator.push(
          context,
          SlideRightTransRoute(
              builder: (context) =>
                  OrderCompletePage(orderID: int.parse(orderID))));
    }
  }

  void _clickMessage(Map<String, dynamic> data) {
    print(data);
    String _type = data['type'];
    switch (_type) {
      case "community_added":
        String uid = data["uid"];
        if (uid == "") {
          return;
        }
        Navigator.push(
            context,
            SlideRightTransRoute(
                builder: (context) => CommunityDetailPage(uid: uid)));
        break;
      case "reply_added":
        String uid = data["uid"];
        if (uid == "") {
          return;
        }
        Navigator.push(
            context,
            SlideRightTransRoute(
                builder: (context) => CommunityDetailPage(uid: uid)));
        break;
      case "comment_added":
        String uid = data["uid"];
        if (uid == "") {
          return;
        }
        Navigator.push(
            context,
            SlideRightTransRoute(
                builder: (context) => CommunityDetailPage(uid: uid)));
        break;
    }
  }

  //그리드뷰 타일
  List<Widget> _getGridTiles() {
    int allCount = gUserInfo!.childList!.length + 2;
    final List<Widget> tiles = <Widget>[];
    for (int i = 1; i < allCount; i++) {
      tiles.add(
        GridTile(
          child: Stack(
            children: [
              // Visibility(
              //   visible: i == 0,
              //   child: InkWell(
              //     onTap: () {
              //       if (gUserInfo!.selectedChildUid == gUserInfo!.id) {
              //         return;
              //       }
              //
              //       reqSelChild("0");
              //     },
              //     onLongPress: () {
              //       showToast(LanguageService.trans("delete_child_error1"));
              //     },
              //     child: SizedBox(
              //       width: 60,
              //       height: 84,
              //       child: Column(
              //         children: [
              //           Stack(
              //             children: [
              //               Center(
              //                 child: RoundContainer(
              //                   width: 60.0,
              //                   height: 60.0,
              //                   bgColor: Colors.yellow,
              //                   child: Center(
              //                     child: Stack(
              //                       children: [
              //                         Visibility(
              //                             visible: gUserInfo!.profileImgUrl!.isEmpty,
              //                             child: Center(
              //                               child: Image.asset(
              //                                 'assets/group_19975.png', //getRandomImg(),
              //                                 fit: BoxFit.fill,
              //                               ),
              //                             )),
              //                         Visibility(
              //                           visible: gUserInfo!.profileImgUrl!.isNotEmpty,
              //                           child: ExtendedImage.network(
              //                             gUserInfo!.profileImgUrl!,
              //                             width: 60,
              //                             height: 60,
              //                             fit: BoxFit.fill,
              //                             cache: true,
              //                             shape: BoxShape.circle,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Visibility(
              //                 visible: gUserInfo!.selectedChildUid == gUserInfo!.id || gUserInfo!.selectedChildUid == "",
              //                 child: Align(
              //                   alignment: Alignment.topRight,
              //                   child: Image.asset('assets/ic_blue_dot.png', width: 6),
              //                 ),
              //               )
              //             ],
              //           ),
              //           Expanded(
              //             child: Container(),
              //           ),
              //           SizedBox(
              //             height: 18,
              //             child: Row(
              //               children: [
              //                 Image.asset(gUserInfo!.gender == 1 ? 'assets/ic_male.png' : 'assets/ic_female.png', width: 18),
              //                 H14(text: gUserInfo!.name!, weight: FW.regular),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Visibility(
                visible: i > 0 && i < allCount,
                child: InkWell(
                  onTap: () {
                    String _uid = gUserInfo!.childList!.elementAt(i - 1).id!;
                    if (gUserInfo!.selectedChildUid == _uid) {
                      return;
                    }
                    if (_uid == gUserInfo!.id) {
                      //reqSelChild("0"); // 본인은 제외처리
                    } else {
                      reqSelChild(_uid);
                    }
                    // print(_uid);
                    // gUserInfo!.selectedChildUid = _uid;
                    // setState(() {});
                  },
                  onLongPress: () {
                    String _uid = gUserInfo!.childList!.elementAt(i - 1).id!;
                    if (_uid == gUserInfo!.id) {
                      showToast(LanguageService.trans("delete_child_error1"));
                      return;
                    } else if (_uid == gUserInfo!.selectedChildUid) {
                      showToast("선택된 자녀는 삭제하실 수 없습니다.");
                      return;
                    } else {
                      onDelChild(_uid);
                    }
                  },
                  child: SizedBox(
                    width: 60,
                    height: 84,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: RoundContainer(
                                width: 60.0,
                                height: 60.0,
                                bgColor: (gUserInfo!.selectedChildUid ==
                                        (i < (allCount - 1)
                                            ? gUserInfo!.childList!
                                                .elementAt(i - 1)
                                                .id!
                                            : ""))
                                    ? AppColor_Primary
                                    : Colors.white,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Visibility(
                                          visible: !isExistImg(i),
                                          child: Center(
                                            child: Image.asset(
                                              (getChildGender(i) == 1
                                                  ? 'assets/ic_default_male.png'
                                                  : 'assets/ic_default_female.png'),
                                              width: 60,
                                              height: 60,
                                            ),
                                          )),
                                      Visibility(
                                        visible: isExistImg(i),
                                        child: ExtendedImage.network(
                                          getChildImg(i),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          cache: true,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        SizedBox(
                          height: 18,
                          child: Row(
                            children: [
                              Visibility(
                                  visible: i != allCount - 1,
                                  child: Image.asset(
                                    (getChildGender(i) == 1
                                        ? 'assets/ic_male.png'
                                        : 'assets/ic_female.png'),
                                    width: 20,
                                  )),
                              Flexible(
                                  child: H14(
                                      text: getChildName(i),
                                      weight: FW.regular)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: i == allCount - 1,
                child: InkWell(
                  onTap: () {
                    showLeftMenu();
                    Navigator.push(
                        context,
                        SlideRightTransRoute(
                            builder: (context) => AddChildren1Page()));
                  },
                  child: SizedBox(
                    width: 60,
                    height: 84,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: RoundContainer(
                                width: 60.0,
                                height: 60.0,
                                bgColor: Colors.white,
                                child: Center(
                                  child: Image.asset('assets/ic_add_child.png',
                                      width: 60, height: 60),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        SizedBox(
                          height: 18,
                          child: H14(text: "아이 추가", weight: FW.regular),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return tiles;
  }

  bool isExistImg(int index) {
    if (index == 0 || index == gUserInfo!.childList!.length + 1) {
      return false;
    }

    if (gUserInfo!.childList!.elementAt(index - 1).profileImgUrl!.isEmpty ||
        gUserInfo!.childList!
            .elementAt(index - 1)
            .profileImgUrl!
            .contains("img_photo_default")) {
      return false;
    } else {
      return true;
    }
  }

  String getChildImg(int index) {
    if (index == 0 || index == gUserInfo!.childList!.length + 1) {
      return "";
    }

    String img = gUserInfo!.childList!.elementAt(index - 1).profileImgUrl!;
    if (img == "") {
      return "";
    } else {
      return img;
    }
  }

  bool isSelectChild(int index) {
    if (index == 0 || index == gUserInfo!.childList!.length + 1) {
      return false;
    }

    if (gUserInfo!.selectedChildUid == null ||
        gUserInfo!.selectedChildUid == "") {
      return false;
    }

    if (gUserInfo!.selectedChildUid ==
        gUserInfo!.childList!.elementAt(index - 1).id) {
      return true;
    } else {
      return false;
    }
  }

  int getChildGender(int index) {
    if (index == 0 || index == gUserInfo!.childList!.length + 1) {
      return 1;
    }

    int? gender = gUserInfo!.childList!.elementAt(index - 1).gender;
    return gender!;
  }

  String getChildName(int index) {
    if (index == 0 || index == gUserInfo!.childList!.length + 1) {
      return "";
    }

    String? name = gUserInfo!.childList!.elementAt(index - 1).name;
    return name!;
  }

  _launchURL(String _url) async {
    try {
      await launch(_url);
    } catch (err) {
      showToast(err.toString());
    }
  }

  // Network functions
  //////////////////////////////////
  //라이브 데이터 얻기
  Future<void> getLiveInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<LiveResModel> info = httpService.liveInfo();
    info.then((LiveResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        isBadge = value.data!.isNew!;
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

  //로그아웃
  Future<void> reqLogout() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.logout();
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("logout_success"));
        LocalService.setUserID("");
        LocalService.setUserPwd("");
        LocalService.setUserType("");
        Navigator.pushReplacement(
            context, SlideRightTransRoute(builder: (context) => FirstPage()));
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

  //회원정보 얻기
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
        gUserInfo!.childList = value.data!.childList!;
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

  //현재 선택된 자식 정보 얻기
  Future<void> getChildInfo() async {
    setState(() {
      isLoading = true;
    });
    String childUid = "";
    if (gUserInfo!.selectedChildUid == null ||
        gUserInfo!.selectedChildUid == "") {
      gUserInfo!.selectedChildUid = gUserInfo!.id;
      childUid = gUserInfo!.id!;
    } else {
      childUid = gUserInfo!.selectedChildUid!;
    }

    Future<ChildInfoResModel> info = httpService.childInfo2(childUid);
    info.then((ChildInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gSelChildInfo = value.data;
        setState(() {});
        eventBus.fire(SelectChildEvent());
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

  //유저자식 선택
  Future<void> reqSelChild(String uid) async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.selchild(uid);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("select_child_success"));
        if (uid == "0") {
          gUserInfo!.selectedChildUid = gUserInfo!.id!;
        } else {
          gUserInfo!.selectedChildUid = uid;
        }
        getChildInfo();
        eventBus.fire(SelectChildEvent());
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

  //유저자식 삭제
  Future<void> reqDelChild(String uid) async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.delchild(uid);
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans("delete_child_success"));
        int index = 0;
        for (int i = 0; i < gUserInfo!.childList!.length; i++) {
          if (uid == gUserInfo!.childList!.elementAt(i).id) {
            index = i;
          }
        }
        gUserInfo!.childList!.removeAt(index);
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
    return PageLayout(
      isLoading: isLoading,
      isAvoidResize: false,
      onBack: onBackPressed,
      drawer: drawerNavigation(context),
      scaffoldKey: scaffoldKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(left: 20.0, right: 10),
                    child: Image.asset('assets/group_19532.png', width: 20),
                  ),
                  onTap: showLeftMenu,
                ),
                GestureDetector(
                  onTap: () {
                    if (currentTab == MainTab.home) {
                      return;
                    }
                    changeTab(MainTab.home);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Center(
                      child: Image.asset(
                        'assets/ic_main_top_logo.png',
                        height: 21,
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   child: Image.asset('assets/ic_kakao.png', width: 24),
                //   onTap: () {
                //     _launchURL(KAKAOTALK_CHAT);
                //   },
                // ),
                Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Image.asset(
                            'assets/notifications_none_black_24dp.png',
                            width: 24),
                      ),
                      onTap: () {
                        goAlarmPage();
                      },
                      behavior: HitTestBehavior.translucent,
                    ),
                    Visibility(
                      visible: isBadge,
                      child: const Positioned(
                        right: 10,
                        top: 20,
                        child: CircleAvatar(
                          radius: 2.5,
                          backgroundColor: AppColor_Red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              // physics: const NeverScrollableScrollPhysics(),
              physics: const ClampingScrollPhysics(),
              controller: tabController,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: HomeFragment(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: MonitoringFragment2(
                      type: widget.infoTabIdx, pageType: widget.pageIdx),
                ),
                Container(
                  alignment: Alignment.center,
                  child: CareFragment(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: CommunityFragment(),
                ),
              ],
            ),
          ),
          //const Divider(),
          Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.fromLTRB(55, 25, 55, 0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor_Gray,
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 5 Vertically
                    ),
                  )
                ]),
            child: Stack(
              children: [
                Align(
                    // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (currentTab == MainTab.home) {
                                    return;
                                  }
                                  changeTab(MainTab.home);
                                },
                                behavior: HitTestBehavior.translucent,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset("assets/ic_home_off.png",
                                              width: 16),
                                          Visibility(
                                            visible: currentTab == MainTab.home,
                                            child: Image.asset(
                                                "assets/ic_home_on.png",
                                                width: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      H13(
                                        text: LanguageService.trans('home'),
                                        color: currentTab == MainTab.home
                                            ? AppColor_Primary
                                            : AppColor_Tab_Unselected,
                                        weight: FW.medium,
                                      )
                                    ])),
                            Container(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (currentTab == MainTab.monitoring) {
                                    return;
                                  }
                                  changeTab(MainTab.monitoring);
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Opacity(
                                            opacity: 0.2,
                                            child: Image.asset(
                                              "assets/ic_monitor_off.png",
                                              width: 20,
                                            ),
                                          ),
                                          Visibility(
                                            visible: currentTab ==
                                                MainTab.monitoring,
                                            child: Image.asset(
                                                "assets/ic_take1.png",
                                                width: 20),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                      H13(
                                        text:
                                            LanguageService.trans('monitoring'),
                                        color: currentTab == MainTab.monitoring
                                            ? AppColor_Primary
                                            : AppColor_Tab_Unselected,
                                        weight: FW.medium,
                                      )
                                    ]),
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if (currentTab == MainTab.home_care) {
                                      return;
                                    }
                                    faqFromSide = false;
                                    Provider.of<ConvertScoreProvider>(context, listen: false).changeCareTab(0);
                                    changeTab(MainTab.home_care);
                                  },
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Image.asset(
                                                "assets/ic_story_off.png",
                                                width: 20),
                                            Visibility(
                                              visible: currentTab ==
                                                  MainTab.home_care,
                                              child: Image.asset(
                                                  "assets/ic_story_on.png",
                                                  width: 20),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 7),
                                        H13(
                                          text: LanguageService.trans(
                                              'home_care'),
                                          color: currentTab == MainTab.home_care
                                              ? AppColor_Primary
                                              : AppColor_Tab_Unselected,
                                          weight: FW.medium,
                                        )
                                      ])),
                            ),
                            Container(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (currentTab == MainTab.community) {
                                    return;
                                  }
                                  Provider.of<ConvertScoreProvider>(context, listen: false).changeTab(0);
                                  changeTab(MainTab.community);
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset("assets/ic_com_of.png",
                                              width: 20),
                                          Visibility(
                                            visible:
                                                currentTab == MainTab.community,
                                            child: Image.asset(
                                                "assets/ic_monitor_on.png",
                                                width: 20),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                      H13(
                                        text:
                                            LanguageService.trans('community'),
                                        color: currentTab == MainTab.community
                                            ? AppColor_Primary
                                            : AppColor_Tab_Unselected,
                                        weight: FW.medium,
                                      )
                                    ]),
                              ),
                            ),
                          ]),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget drawerNavigation(BuildContext context) {
    return DrawerNavigation(
        radius: 30,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/ic_left_logo.png', height: 18),
                  Expanded(child: Container()),
                  InkWell(
                    child:
                        Image.asset('assets/clear_black_24dp.png', height: 24),
                    onTap: showLeftMenu,
                  )
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  H16(text: gUserInfo!.nickname!),
                  const SizedBox(width: 7),
                  H16(text: LanguageService.trans('nim'), weight: FW.medium),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: H14(
                text: LanguageService.trans('please_select_a_home_care_target'),
                weight: FW.medium,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 230,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: RoundContainer(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: GridView.count(
                    primary: false,
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: _getGridTiles(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            ...List.generate(sideMenuList.length, (int idx) => sideMenu(idx)),
            const SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Center(
                    child: H14(
                        text: LanguageService.trans('logout'),
                        weight: FW.medium,
                        color: AppColor_GrayText),
                  )),
              onTap: onLogout,
            ),
            const SizedBox(height: 30),
          ],
        )));
  }

  sideMenu(int idx) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 22),
        padding: idx != 2
            ? const EdgeInsets.only(top: 15, bottom: 13)
            : const EdgeInsets.only(top: 40, bottom: 13),
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(
              width: 1,
              color: AppColor_Divider),
        )),
        child: GestureDetector(
          onTap: () {
            showLeftMenu();
            if (idx == 4) {
              _launchURL("http://pf.kakao.com/_xgkwexj");
            } else if (idx == 5) {
              _launchURL(DATEBOOK_URL);
            } else {
              Navigator.push(
                  context,
                  SlideRightTransRoute(
                      builder: (ctx) => sideMenuList[idx].route!));
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/${sideMenuList[idx].icon}',
                          height: 20),
                  const SizedBox(width: 12),
                  H16(
                      text: LanguageService.trans(sideMenuList[idx].title),
                      weight: FW.regular),
                ],
              ),
              Row(
                children: [
                  idx == 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColor_f4f5f7,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: H12(
                              text: sprintf(
                                  "%s P", [ValidPrice(gUserInfo!.point!)]),
                              weight: FW.regular,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  // idx == 1
                  //     ? Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 10),
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 7),
                  //           decoration: BoxDecoration(
                  //             color: AppColor_f4f5f7,
                  //             borderRadius: BorderRadius.circular(15.0),
                  //           ),
                  //           child: H12(
                  //             text: sprintf(
                  //                 "%s 개", [(basketList.length.toString())]),
                  //             weight: FW.regular,
                  //           ),
                  //         ),
                  //       )
                  //     : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      );
}

class SideMenuCategory {
  final String icon;
  final String title;
  final Widget? route;

  SideMenuCategory({
    required this.icon,
    required this.title,
    this.route,
  });
}
