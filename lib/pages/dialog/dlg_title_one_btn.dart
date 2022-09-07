import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';

/**
 * 타이틀 1개 버튼을 가진 팝업
 */
class OneBtnTitleDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final String? btn;

  OneBtnTitleDialog({Key? key, this.title, this.content, this.btn}) : super(key: key);

  @override
  _OneBtnTitleDialogState createState() => _OneBtnTitleDialogState();
}

class _OneBtnTitleDialogState extends State<OneBtnTitleDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          color: Colors.transparent,
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: Center(
                          child: H16(text: widget.title!, weight: FW.medium),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                        child: H14(
                          text: widget.content!,
                          weight: FW.medium,
                          height: 1.2,
                          maxLine: 10,
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Color(0xFFEFEFEF),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        margin: const EdgeInsets.all(12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkResponse(
                            onTap: () async {
                              Navigator.pop(context, "200");
                            },
                            child: Container(
                              width: 120,
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                child: H16(text: widget.btn!, weight: FW.regular),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
        ),
      ),
    );
    ;
  }
}
