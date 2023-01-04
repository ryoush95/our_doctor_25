import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier{
  String homeWeatherTemp = "";
  String homeWeatherWater = "";
  String homeWeatherDust = "";

  void changeWeather(temp, water, dust)  {
    homeWeatherTemp = temp;
    homeWeatherWater = water;
    homeWeatherDust = dust;
  }
}