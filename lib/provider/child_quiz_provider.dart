import 'package:flutter/material.dart';

class ChildQuizProvider extends ChangeNotifier {
  List _quizList = [];
  List _resultList =[];
  List get quizList => _quizList;
  List get resultList => _resultList;

  void clearList (){
    _quizList.clear();
    _resultList.clear();
    notifyListeners();
  }

  void updateList(String quiz,String result) {
    _quizList.add(quiz);
    _resultList.add(result);
    notifyListeners();
  }


}