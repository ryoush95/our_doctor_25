import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';

import 'h16.dart';

class UnderlineSelector extends StatefulWidget {
  UnderlineSelector({Key? key, required this.selectedCategory, required this.categoryList, required this.onSelect, required this.hint}) : super(key: key) {
    this.selectedCategory ??= "";
  }

  String? selectedCategory;
  List<String> categoryList;
  String hint;
  final void Function(String? dropdownValue) onSelect;

  @override
  UnderlineSelectorState createState() => UnderlineSelectorState();
}

class UnderlineSelectorState extends State<UnderlineSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      itemHeight: 50,
      icon: Image.asset('assets/polygon_7.png', width: 12),
      hint: H16(text: widget.hint, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.4)),
      items: widget.categoryList
          .map((label) => DropdownMenuItem(
        child: Text(label.toString()),
        value: label,
      ))
          .toList(),
      value: widget.selectedCategory!.isEmpty ? (widget.categoryList.isEmpty ? widget.hint : widget.categoryList[0]) : widget.selectedCategory,
      isExpanded: false,
      onChanged: (value) {
        widget.onSelect(value);
      },
      decoration: const InputDecoration(contentPadding: EdgeInsets.fromLTRB(0, 0, 20, 0), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColor_Selector_Border))),
    );
  }
}
