import 'package:flutter/material.dart';
import 'package:ourdoctor/global/global.dart';

class GlobalProvider extends ChangeNotifier {
  String homeWeatherTemp = "";
  String homeWeatherWater = "";
  String homeWeatherDust = "";

  String topAreaHeight = "";
  String topAreaWeight = "";
  String nextDate = "";

  void changeWeather(temp, water, dust) {
    homeWeatherTemp = temp;
    homeWeatherWater = water;
    homeWeatherDust = dust;
  }

  void topAreaInfo(h, w, d) {
    topAreaHeight = h == "null" ? gSelChildInfo!.height : h;
    topAreaWeight = w == "null" ? gSelChildInfo!.weight : w;
    nextDate = d == "null" ? "0" : d;
  }
}
