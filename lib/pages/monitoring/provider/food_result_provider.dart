import 'package:flutter/material.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/food_radarchart_model.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class FoodResultProvider extends ChangeNotifier {
  final HttpService httpService = HttpService();
  int _foodGraphIndex = -1;
  int get foodGraphIndex => _foodGraphIndex;
  ChartData? foodData;

  void changeGraphIndex(index) {
    _foodGraphIndex = index;
    notifyListeners();
  }

  void setDataProvider(data) {
    foodData = data;
    notifyListeners();
  }

}