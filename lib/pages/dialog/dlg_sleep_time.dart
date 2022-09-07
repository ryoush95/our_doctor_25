import 'package:flutter/material.dart';

/**
 * 일일 수면시간 팝업
 */
class SleepTimeDialog extends StatefulWidget {
  @override
  _SleepTimeDialogState createState() => _SleepTimeDialogState();
}

class _SleepTimeDialogState extends State<SleepTimeDialog> with SingleTickerProviderStateMixin {
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
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Image.asset(
                      'assets/img_table1.png',
                      width: MediaQuery.of(context).size.width - 60,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              })),
        ),
      ),
    );
    ;
  }
}
