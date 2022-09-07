import 'package:flutter/material.dart';

/**
 * 카로리  팝업
 */
class KaoriDialog extends StatefulWidget {
  @override
  _KaoriDialogState createState() => _KaoriDialogState();
}

class _KaoriDialogState extends State<KaoriDialog> with SingleTickerProviderStateMixin {
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
                      'assets/img_table2.png',
                      width: MediaQuery.of(context).size.width - 60,
                      height: MediaQuery.of(context).size.height - 60,
                      fit: BoxFit.contain,
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
