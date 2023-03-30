import 'package:flutter/material.dart';

class FoodResultProvider extends ChangeNotifier {
  int _foodGraphIndex = -1;
  int get foodGraphIndex => _foodGraphIndex;

  void changeGraphIndex(index) {
    _foodGraphIndex = index;
    print("provider : $foodGraphIndex");
    notifyListeners();
  }


}