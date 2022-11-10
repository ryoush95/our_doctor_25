import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h36_b.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:sprintf/sprintf.dart';

class CircularProgress extends StatefulWidget {
  int? type;
  int? subType;

  CircularProgress({Key? key, this.type = 0, this.subType = 0}) : super(key: key);

  @override
  CircularProgressState createState() => CircularProgressState();
}

class CircularProgressState extends BaseState<CircularProgress> {
  final tooltip = GlobalKey();
  HomeMonitorDto? dicHomeDataInfo;
  final HttpService httpService = HttpService();
  String content = "";
  double fWidth = 0;
  double fHeight = 0;

  void showMoreText() {
    if (widget.type == 0) {
      content = "신체 및 두뇌발달을\n종합적으로 판단한 스코어입니다.\n\n더 높은 스코어를 획득할 수 있도록\n우아닥터와 함께 해주세요.";
      fWidth = 230;
      fHeight = 105;
    } else {
      if (widget.subType == 0) {
        content = "신체 - 신장/체중/생활습관/질병 모니터링 결과를\n종합적으로 판단한 스코어입니다.\n\n더 높은 스코어를 획득할 수 있도록\n우아닥터와 함께 해주세요.";
        fWidth = 290;
        fHeight = 125;
      } else if(widget.subType == 1) {
        content = "두뇌 - 언어/운동/사회성/맞춤검사 모니터링 결과를\n종합적으로 판단한 스코어입니다.\n\n더 높은 스코어를 획득할 수 있도록\n우아닥터와 함께 해주세요.";
        fWidth = 300;
        fHeight = 125;

      }
    }

    // ShowMoreTextPopup popup = ShowMoreTextPopup(context,
    //     text: content, textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2), height: fHeight, width: fWidth, backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), borderRadius: BorderRadius.circular(5.0), onDismiss: () {
    //   // ScaffoldMessenger.of(context)
    //   //     .showSnackBar(SnackBar(content: Text("Dismiss callback!")));
    // });
    //
    // /// show the popup for specific widget
    // popup.show(
    //   widgetKey: tooltip,
    // );
  }

  double showScore() {
    double result = 0;

    if (dicHomeDataInfo == null) {
      return result;
    }

    if (widget.type == 0) {
      result = dicHomeDataInfo!.totalScore!;
    } else {
      if (widget.subType == 0) {
        result = dicHomeDataInfo!.bodyScore!;
      } else {
        result = dicHomeDataInfo!.brainScore!;
      }
    }

    return result > 100 ? 100 : result;
  }

  @override
  void initState() {
    super.initState();
    getMonitor2HomeDataInfo();

    eventBus.on<SubTabEvent>().listen((event) {
      if (mounted) {
        widget.subType = event.type;
        setState(() {});
      }
    });

    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getMonitor2HomeDataInfo();
      }
    });
  }

  String convertScore(String score) {
    double hrs = fromJsonDouble(score);
    if (hrs - hrs.toInt() == 0.0) {
      return sprintf("%d", [hrs.toInt()]);
    }
    return sprintf("%.1f", [hrs]);
  }

  // Network functions|
  //////////////////////////////////
  //홈 발달 리포트 얻기
  Future<void> getMonitor2HomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HomeMonitorResModel> info = httpService.homeMonitorInfo();
    info.then((HomeMonitorResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeDataInfo = value.data!;
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

  final tip = GlobalKey();
  OverlayEntry? entry;
  final LayerLink _link = LayerLink();
  bool _tipShow = false;

  @override
  void dispose() {
    // TODO: implement dispose
    hideEntry();
    entry = null;
    super.dispose();
  }

  void showTip() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;
    showMoreText();

    entry = OverlayEntry(builder: (context) {
      return Positioned(
        width: fWidth,
        height: fHeight,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: widget.subType == 0 ? Offset(-140, 30) : Offset(-290, 30),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColor_Selector_Border)),
            child: CupertinoButton(
                child: Text(content, style: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2)),
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
    OverlayState? overlayState = Overlay.of(context);
    if (mounted) {
      overlayState!.insert(entry!);
    }
  }

  void hideEntry() {
    if (mounted) {
      entry!.remove();
      entry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      child: Center(
        child: Container(
          width: 162,
          height: 152,
          child: Stack(
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 136.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: dicHomeDataInfo == null ? 0 : showScore() / 100,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      H36B(
                          text: (dicHomeDataInfo == null || showScore() == 0)
                              ? "??"
                              : convertScore(showScore().toString()),
                          weight: FW.regular,
                      ),
                      const SizedBox(width: 5),
                      H18(text: LanguageService.trans('jom'), weight: FW.regular),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: AppColor_Primary,
                  backgroundColor: AppColor_f4f5f7,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  key:const Key('show_more_ink_well'),
                  child: CompositedTransformTarget(
                    link: _link,
                    child: Container(
                      key: tip,
                      child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if(_tipShow || entry ==null){
                        showTip();
                        insertEntry();
                        _tipShow =false;
                      }else if(!_tipShow && entry !=null){
                        hideEntry();
                        _tipShow =true;
                      }else{
                        _tipShow = !_tipShow;
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
