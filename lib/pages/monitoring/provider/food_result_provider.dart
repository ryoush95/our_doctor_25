import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/models/monitoring/food_radarchart_model.dart';

class FoodResultProvider extends ChangeNotifier {
  final HttpService httpService = HttpService();
  int _foodGraphIndex = -1;
  int get foodGraphIndex => _foodGraphIndex;
  ChartData? foodData;
  List<double> main = [0, 0, 0, 0, 0];
  List<double> average = [0, 0, 0, 0, 0];
  List<Comment?> commentList = [null, null, null, null, null];
  String? selDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void changeGraphIndex(index) {
    _foodGraphIndex = index;
    notifyListeners();
  }

  void changeGraphIndex2(index) {
    _foodGraphIndex = index;
  }

  void changeSelDate(date) {
    selDate = date;
  }

  void setDataProvider(data) {
    foodData = data;
    notifyListeners();
  }
}
