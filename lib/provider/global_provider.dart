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
  String lifeIcon = "assets/icon_bad.png";
  String lifeText = "노력이 필요해요";

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

  void changeLife(String s) {
    if(s == "R"){
      lifeIcon = "assets/icon_bad.png";
      lifeText = "노력이 필요해요";
    } else if(s=="G"){
      lifeIcon = "assets/icon_normal.png";
      lifeText = "보통이에요";
    } else {
      lifeIcon = "assets/icon_good.png";
      lifeText = "아주 좋아요";
    }
  }

  void changeReTest(int i) {
    profile!.monitoringProgress = i;
    notifyListeners();
  }

  Future<void> getNoteInfo(context) async {
    Future<NoteProfileModel> info = httpService.getMonitoringStatus();
    await info.then((NoteProfileModel value) async {
      if (value.result == 0) {
        profile = value.data!;
        changeLife(profile!.lifestyle!.status!);
        notifyListeners();
      } else {
        if (value.result != 106) {
          showToast(value.msg ?? "");
          //token expired
          // Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        } else {

        }
      }
    }).catchError((onError) {
      print(onError.toString());
    });
  }
}
