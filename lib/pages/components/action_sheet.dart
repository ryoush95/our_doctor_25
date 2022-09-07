import 'package:flutter/cupertino.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';

class ActionSheet extends StatefulWidget {
  const ActionSheet({
    Key? key, 
    required this.action1, 
    required this.action2, 
    this.action3,
    required this.onAction1, 
    required this.onAction2,
    this.onAction3,
  }) : super(key: key);

  final String action1;
  final String action2;
  final String? action3;
  final void Function() onAction1;
  final void Function() onAction2;
  final void Function()? onAction3;

  @override
  ActionSheetState createState() => ActionSheetState();
}

class ActionSheetState extends State<ActionSheet> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(widget.action1, style: AppTextStyle.PD(AppColor_Primary, 18, weight: FW.medium)),
          onPressed: () {
            Navigator.pop(context);
            widget.onAction1();
          },
        ),
        widget.action3 != null && widget.onAction3 != null
        ?  CupertinoActionSheetAction(
          child: Text(widget.action3!, style: AppTextStyle.PD(AppColor_Primary, 18, weight: FW.medium)),
          onPressed: () {
            Navigator.pop(context);
            widget.onAction3!();
          },
        )
        : const SizedBox(),
        CupertinoActionSheetAction(
          child: Text(widget.action2, style: AppTextStyle.PD(AppColor_Red, 18, weight: FW.medium)),
          onPressed: () {
            Navigator.pop(context);
            widget.onAction2();
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(LanguageService.trans('cancel1'), style: AppTextStyle.PD(AppColor_Primary, 18, weight: FW.medium)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
