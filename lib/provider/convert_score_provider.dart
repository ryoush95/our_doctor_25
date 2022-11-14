import 'package:flutter/material.dart';

class ConvertScoreProvider extends ChangeNotifier{
  double _score = 0.0;
  double get score => _score;
  int _tab = 0;
  int get tab => _tab;

  int _careTab = 0;
  int get careTab => _careTab;

  void changeScore(double s) {
    _score = s;
    notifyListeners();
  }

  void changeTab(int t) {
    _tab = t;
    notifyListeners();
  }

  void changeCareTab(int t) {
    _careTab = t;
  }
}