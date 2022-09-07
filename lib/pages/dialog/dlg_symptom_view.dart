import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';

/**
 * 증상 보기 page
 */
class SymptomViewDialog extends StatefulWidget {
  final content;

  SymptomViewDialog({Key? key, this.content}) : super(key: key);

  @override
  _SymptomViewDialogState createState() => _SymptomViewDialogState();
}

class _SymptomViewDialogState extends State<SymptomViewDialog> with SingleTickerProviderStateMixin {
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
                          child: Text(
                            "증상 보기",
                            style: new TextStyle(fontSize: 20, fontFamily: "NotoSansKR", color: Color(0xFF191919), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        margin: const EdgeInsets.only(top: 25.0),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: H18(
                          text: widget.content,
                          weight: FW.regular,
                          maxLine: 30,
                          align: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 15),
                      MainTextButton(
                        text: "확인",
                        backgroundColor: Colors.white,
                        style: AppTextStyle.PD(AppColor_BlackText, 15),
                        width: 100,
                        height: 40,
                        showBorder: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              })),
        ),
      ),
    );
  }
}
