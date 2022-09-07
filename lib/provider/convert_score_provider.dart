import 'package:flutter/material.dart';

class ConvertScoreProvider extends ChangeNotifier{
  double _score = 0.0;
  double get score => _score;

  void changeScore(double s) {
    _score = s;
    notifyListeners();
  }
}