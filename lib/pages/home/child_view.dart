import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/add_children1.dart';
import 'package:ourdoctor/pages/home/child_edit.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/profile_item.dart';

class ChildViewPage extends StatefulWidget {
  ChildViewPage({Key? key, required this.uid}) : super(key: key);
  String? uid;

  @override
  ChildViewPagePageState createState() => ChildViewPagePageState();
}

class ChildViewPagePageState extends BaseState<ChildViewPage> {
  String profileImage = "";
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();

  String selectChild = "";
  ChildList? dicUserInfo;
  List<ChildList>? arrChildList = [];

  @override
  void initState() {
    super.initState();

    selectChild = widget.uid!;
    initData();

    eventBus.on<AddChildrenEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });

    eventBus.on<UpdateChildEvent>().listen((event) {
      if (mounted) {
        getUserInfo();
      }
    });
  }

  void initData() {
    arrChildList!.clear();
    arrChildList!.addAll(gUserInfo!.childList!);

    for (int i = 0; i < arrChildList!.length; i++) {
      if (selectChild == arrChildList!.elementAt(i).id) {
        dicUserInfo = arrChildList!.elementAt(i);
        arrChildList!.remove(arrChildList!.elementAt(i));
        setState(() {});
        break;
      }
    }
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void onEdit() {
    Navigator.push(context, SlideRightTransRoute(builder: (context) => ChildEditPage(info: dicUserInfo)));
  }

  //그리드뷰 타일
  List<Widget> _getGridTiles() {
    int allCount = arrChildList!.length + 1;
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < allCount; i++) {
      tiles.add(
        GridTile(
          child: Stack(
            children: [
              Visibility(
                visible: i < allCount,
                child: InkWell(
                  onTap: () {
                    ChildList item = arrChildList!.elementAt(i);
                    selectChild = item.id!;
                    initData();
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
                                  child: Stack(
                                    children: [
                                      Visibility(
                                          visible: !isExistImg(i),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/group_19975.png', //getRandomImg(),
                                              fit: BoxFit.cover,
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
                            ),
                            Visibility(
                              visible: isSelectChild(i),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Image.asset('assets/ic_blue_dot.png', width: 6),
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
                                    (getChildGender(i) == 1 ? 'assets/ic_male.png' : 'assets/ic_female.png'),
                                    width: 18,
                                  )),
                              H14(text: getChildName(i), weight: FW.regular),
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
                    Navigator.push(context, SlideRightTransRoute(builder: (context) => AddChildren1Page()));
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
                                  child: Image.asset('assets/ic_add_child.png', width: 60, height: 60),
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
    if (index == arrChildList!.length) {
      return false;
    }

    if (arrChildList!.elementAt(index).profileImgUrl!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String getChildImg(int index) {
    if (index == arrChildList!.length) {
      return "";
    }

    String img = arrChildList!.elementAt(index).profileImgUrl!;
    if (img == "") {
      return "";
    } else {
      return img;
    }
  }

  bool isSelectChild(int index) {
    if (index == arrChildList!.length) {
      return false;
    }

    if (gUserInfo!.selectedChildUid == arrChildList!.elementAt(index).id) {
      return true;
    } else {
      return false;
    }
  }

  int getChildGender(int index) {
    if (index == arrChildList!.length) {
      return 1;
    }

    int? gender = arrChildList!.elementAt(index).gender;
    return gender!;
  }

  String getChildName(int index) {
    if (index == arrChildList!.length) {
      return "";
    }

    String? name = arrChildList!.elementAt(index).name;
    return name!;
  }

  // Network functions
  //////////////////////////////////
  //회원정보 얻기
  Future<void> getUserInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<UserInfoResModel> info = httpService.userInfo();
    info.then((UserInfoResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        gUserInfo = value.data;
        initData();
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
              title: LanguageService.trans("children_info"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: InkWell(
                          // onTap: onSelectPhoto,
                          child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.all((dicUserInfo!.profileImgUrl! == "") ? 20 : 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColor_Light_Gray,
                            ),
                            child: Observer(
                              builder: (_) => Stack(
                                children: [
                                  Visibility(
                                      visible: dicUserInfo!.profileImgUrl! == "",
                                      child: Center(
                                        child: Image.asset(
                                          getRandomImg(),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Visibility(
                                    visible: dicUserInfo!.profileImgUrl! != "",
                                    child: ExtendedImage.network(
                                      (dicUserInfo!.profileImgUrl! == "") ? "" : dicUserInfo!.profileImgUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      cache: true,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    const SizedBox(height: 40),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("name"), content: dicUserInfo!.name!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("birthday"), content: dicUserInfo!.birth!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("phone"), content: dicUserInfo!.phone!, type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("weight"), content: dicUserInfo!.weight! == "" ? "" : dicUserInfo!.weight! + "kg", type: 0),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("pcr_date"), content: dicUserInfo!.monitoringDate!, type: 0),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          H14(
                            text: LanguageService.trans("address"),
                            weight: FW.medium,
                            color: AppColor_Input_Title,
                          ),
                          const SizedBox(height: 15),
                          H16(
                            text: dicUserInfo!.postcode! + "\n" + dicUserInfo!.address! + (dicUserInfo!.addressDetail! == "" ? "" : "\n" + dicUserInfo!.addressDetail!),
                            weight: FW.medium,
                            color: AppColor_BlackText,
                            maxLine: 10,
                            height: 1.5,
                            align: TextAlign.left,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    Observer(
                      builder: (_) => ProfileItem(title: LanguageService.trans("call_hosiptal"), content: dicUserInfo!.hospitalName!, type: 0),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: H20(
                        text: LanguageService.trans("other_child_list"),
                        weight: FW.bold,
                        color: AppColor_BlackText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 230,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: RoundContainer(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: GridView.count(
                              primary: false,
                              crossAxisCount: 3,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: (MediaQuery.of(context).size.width - 64 - 60 * 3) / 3,
                              children: _getGridTiles(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MainTextButton(
                        text: LanguageService.trans("edit_child_info"),
                        backgroundColor: AppColor_Primary,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        height: 55,
                        onPressed: () {
                          onEdit();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
