import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class FoodWriteList extends StatefulWidget {
  const FoodWriteList({Key? key}) : super(key: key);

  @override
  State<FoodWriteList> createState() => _FoodWriteListState();
}

class _FoodWriteListState extends State<FoodWriteList> {

  List<String> cateList = ["곡류", "고기,생선\n달걀,콩류", "채소", "과일", "유제품"];
  ScrollController sc = ScrollController();


  final GlobalKey _tooltipKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  Widget listTile(index) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 5,
      height: (MediaQuery.of(context).size.width - 64) / 5,
      margin: const EdgeInsets.only(right: 5),
      child: Column(
        children: [
          // Image.asset(""),
          const SizedBox(height: 15),
          H16(
            text: cateList[index],
            color: Colors.grey,
            maxLine: 2,
            weight: FW.semi_bold,
          ),
        ],
      ),
    );
  }

  void _showTooltip() {
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
          top: 300,
          left: 24,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: (){
                _hideTooltip();
              },
              child: Container(
                width: screenWidth - 48,
                // height: screenHeight - 364,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        '툴팁',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '1인 1회 기준입니다',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 300,
                        color: Colors.grey,
                      )
                      // ... 다른 컨텐츠 추가
                    ],
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
                    height: 100,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return listTile(index);
                        // margin: const EdgeInsets.symmetric(horizontal: 30),
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _showTooltip();
                        },
                        child: Container(
                          key: _tooltipKey,
                          child: Image.asset(
                            'assets/question_mark_black_24dp.png',
                            width: 24,
                          ),
                        ),
                      ),
                      H14(
                        text: "계량 기준이 궁금해요",
                        weight: FW.medium,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Container(
                    height: cateList.length * 230,
                    width: MediaQuery.of(context).size.width - 64,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cateList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 199,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
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
