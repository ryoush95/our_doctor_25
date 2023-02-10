import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h32_b.dart';
import 'package:ourdoctor/pages/dialog/dlg_sleep_time.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class BMIBarWeight extends StatefulWidget {
  BMIBarWeight({Key? key, required this.type, required this.weight, this.res = 0, this.color = AppColor_Primary, this.text = "", this.subtext = "", this.tiptext = ""}) : super(key: key);

  final int type;
  final int res;
  final Color color;
  final double weight;
  final String text;
  final String subtext;
  final String tiptext;
  @override
  BMIBarWeightState createState() => BMIBarWeightState();
}

class BMIBarWeightState extends BaseState<BMIBarWeight> {
  DateTime now = DateTime.now();
  final tooltip = GlobalKey();
  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: widget.tiptext,
        textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
        height: 55,
        width: 215,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    hideEntry();
    super.dispose();
  }

  final tip = GlobalKey();
  OverlayEntry? entry;
  final LayerLink _link = LayerLink();
  bool _tipShow = false;

  void showTip() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    entry = OverlayEntry(builder: (context) {
      return Positioned(
        width: 205,
        height: 65,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: Offset(-100, 40),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColor_Selector_Border)),
            child: CupertinoButton(
                child: Text(widget.tiptext, style: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2)),
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

  void insertEntry() {
    final overlayState = Overlay.of(context);
    if (mounted) {
      overlayState!.insert(entry!);
    }
  }

  void hideEntry() {
    if (mounted) {
      entry!.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var customPadding = 10.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.type == 1 ? H18(text: LanguageService.trans('BMI'), weight: FW.regular) : H18(text: LanguageService.trans('daily_sleep_time'), weight: FW.regular),
            const SizedBox(width: 5),
            Stack(
              children: [
                Visibility(
                  visible: widget.type == 1,
                  child: InkWell(
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
                ),
                Visibility(
                  visible: widget.type == 2,
                  child: GestureDetector(
                    onTap: () async {
                      // var _result = await showDialog(context: context, builder: (_) => SleepTimeDialog());
                      Navigator.push(context, SlideRightTransRoute(
                        builder: (context) => PhotoViewPage(type: 4, imgs: ['assets/img_table1.png']),
                      ));
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            Center(child: Image.asset('assets/weight_infograph' + widget.res.toString() + '.png', width: screenSize.width - 120)),
            Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    H16(text: widget.text, weight: FW.regular, maxLine: 2),
                    const SizedBox(height: 3),
                    H16(text: widget.subtext, weight: FW.regular, color: AppColor_GrayText),
                    const SizedBox(height: 8),
                    widget.type == 1 ? H32B(text: widget.weight.toStringAsFixed(1), color: widget.color) : H32B(text: widget.weight.toInt().toString() + LanguageService.trans('hour'), color: widget.color),
                  ],
                ))
          ],
        )
      ],
    );
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
