import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/noline_input.dart';

class CommunitySearch extends StatefulWidget {
  const CommunitySearch({Key? key}) : super(key: key);

  @override
  State<CommunitySearch> createState() => _CommunitySearchState();
}

class _CommunitySearchState extends BaseState<CommunitySearch> {
  String keyword = "";
  bool _isSearching = false;
  var keywordController = TextEditingController();
  final searchController = TextEditingController();
  bool _canClear = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget searchBar() {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
            width: screenSize.width - 60,
            height: 42,
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: AppColor_Selector_Border,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                SizedBox(
                  width: screenSize.width - 150,
                  // margin: const EdgeInsets.only(bottom: 3),
                  child: NolineInput(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    borderColor: AppColor_Light_Gray,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _isSearching = true;
                      keyword = searchController.text.trim().toString();
                      setState(() {});
                      // getCommunityList();
                    },
                    placeholder: "커뮤니티 검색",
                    canClear: _canClear,
                    onChanged: (text){
                      _canClear = (searchController.text != "" && searchController.text != null);
                      setState(() {});
                    },
                    onClear: () {
                      keyword = "";
                      searchController.clear();
                      _canClear = false;
                      _isSearching = false;
                      // getCommunityList();
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () {
                  },
                  child: Image.asset('assets/search_black_24dp.png', width: 20),
                ),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
      isLoading: isLoading,
      isAvoidResize: false,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: 55,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
                            text: '검색',
                            weight: FW.medium,
                            height: 1.5,
                            color: AppColor_BlackText,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
            ),
            searchBar(),
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return Container();
              },),
            )
          ])),
    );
  }
}
