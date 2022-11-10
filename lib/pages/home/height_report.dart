import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/homecare_banner_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/care/product_detail.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h32_b.dart';
import 'package:ourdoctor/pages/components/result_area.dart';
import 'package:ourdoctor/pages/home/bmi_bar1.dart';
import 'package:ourdoctor/pages/home/height_line_chart.dart';
import 'package:ourdoctor/pages/home/range_show.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

class HeightReport extends StatefulWidget {
  HeightReport({Key? key, required this.data, this.result = 0}) : super(key: key);

  final HomeGraphTallDto data;
  final int result;

  @override
  HeightReportState createState() => HeightReportState();
}

class HeightReportState extends BaseState<HeightReport> {
  DateTime now = DateTime.now();
  final HttpService httpService = HttpService();
  List<HomeCareBannerDto> arrBannerList = [];

  final tooltip = GlobalKey();
  final tooltip1 = GlobalKey();
  int rnum = 0;

  final tip = GlobalKey();
  final tip2 = GlobalKey();
  OverlayEntry? entry;
  OverlayEntry? entry2;
  final LayerLink _link = LayerLink();
  final LayerLink _link2 = LayerLink();
  bool _tipShow = false;
  bool _tipShow2 = false;

  @override
  void initState() {
    // TODO: implement initState
    getBannerList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    hideEntry();
    hideEntry2();
    super.dispose();
  }

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: "부모의 신장으로 예측한 우리아이의\n미래 예측키로써 영양상태 및\n각종 외부환경 영향으로 변경될 수\n있습니다.",
        textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
        height: 90,
        width: 220,
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: BorderRadius.circular(5.0),
        onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
  }

  void showMoreText1() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(
      context,
      text: "보건복지부 및 대한소아과학회\n소아청소년 성장도표 기준",
      textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
      height: 60,
      width: 200,
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: BorderRadius.circular(5.0),
      onDismiss: () {},
    );
    popup.show(
      widgetKey: tooltip1,
    );
  }

  Future<void> getBannerList() async {
    setState(() {
      isLoading = true;
    });
    String category = "MONITORING";

    Future<HomeCareBannerResModel> info =
    httpService.homecareBannerList(category);
    info.then((HomeCareBannerResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (arrBannerList.isNotEmpty) {
          arrBannerList.clear();
        }
        arrBannerList = value.data!.list!;
        rnum = Random().nextInt(arrBannerList.length);
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

  void showTip() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    entry = OverlayEntry(builder: (context) {
      return Positioned(
        width: 205,
        height: 115,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: Offset(-100, 40),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColor_Selector_Border)),
            child: CupertinoButton(
                child: Text("부모의 신장으로 예측한 우리아이의 미래 예측키로써 영양상태 및 각종 외부환경 영향으로 변경될 수 있습니다.", style: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2)),
                onPressed: () {
                  // hideEntry();
                  setState(() {
                    if(_tipShow || entry == null){
                      showTip();
                      insertEntry();
                      _tipShow = false;
                    } else if (!_tipShow && entry != null){
                      hideEntry();
                      _tipShow = true;
                    } else {
                      _tipShow = !_tipShow;
                    }
                  });
                }),
          ),
        ),
      );
    });
  }

  void showTip2() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    entry2 = OverlayEntry(builder: (context) {
      return Positioned(
        width: 205,
        height: 65,
        child: CompositedTransformFollower(
          link: _link2,
          showWhenUnlinked: false,
          offset: Offset(-100, 40),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColor_Selector_Border)),
            child: CupertinoButton(
                child: Text("보건복지부 및 대한소아과학회\n소아청소년 성장도표 기준", style: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2)),
                onPressed: () {
                  setState(() {
                    if(_tipShow2 || entry2 == null){
                      showTip2();
                      insertEntry2();
                      _tipShow2 = false;
                    } else if (!_tipShow2 && entry2 != null){
                      hideEntry2();
                      _tipShow2 = true;
                    } else {
                      _tipShow2 = !_tipShow2;
                    }
                  });
                }),
          ),
        ),
      );
    });
  }

  void insertEntry() {
    final overlayState = Overlay.of(context);
    if (mounted) {
      overlayState!.insert(entry!);
    }
  }

  void hideEntry() {
    if (mounted) {
      entry!.remove();
      // entry = null;
    }
  }

  void insertEntry2() {
    final overlayState = Overlay.of(context);
    if (mounted) {
      overlayState!.insert(entry2!);
    }
  }

  void hideEntry2() {
    if (mounted) {
      entry2!.remove();
      // entry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            HeightLineChart(data: widget.data),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H18(text: LanguageService.trans('my_child_future_prediction'), weight: FW.regular),
                const SizedBox(width: 5),
                InkWell(
                  key: const Key('show_more_ink_well'),
                  child: CompositedTransformTarget(
                    link: _link,
                    child: Container(
                      key: tip,
                      child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if(_tipShow || entry == null){
                        showTip();
                        insertEntry();
                        _tipShow = false;
                      } else if (!_tipShow && entry != null){
                        hideEntry();
                        _tipShow = true;
                      } else {
                        _tipShow = !_tipShow;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: H32B(text: sprintf("%.1fcm", [widget.data.heightPredict!.toDouble()]), color: AppColor_BlackText),
            ),
            const SizedBox(height: 36),
            BMIBar1(
              weight: widget.data.monitoring!.value!,
              res: widget.data.monitoring!.diagnose!.result!.startsWith("저신장") ? getResFromString("R")
                  : getResFromString(widget.data.monitoring!.diagnose!.color!),
              color: widget.data.monitoring!.diagnose!.result!.startsWith("저신장") ? getColorFromString("R")
                  : getColorFromString(widget.data.monitoring!.diagnose!.color!),
              text: widget.data.monitoring!.diagnose!.result!,
              subtext: widget.data.monitoring!.diagnose!.result!.contains("정상") ? "" : (widget.data.diff! >= 0 ? "+" : "") + convertScore(widget.data.diff!.toStringAsFixed(1)) + "cm",
            ),
            const SizedBox(height: 30),
            const Divider(color: AppColor_Light_Gray, thickness: 3),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //H18(text: "4 " + LanguageService.trans('year_old_girl'), weight: FW.regular),
                  H18(text: gSelChildInfo == null ? '' : "${getAge(gSelChildInfo!.birth!)}세 ${gSelChildInfo!.gender! == 1 ? '남' : '여'}아 백분위", weight: FW.regular),
                  const SizedBox(width: 5),
                  InkWell(
                    key: const Key('show_more_ink_well'),
                    child: CompositedTransformTarget(
                      link: _link2,
                      child: Container(
                        key: tip2,
                        child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if(_tipShow2 || entry2 == null){
                          showTip2();
                          insertEntry2();
                          _tipShow2 = false;
                        } else if (!_tipShow2 && entry2 != null){
                          hideEntry2();
                          _tipShow2 = true;
                        } else {
                          _tipShow2 = !_tipShow2;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            RangeShow(
                start: widget.data.monitoring!.diagnose!.min!,
                end: widget.data.monitoring!.diagnose!.max!,
                rate: widget.data.monitoring!.value! > double.parse(widget.data.monitoring!.diagnose!.max!)
                    ? 100
                    : (widget.data.monitoring!.value! < double.parse(widget.data.monitoring!.diagnose!.min!)
                        ? 0
                        : (((widget.data.monitoring!.value! - double.parse(widget.data.monitoring!.diagnose!.min!))) / ((double.parse(widget.data.monitoring!.diagnose!.max!) - double.parse(widget.data.monitoring!.diagnose!.min!))) * 100)),
                unit: "cm",
                color: getColorFromString(widget.data.monitoring!.diagnose!.color!),
                cur_value: widget.data.monitoring!.value!),
            widget.result == 1 ? const SizedBox(height: 40) : const SizedBox(),
            widget.result == 1 ? ResultArea(type: 0, result: 2, diagnose: widget.data.monitoring!.diagnose!) : const SizedBox(),
            const SizedBox(height: 30,),
            InkWell(
              onTap:(){
                if(arrBannerList[rnum].url != "") {
                  Navigator.push(
                      context, SlideRightTransRoute(builder: (context) =>
                      ProductDetail(
                        pid: arrBannerList[rnum].url!,
                      )));
                }
              },
              child: arrBannerList.isEmpty ? Container() :
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                      arrBannerList[rnum].image!
                  ),
              ),
            )
          ],
        ));
  }

  int getWeight() {
    return 25;

    // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    // String date = dateFormat.format(now);
    // int hour = now.hour;
    // for (int i = 0; i < widget.data.length; i++) {
    //   if (hour >= 12) {
    //     if (widget.data.elementAt(i).pm_time.contains(date)) {
    //       String data = widget.data.elementAt(i).afternoon_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   } else {
    //     if (widget.data.elementAt(i).am_time.contains(date)) {
    //       String data = widget.data.elementAt(i).morning_temperature;
    //       if (data == "") {
    //         return "미측정";
    //       } else {
    //         return data + '℃';
    //       }
    //     }
    //   }
    // }
    // return "미측정";
  }

  String getCurTime() {
    int hour = now.hour;
    if (hour < 12) {
      return "오늘 오전";
    } else {
      return "오늘 오후";
    }
  }
}
