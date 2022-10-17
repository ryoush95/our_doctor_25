import 'package:flutter/material.dart';
import 'package:ourdoctor/models/food_list_res_model.dart';

class OldFoodListProvider extends ChangeNotifier {
  List<FoodDto> food1 = [];
  List<FoodDto> food2 = [];
  List<FoodDto> food3 = [];
  List<FoodDto> food4 = [];
  List<String> kcalList = <String>["", "", "", ""];

  void changeList(int i, List<FoodDto> list) {
    switch (i) {
      case 0:
        food1 = list;
        return;
      case 1:
        food2 = list;
        return;
      case 2:
        food3 = list;
        return;
      case 3:
        food4 = list;
        return;
    }
    notifyListeners();
  }

  void changeKcalList(List<String> list) {
    kcalList = list;
    notifyListeners();
  }

  void changeKcalOne(int i, String k){
    kcalList[i] = k;
    notifyListeners();
  }

  void clearList() {
    food1.clear();
    food2.clear();
    food3.clear();
    food4.clear();
    notifyListeners();
  }
}
