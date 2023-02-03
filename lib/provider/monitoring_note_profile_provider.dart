import 'package:flutter/material.dart';

class MonitoringNoteProfileProvider extends ChangeNotifier{
  String sleep = "";
  String bodyTemp = "";
  String symptomList = "";

  void changeNoteProfile(sleepd, bodyTempd, symptomListd)  {
    sleep = sleepd == "" ? "-": sleepd;
    bodyTemp = bodyTempd == "" ? "-": bodyTempd;
    symptomList = symptomListd == "" ? "0": symptomListd;
  }
}