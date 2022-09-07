import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/dto/category_dto.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class AppDropdown extends StatefulWidget {
  AppDropdown(
      {Key? key,
      required this.selectedCategoryUid,
      required this.categoryList,
      this.isPandown,
      required this.onSelect})
      : super(key: key) {
    this.isPandown ??= true;
    this.selectedCategoryUid ??= 0;
  }

  int? selectedCategoryUid;
  List<CategoryDto> categoryList;
  bool? isExpanded;
  bool? isPandown;
  final void Function(int? dropdownValue) onSelect;

  @override
  AppDropdownState createState() => AppDropdownState();
}

class AppDropdownState extends State<AppDropdown> {
  @override
  void initState() {
    super.initState();
  }

  List<String> categoryNameList = [];
  List<int> categoryUidList = [];

  void getCategoryNameList() {
    widget.categoryList.forEach((element) {
      categoryNameList.add(element.category);
      categoryUidList.add(element.category_uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AwesomeDropDown(
      elevation: 0,
      padding: 0,
      isPanDown: widget.isPandown!,
      dropDownList: categoryNameList,
      isBackPressedOrTouchedOutSide: true,
      selectedItemTextStyle: AppTextStyle.PD(AppColor_BlackText, 15),
      selectedItem: widget.selectedCategoryUid == 0 ? LanguageService.trans("category") : categoryNameList.elementAt(categoryUidList.indexOf(widget.selectedCategoryUid!)),
      dropDownListTextStyle: const TextStyle(
          height: 2,
          color: AppColor_BlackText,
          fontSize: 15,
          fontFamily: "S-Core Dream5-Medium"),
      numOfListItemToShow: 5,
      dropDownIcon: const Icon(Icons.keyboard_arrow_down),
      onDropDownItemClick: (selectedCategoryName) {
        widget.onSelect(categoryUidList.elementAt(categoryNameList.indexOf(selectedCategoryName)));
      },
    );
  }
}
