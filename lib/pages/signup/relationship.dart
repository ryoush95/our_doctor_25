import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';

class RelationshipPage extends StatefulWidget {
  RelationshipPage({Key? key, required this.list, required this.selectedItem}) : super(key: key);
  final List<String> list;
  String selectedItem;

  @override
  RelationshipPageState createState() => RelationshipPageState();
}

class RelationshipPageState extends BaseState<RelationshipPage> {
  int selectedIndex = -1;
  var directInputController = TextEditingController();
  String otherContent = "";

  @override
  void initState() {
    super.initState();

    if (widget.selectedItem.isNotEmpty) {
      for (var i = 0; i < widget.list.length; i++) {
        if (widget.list.elementAt(i) == widget.selectedItem) {
          selectedIndex = i;
          if (widget.list.elementAt(i) == "기타") {
            otherContent = widget.list.elementAt(i);
            directInputController.text = otherContent;
          }
          break;
        }
      }
    }
    setState(() {});
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  void goApply() {
    if (selectedIndex == -1) {
      showToast("자녀와의 관계를 선택해 주세요.");
      return;
    }

    String content = widget.list[selectedIndex];
    if (content == "기타") {
      if (otherContent.isEmpty) {
        showToast("기타내용을 입력해주세요.");
        return;
      }
      content = otherContent;
    }
    Map obj = Map();
    obj["content"] = content;
    Navigator.pop(context, obj);
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(
                    height: 55,
                    child: Row(
                      children: [
                        Container(width: 30),
                        InkWell(
                          onTap: () {
                            onBackPressed();
                          },
                          child: Image.asset(
                            'assets/path_12225.png',
                            width: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: H18(
                                text: LanguageService.trans('choose_relationship'),
                                weight: FW.medium,
                                height: 1.5,
                                color: AppColor_BlackText,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            goApply();
                          },
                          child: SizedBox(
                            width: 30,
                            child: H14(
                              text: "적용",
                              weight: FW.medium,
                              height: 1.5,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                        Container(width: 30)
                      ],
                    )),
                Container(
                  height: 1,
                  color: const Color(0xFFEAEAEA),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                          Visibility(
                                            visible: widget.list[index] != "기타",
                                            child: Expanded(
                                                child: Text(
                                              widget.list[index].toString(),
                                              style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular),
                                            )),
                                          ),
                                          Visibility(
                                            visible: widget.list[index] == "기타",
                                            child: Text(
                                              widget.list[index].toString(),
                                              style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.list[index] == "기타",
                                            child: const SizedBox(width: 20),
                                          ),
                                          Visibility(
                                            visible: widget.list[index] == "기타",
                                            child: Expanded(
                                              child: UnderlineInput(
                                                controller: directInputController,
                                                keyboardType: TextInputType.text,
                                                isSecure: true,
                                                textInputAction: TextInputAction.done,
                                                onEditingComplete: () => node.nextFocus(),
                                                placeholder: "기타입력",
                                                onChanged: (text) => {otherContent = text},
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), border: Border.all(color: const Color(0xFFB2B2B2))),
                                              child: Visibility(
                                                  visible: index == selectedIndex,
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
                                        selectedIndex = index;
                                      });
                                    }));
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
