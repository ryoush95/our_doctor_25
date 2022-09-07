import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

import 'h16.dart';

class Selector1 extends StatefulWidget {
  Selector1({Key? key, required this.selectedCategory, required this.categoryList, required this.onSelect, required this.hint}) : super(key: key) {
    this.selectedCategory ??= "";
  }

  String? selectedCategory;
  List<String> categoryList;
  String hint;
  final void Function(String? dropdownValue) onSelect;

  @override
  SelectorState createState() => SelectorState();
}

class SelectorState extends State<Selector1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownMaxHeight: MediaQuery.of(context).size.height /2,
        buttonPadding: EdgeInsets.fromLTRB(14, 0, 14, 0),
        buttonDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: AppColor_Selector_Border)),
        isExpanded: true,
        icon: Image.asset('assets/polygon_7.png', width: 10),
        value: widget.selectedCategory,
        items: widget.categoryList.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Center(
              child: Text(
                value.toString(),
                style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.semi_bold, height: 1.0),
              ),
            ),
          );
        }).toList(),
        onChanged: (v) {
          setState(() {
            widget.onSelect(v as String);
          });
        },
      ),
    );
  }
}
