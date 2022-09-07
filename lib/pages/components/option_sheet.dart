import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

class OptionSheet extends StatefulWidget {
  OptionSheet({Key? key, required this.list, required this.selectedItem, required this.title, required this.onPop}) : super(key: key);

  final List<String> list;
  String selectedItem;
  String title;
  final void Function(int selectedIndex) onPop;

  @override
  OptionSheetState createState() => OptionSheetState();
}

class OptionSheetState extends State<OptionSheet> {
  int selectedIndex = -1;

  Future<bool> onBackPressed() async {
    widget.onPop(selectedIndex);
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)), color: Colors.white),
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 40,
                          height: 6,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), color: Color(0xFFB2B2B2)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                          height: 60,
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.title, style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular)),
                          )),
                      Container(
                        height: 1,
                        color: const Color(0xFFEAEAEA),
                      ),
                      Expanded(
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: widget.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                height: 60,
                                child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(widget.list[index].toString(), style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular))),
                                          Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), border: Border.all(color: const Color(0xFFB2B2B2))),
                                              child: Visibility(
                                                  visible: widget.list[index] == widget.selectedItem,
                                                  child: Center(
                                                    child: Container(
                                                      width: 12,
                                                      height: 12,
                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: AppColor_Primary),
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        widget.selectedItem = widget.list[index];
                                        selectedIndex = index;
                                        onBackPressed();
                                      });
                                    }));
                          },
                        ),
                      )
                      // Expanded(child: Container())
                    ],
                  ))
            ],
          ),
          onWillPop: onBackPressed);
    });
  }
}
