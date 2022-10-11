import 'package:flutter/material.dart';

class ConvertScoreProvider extends ChangeNotifier{
  double _score = 0.0;
  double get score => _score;
  int _tab = 0;
  int get tab => _tab;

  void changeScore(double s) {
    _score = s;
    notifyListeners();
  }

  void changeTab(int t) {
    _tab = t;
    notifyListeners();
  }
}