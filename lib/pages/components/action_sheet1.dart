import 'package:flutter/cupertino.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';

class ActionSheet1 extends StatefulWidget {
  const ActionSheet1({
    required this.action, 
    this.action2, 
    required this.onAction,
    this.onAction2,
  });

  final String action;
  final String? action2;
  final void Function() onAction;
  final void Function()? onAction2;

  @override
  ActionSheet1State createState() => ActionSheet1State();
}

class ActionSheet1State extends State<ActionSheet1> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(widget.action, style: AppTextStyle.PD(AppColor_Red, 18, weight: FW.medium)),
          onPressed: () {
            Navigator.pop(context);
            widget.onAction();
          },
        ),
        widget.action2 != null && widget.onAction2 != null 
        ? CupertinoActionSheetAction(
          child: Text(widget.action2!, style: AppTextStyle.PD(AppColor_Primary, 18, weight: FW.medium)),
          onPressed: () {
            Navigator.pop(context);
            widget.onAction2!();
          },
        )
        : const SizedBox(),
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
