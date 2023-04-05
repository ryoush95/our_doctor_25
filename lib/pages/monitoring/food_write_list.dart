import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/food_item_list_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class FoodWriteList extends StatefulWidget {
  const FoodWriteList({Key? key}) : super(key: key);

  @override
  State<FoodWriteList> createState() => _FoodWriteListState();
}

class _FoodWriteListState extends BaseState<FoodWriteList> {
  HttpService httpService = HttpService();
  final List<String> cateList = ["곡류", "고기,생선\n달걀,콩류", "채소", "과일", "유제품"];
  final List<String> cateName = [
    "_grain",
    "_meat",
    "_vege",
    "_fruit",
    "_milk",
  ];
  List<Map<String, FoodItem>> foodAllList = [];
  List<FoodItem> foodList= [];
  ScrollController sc = ScrollController();
  int cateIndex = 0;

  List<Color> colorList = [
    Colors.amber,
    Colors.orange,
    AppColor_Oxygen,
    AppColor_Red,
    AppColor_Primary,
  ];


  final GlobalKey _tooltipKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFoodList();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  // 모니터링 음식 리스트
  void getFoodList() async {
    setState(() {
      isLoading = true;
    });
    Future<FoodItemListModel> getInfo = httpService.foodWriteList();
    getInfo.then((FoodItemListModel value) {
      if (value.result == 0) {
        foodAllList = value.data;
        foodList = foodAllList[cateIndex].values.toList();

        setState(() {
          isLoading = false;
        });
      } else {
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
      print(onError.toString());
    });
  }

  Widget cateListTile(index) {
    return InkWell(
      onTap: () {
        setState(() {
          cateIndex = index;
          foodList = foodAllList[cateIndex].values.toList();
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 5,
        height: 120,
        margin: const EdgeInsets.only(right: 5),
        child: Column(
          children: [
            cateIndex == index
              ? Image.asset("assets/food${cateName[index]}_on.jpg")
              : Image.asset("assets/food${cateName[index]}_off.jpg"),
            const SizedBox(height: 15),
            H16(
              text: cateList[index],
              color: cateIndex == index ? colorList[index] : Colors.grey,
              maxLine: 2,
              weight: FW.semi_bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget foodListTile(index) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          FutureBuilder(
            builder: (context, snapshot) =>
                CachedNetworkImage(
                    imageUrl: foodList[index].image,
                  width: 120,
                ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: colorList[cateIndex],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  // left: 10, right: 10, top: 20, bottom: 20),
                  child: H18(
                    text: foodList[index].name,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.remove_rounded, color: AppColor_GrayText,),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                        child: H20(text: foodList[index].unit + " " + foodList[index].unitName,)),
                    Container(
                      width: 30,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.add_rounded, color: AppColor_GrayText,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showTooltip(img) {
    if (_overlayEntry != null) return;

    RenderBox? renderBox = _tooltipKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonSize = renderBox.size;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Positioned(
          // top: 100,
          // left: 24,
          top: 0,
          left: 0,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
                color: Colors.grey.withOpacity(0.5),
                width: screenWidth,
                height: screenHeight,
              child: Center(
                child: InkWell(
                  onTap: () {
                    _hideTooltip();
                  },
                  onLongPress: null,
                  child: Container(
                    width: screenWidth - 48,
                    // height: screenHeight,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SingleChildScrollView(
                      child: Image.asset(
                          img),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        child: Column(
          children: [
            SimpleHeader(
              onBackPressed: onBackPressed,
              title: "영양모니터링",
            ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return cateListTile(index);
                        // margin: const EdgeInsets.symmetric(horizontal: 30),
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _showTooltip("assets/food_tooltip${cateName[cateIndex]}.jpg");
                        },
                        child: Container(
                          key: _tooltipKey,
                          child: Image.asset(
                            'assets/question_mark_black_24dp.png',
                            width: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      H14(
                        text: "기준이 궁금해요",
                        weight: FW.medium,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Visibility(
                        visible: cateIndex == 0,
                        child: InkWell(
                          onTap: () {
                            _showTooltip("assets/food_tooltip_second.jpg");
                          },
                          child: Container(
                            // key: _tooltipKey,
                            child: Image.asset(
                              'assets/question_mark_black_24dp.png',
                              width: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Visibility(
                        visible: cateIndex == 0,
                        child: H14(
                          text: "계량 기준이 궁금해요",
                          weight: FW.medium,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: foodList.length * 210,
                    width: MediaQuery.of(context).size.width - 64,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        return foodListTile(index);
                      },
                    ),
                  ),
                  Center(
                    child: MainTextButton(
                      text: "식단 기록하기",
                      style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                      width: 185,
                      height: 40,
                      radius: 6,
                      onPressed: () {
                        // Navigator.push(context, SlideRightTransRoute(builder: (context) => FoodWriteList()));
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        )
      ],
    )
    );
  }
}
