import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/category_list_res_model.dart';
import 'package:ourdoctor/models/food_list_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/selector1.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/old_food_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class CaloriCalcPage extends StatefulWidget {
  CaloriCalcPage({Key? key, this.type}) : super(key: key);

  int? type;

  @override
  CaloriCalcPageState createState() => CaloriCalcPageState();
}

class CaloriCalcPageState extends BaseState<CaloriCalcPage> {
  final HttpService httpService = HttpService();
  ScrollController _controller = ScrollController();

  // bool isValid = false;

  List<String> countList = [];

  List<String> categoryList = [];
  List<SubCategoryList>? subAllCategoryList;
  List<String> subCategoryList = [];
  List<FoodDto> foodList = [];
  List<String> foodStrList = [];

  List<FoodDto> foodAddList = [];

  String category = "";
  String subCategory = "";
  String food = "";
  List<String> count = [];
  double allKalori = 0;

  @override
  void initState() {
    super.initState();

    for (double i = 0.25; i <= 3; i += 0.25) {
      String content = (i).toString();
      if (content.contains(".0")) {
        content = content.replaceAll(".0", "");
      }
      countList.add(content + "인분");
    }

    if (widget.type == 0) {
      foodAddList = monitoringData!.foodAddList1!;
    } else if (widget.type == 1) {
      foodAddList = monitoringData!.foodAddList2!;
    } else if (widget.type == 2) {
      foodAddList = monitoringData!.foodAddList3!;
    } else if (widget.type == 3) {
      foodAddList = monitoringData!.foodAddList4!;
    }

    for (int i = 0; i < foodAddList.length; i++) {
      String con = foodAddList.elementAt(i).count.toString();
      if (con.contains(".0")) {
        con = con.replaceAll(".0", "");
      }
      count.add(con + "인분");
    }
    checkValid();
    getFoodCategoryList();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  scrollDown() {
    _controller.animateTo(_controller.position.maxScrollExtent + 50,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    setState(() {});
  }

  String convertScore(String score) {
    double hrs = fromJsonDouble(score);
    if (hrs - hrs.toInt() == 0.0) {
      return sprintf("%d", [hrs.toInt()]);
    }
    return sprintf("%.1f", [hrs]);
  }

  void checkValid() {
    allKalori = 0;
    for (int i = 0; i < foodAddList.length; i++) {
      allKalori = allKalori + (double.parse(foodAddList.elementAt(i).kcal!) * foodAddList.elementAt(i).count!);
    }
    // isValid = foodAddList.isNotEmpty;
    setState(() {});
  }

  Future<bool> onBackPressed() async {
    foodAddList.clear();
    Navigator.pop(context, "");
    return true;
  }

  void getSubCategoryList() {
    for (int i = 0; i < subAllCategoryList!.length; i++) {
      if (category == subAllCategoryList!.elementAt(i).category) {
        subCategoryList = subAllCategoryList!.elementAt(i).list!;
      }
    }
    if (subCategoryList.isNotEmpty) {
      subCategory = subCategoryList[0];
      getFoodList();
    }
  }

  // Network functions
  //////////////////////////////////
  // 모니터링 음식 카테고리 리스트
  void getFoodCategoryList() {
    setState(() {
      isLoading = true;
    });
    Future<CategoryListResModel> uploadInfo = httpService.foodCategoryList();
    uploadInfo.then((CategoryListResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        // categoryList = value.data!.categoryList!;
        sortCategoryListByOrder(value.data!.categoryList!);
        subAllCategoryList = value.data!.subCategoryList!;
        if (categoryList.isNotEmpty) {
          category = categoryList[0];
          getSubCategoryList();
        }

        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  sortCategoryListByOrder(List<String> value) {
    List<String> order = ['한식', '양식', '중식', '일식', '분식', '패스트푸드', '제품', '과일'];

    for (int i = 0; i < value.length; i++) {
      int idx = value.indexWhere((e) => e == order[i]);
      categoryList.add(value[idx]);
    }
  }

  // 모니터링 음식 리스트
  void getFoodList() {
    setState(() {
      isLoading = true;
    });
    Future<FoodListResModel> uploadInfo =
        httpService.foodList(category, subCategory);
    uploadInfo.then((FoodListResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        foodList = value.data!.list!;
        foodStrList.clear();
        if (foodList.isNotEmpty) {
          for (int i = 0; i < foodList.length; i++) {
            foodStrList.add(foodList.elementAt(i).name!);
            foodList.elementAt(i).count = 0.25;
          }
          food = foodList[0].name!;
        }

        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleHeader(
                  title: "칼로리 계산기",
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        H24B(
                            text: "칼로리 계산기",
                            color: AppColor_BlackText,
                            align: TextAlign.left,
                            height: 1.5),
                        const SizedBox(height: 8),
                        H14(
                          text: "먹은 음식을 선택해 영양상태를 효과적으로 기록해보세요.",
                          weight: FW.medium,
                          align: TextAlign.left,
                          color: AppColor_BlackText,
                          maxLine: 2,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                            width: screenSize.width - 64,
                            child:
                            Selector1(
                                selectedCategory: category,
                                categoryList: categoryList,
                                onSelect: (selectedCategory) {
                                  setState(() {
                                    category = selectedCategory!;
                                    getSubCategoryList();
                                  });
                                },
                                hint: ""),
                            ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: screenSize.width - 64,
                          child:
                          // DropdownButton2(
                          //   dropdownMaxHeight: screenSize.height /2,
                          //   isExpanded: true,
                          //   value: subCategory,
                          //   items: subCategoryList.map((String value) {
                          //     return DropdownMenuItem(
                          //         value: value,
                          //         child: Center(
                          //           child: Text(value),
                          //         ));
                          //   }).toList(),
                          //   onChanged: (v) {
                          //     setState(() {
                          //       subCategory = v as String;
                          //       getFoodList();
                          //     });
                          //   },
                          // )
                          Selector1(
                              selectedCategory: subCategory,
                              categoryList: subCategoryList,
                              onSelect: (selectedCategory) {
                                setState(() {
                                  subCategory = selectedCategory!;
                                  getFoodList();
                                });
                              },
                              hint: "분류를 선택하세요."),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: screenSize.width - 64,
                          child:
                          // DropdownButton2(
                          //   dropdownMaxHeight: screenSize.height /2,
                          //   isExpanded: true,
                          //   value: food,
                          //   items: foodStrList.map((String value) {
                          //     return DropdownMenuItem(
                          //         value: value,
                          //         child: Center(
                          //           child: Text(value),
                          //         ));
                          //   }).toList(),
                          //   onChanged: (v) {
                          //     setState(() {
                          //       food = v as String;
                          //     });
                          //   },
                          // )
                          Selector1(
                              selectedCategory: food,
                              categoryList: foodStrList,
                              onSelect: (selectedCategory) {
                                setState(() {
                                  food = selectedCategory!;
                                });
                              },
                              hint: "음식을 선택하세요."),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: MainTextButton(
                                text: "추가",
                                backgroundColor: AppColor_Primary,
                                style: AppTextStyle.PD(Colors.white, 18,
                                    weight: FW.bold),
                                radius: 20,
                                height: 40,
                                width: 100,
                                disableBackground: AppColor_Primary_Disable,
                                onPressed: () {
                                  for (int i = 0; i < foodList.length; i++) {
                                    if (food == foodList.elementAt(i).name) {
                                      FoodDto item = foodList.elementAt(i);
                                      FoodDto dic = FoodDto();
                                      dic.id = item.id;
                                      dic.category = item.category;
                                      dic.subCategory = item.subCategory;
                                      dic.name = item.name;
                                      dic.kcal = item.kcal;
                                      dic.createdAt = item.createdAt;
                                      dic.count = 0.25;
                                      foodAddList.add(dic);
                                      count.add("0.25인분");
                                    }
                                  }
                                  checkValid();
                                  scrollDown();
                                },
                              ),
                            )),
                        const SizedBox(height: 60),
                        H16(
                          text: "계산 결과",
                          weight: FW.bold,
                          color: AppColor_BlackText,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppColor_BlackText,
                        ),
                        const SizedBox(height: 13),
                        Stack(
                          children: [
                            Visibility(
                              visible: foodAddList.isNotEmpty,
                              child: Container(
                                height: 48 * foodAddList.length.toDouble(),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: _itemBuilder,
                                  itemCount: foodAddList.length,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: foodAddList.isEmpty,
                              child: SizedBox(
                                height: 66,
                                child: Center(
                                  child: H14(
                                    text: "음식을 선택해주세요.",
                                    weight: FW.medium,
                                    color: AppColor_BlackText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 1,
                          color: AppColor_Selector_Border,
                        ),
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width -
                                      64 -
                                      120) /
                                  2,
                              height: 48,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: H14(
                                      text: "섭취 칼로리",
                                      weight: FW.bold,
                                      color: AppColor_BlackText,
                                      maxLine: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width -
                                      64 -
                                      120) /
                                  2,
                              height: 48,
                              child: Center(
                                child: H14(
                                  text: convertScore(allKalori.toString()) +
                                      " kcal",
                                  weight: FW.bold,
                                  color: AppColor_BlackText,
                                ),
                              ),
                            ),
                            const SizedBox(width: 92, height: 40),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                )),
                MainTextButton(
                  text: convertScore(allKalori.toString()) + " kcal 입력하기",
                  backgroundColor: AppColor_Primary,
                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                  radius: 0,
                  height: 66,
                  // disable: isValid,
                  // disableBackground: !isValid ? AppColorColors.transparent,
                  onPressed: () {
                    // if (!isValid) {
                    // return;
                    // }
                    final p = Provider.of<OldFoodListProvider>(context,listen: false);
                    p.changeList(widget.type!, foodAddList);
                    p.changeKcalOne(widget.type!, "${allKalori.toStringAsFixed(1)}\nkcal");

                    if (widget.type == 0) {
                      monitoringData!.foodAddList1 = foodAddList;
                      p.food1 = foodAddList;
                    } else if (widget.type == 1) {
                      monitoringData!.foodAddList2 = foodAddList;
                      p.food2 = foodAddList;
                    } else if (widget.type == 2) {
                      monitoringData!.foodAddList3 = foodAddList;
                      p.food3 = foodAddList;
                    } else if (widget.type == 3) {
                      monitoringData!.foodAddList4 = foodAddList;
                      p.food4 = foodAddList;
                    }

                    Navigator.pop(context, allKalori.toStringAsFixed(1));
                  },
                ),
              ],
            )));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    FoodDto info = foodAddList.elementAt(index);
    return Container(
        width: screenSize.width - 64,
        height: 48,
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 64 - 120) / 2,
                    height: 48,
                    child: Row(
                      children: [
                        Flexible(
                          child: H14(
                            text: info.name!,
                            weight: FW.medium,
                            color: AppColor_BlackText,
                            maxLine: 2,
                            align: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            foodAddList.removeAt(index);
                            count.removeAt(index);
                            checkValid();
                            setState(() {});
                          },
                          child: Image.asset(
                            'assets/ic_delete.png',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 64 - 120) / 2,
                    height: 48,
                    child: Center(
                      child: H14(
                        text: convertScore((double.parse(info.kcal!) * info.count!).toString()) + " kcal",
                        weight: FW.medium,
                        color: AppColor_BlackText,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: SelectorBox(
                        selectedCategory: count[index],
                        categoryList: countList,
                        onSelect: (selectedCategory) {
                          setState(() {
                            count[index] = selectedCategory!;
                            double temp = double.parse(count[index].replaceAll("인분", ""));
                            foodAddList[index].count = temp;
                            checkValid();
                          });
                        },
                        hint: "0.25인분"),
                  ),
                ],
              ),
            ),
            Container(
              height: 8,
            ),
          ],
        ));
  }
}
