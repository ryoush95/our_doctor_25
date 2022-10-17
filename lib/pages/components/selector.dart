import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

import 'h16.dart';

class SelectorBox extends StatefulWidget {
  SelectorBox(
      {Key? key,
      required this.selectedCategory,
      required this.categoryList,
      required this.onSelect,
      required this.hint})
      : super(key: key) {
    this.selectedCategory ??= "";
  }

  String? selectedCategory;
  List<String> categoryList;
  String hint;
  final void Function(String? dropdownValue) onSelect;

  @override
  SelectorBoxState createState() => SelectorBoxState();
}

class SelectorBoxState extends State<SelectorBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        itemHeight: 52,
        isExpanded: true,
        icon: Image.asset('assets/polygon_7.png', width: 10),

        hint: H16(
            text: widget.hint,
            weight: FW.medium,
            color: AppColor_BlackText.withOpacity(0.4)),
        items: widget.categoryList
            .asMap()
            .map(
              (idx, label) => MapEntry(
                idx,
                DropdownMenuItem(
                  child: SizedBox(
                      height: 52,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 52,
                            child: Center(
                              child: Text(
                                label.toString(),
                                style: AppTextStyle.PD(AppColor_BlackText, 16,
                                    weight: FW.semi_bold, height: 1.0),
                              ),
                            ),
                          ),
                          idx != widget.categoryList.length && idx != 0
                              ? Container(
                                  height: 0.5,
                                  color: AppColor_BlackText.withOpacity(0.1),
                                )
                              : const SizedBox(),
                        ],
                      )),
                  value: label,
                ),
              ),
            )
            .values
            .toList(),
        value: widget.selectedCategory!.isEmpty
            ? (widget.categoryList.isEmpty
                ? widget.hint
                : widget.categoryList[0])
            : widget.selectedCategory,
        isDense: false,
        // menuMaxHeight: MediaQuery.of(context).size.height * .5,
        onChanged: (String? value) {
          widget.onSelect(value);
        },
        buttonDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: AppColor_Selector_Border),
        ),
        buttonPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        // const InputDecoration(
        //     contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: BorderSide(color: AppColor_Selector_Border),
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //     )),
      ),
    );
  }
}
