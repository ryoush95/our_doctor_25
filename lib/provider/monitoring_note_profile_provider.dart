import 'package:flutter/material.dart';
import 'package:ourdoctor/models/monitoring/heath_result_model.dart';

class MonitoringNoteProfileProvider extends ChangeNotifier{
  Map<String, RecommendList> solMapList = {};
  List<RecommendList> list = [];

  void changeSolution() {
    print(list);
    list.clear();
    solMapList.forEach((key, value) {
      list.add(value);
    });
    notifyListeners();
  }


 /* String sleep = "";
  String bodyTemp = "";
  String symptomList = "";

  void changeNoteProfile(sleepd, bodyTempd, symptomListd)  {
    sleep = sleepd == "" ? "-": sleepd;
    bodyTemp = bodyTempd == "" ? "-": bodyTempd;
    symptomList = symptomListd == "" ? "0": symptomListd;
  }*/
}