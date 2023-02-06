import 'package:flutter/material.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/monitoring/note_profile_model.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class GlobalProvider extends ChangeNotifier {
  final HttpService httpService = HttpService();
  MonitoringProfileDto? profile;

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

  Future<void> getNoteInfo(context) async {

    Future<NoteProfileModel> info = httpService.getMonitoringStatus();
    info.then((NoteProfileModel value) async {
      if (value.result == 0) {
        profile = value.data!;
        notifyListeners();
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }
}
