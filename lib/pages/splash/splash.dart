import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/childinfo_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/dialog/dlg_title_one_btn.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/intro/intro1.dart';
import 'package:ourdoctor/pages/tab_main.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends BaseState<SplashPage> {
  late Map statuses;
  int backButtonTimestamp = 0;
  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      gAppVer = packageInfo.version;
    });

    if (Platform.isAndroid) {
      checkPermission();
    } else {
      startApp();
    }
  }

  Future<bool> onBackPressed() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - backButtonTimestamp < 2000) {
      exit(0);
    } else {
      showToast(LanguageService.trans('press_twice_to_exit'));
    }
    backButtonTimestamp = now;
    return false;
  }

  void startApp() async {
    await Future.delayed(const Duration(seconds: 2));

    getAppInfo();
  }

  Future<void> checkPermission() async {
    Map statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted && statuses[Permission.storage] == PermissionStatus.granted) {
      startApp();
    } else {
      var _result = await showDialog(context: context, builder: (_) => OneBtnTitleDialog(title: "알 림", content: "필수 권한을 체크하지 않으면 앱을 이용할수 없습니다.\n앱 설정페이지에서 권한을 활성화 해주세요.", btn: "확인"));
      if (_result == "200") {
        if (Platform.isAndroid) {
          exit(0);
        }
      }
    }
  }

  Future<void> goNext() async {
    String id = await LocalService.getUserID();
    String pwd = await LocalService.getUserPwd();
    String type = await LocalService.getUserType();

    if (id == "" || pwd == "" || type == "") {
      String guide = await LocalService.getGuide();
      if (guide == "") {
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => IntroHomePage()));
      } else {
        // Navigator.push(context, SlideRightTransRoute(builder: (context) => LoginPage()));
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
      }
    } else {
      reqLogin();
    }
  }

  // Network functions
  //////////////////////////////////
  //앱정보 얻기
  Future<void> getAppInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<AppInfoResModel> offerInfo = httpService.getAppInfo();
    offerInfo.then((AppInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gReview = value.data!.review!;
        gCityList = value.data!.areaList!.cityList!;
        gDistrictList = value.data!.areaList!.districtList!;
        gRelationList = value.data!.relationshipList!;
        gSymptomList = value.data!.symptomList!;
        gDiseaseList = value.data!.historyDiseaseList!;

        Parent info = Parent();
        info.id = "0";
        info.name = "직접입력";
        info.inputable = "0";
        gDiseaseList!.parent!.add(info);
        gDiseaseList!.child!.add(info);

        gReviewPoint = value.data!.setting!;

        // gHospitalList = value.data!.hospitalList;
        goNext();
      } else {
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
    });
  }

  //로그인
  Future<void> reqLogin() async {
    String id = await LocalService.getUserID();
    String pwd = await LocalService.getUserPwd();
    String type = await LocalService.getUserType();
    String token = await LocalService.getToken();

    setState(() {
      isLoading = true;
    });

    Future<LoginResModel> offerInfo = httpService.login3(id, pwd, type, token);
    offerInfo.then((LoginResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gUserInfo = value.data;
        // FirebaseMessaging messaging = FirebaseMessaging.instance;
        // messaging.subscribeToTopic('udoctor');

        getChildInfo();
      } else {
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
      }
      // } else if (value.result == 201 || value.result == 211 || value.result == 202 || value.result == 205 || value.result == 104) {
      //   Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => LoginPage()));
      // } else {
      //   showToast(value.reason ?? "");
      // }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
      showToast(onError);
    });
  }

  //현재 선택된 자식 정보 얻기
  Future<void> getChildInfo() async {
    setState(() {
      isLoading = true;
    });
    String childUid = "";
    if (gUserInfo!.selectedChildUid == null || gUserInfo!.selectedChildUid == "") {
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
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => TabMainPage()));
      } else {
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
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
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF4B9EFF),
          child: Center(
            child: Image.asset(
              'assets/ic_intro_logo.png',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
        ));
  }
}
