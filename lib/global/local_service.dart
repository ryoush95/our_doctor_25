import 'dart:async';
import 'dart:convert';

import 'package:ourdoctor/models/dto/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static String PREF_USER = "PREF_USER";
  static String PREF_GUIDE = "PREF_GUIDE";
  static String PREF_FCM_TOKEN = "PREF_FCM_TOKEN";
  static String PREF_MONITORING_START = "PREF_MONITORING_START";
  static String PREF_PAYMENT_CARD = "PREF_PAYMENT_CARD";

  //user data
  static String PREF_USER_NAME = "PREF_USER_NAME";
  static String PREF_USER_ID = "PREF_USER_ID";
  static String PREF_USER_PWD = "PREF_USER_PWD";
  static String PREF_USER_TYPE = "PREF_USER_TYPE";
  static String PREF_USER_AREA = "PREF_USER_AREA";
  static String PREF_USER_HOSPITAL = "PREF_USER_HOSPITAL";

  static void setUser(UserDto userDto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER, json.encode(userDto.toJson()));
  }

  static void removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(PREF_USER);
  }

  static Future<UserDto?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(PREF_USER);
    if (user == null || user.isEmpty) {
      return null;
    }
    return UserDto.fromJson(json.decode(user));
  }

  static void setGuide(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_GUIDE, value);
  }

  static Future<String> getGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? guide = prefs.getString(PREF_GUIDE);
    if (guide == null || guide.isEmpty) {
      return "";
    }
    return guide;
  }

  static void setMonitoringStatus(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_MONITORING_START, value);
  }

  static Future<String> getMonitoringStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? guide = prefs.getString(PREF_MONITORING_START);
    if (guide == null || guide.isEmpty) {
      return "";
    }
    return guide;
  }

  static void setUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER_NAME, value);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(PREF_USER_NAME);
    if (name == null || name.isEmpty) {
      return "";
    }
    return name;
  }

  static void setUserID(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER_ID, value);
  }

  static Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(PREF_USER_ID);
    if (name == null || name.isEmpty) {
      return "";
    }
    return name;
  }

  static void setUserPwd(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER_PWD, value);
  }

  static Future<String> getUserPwd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pass = prefs.getString(PREF_USER_PWD);
    if (pass == null || pass.isEmpty) {
      return "";
    }
    return pass;
  }

  static void setUserType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER_TYPE, value);
  }

  static Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pass = prefs.getString(PREF_USER_TYPE);
    if (pass == null || pass.isEmpty) {
      return "";
    }
    return pass;
  }

  static void setUserArea(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER_AREA, value);
  }

  static Future<String> getUserArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? area = prefs.getString(PREF_USER_AREA);
    if (area == null || area.isEmpty) {
      return "";
    }
    return area;
  }

  static void setUserHospital(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_USER_HOSPITAL, value);
  }

  static Future<String> getUserHospital() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hospital = prefs.getString(PREF_USER_HOSPITAL);
    if (hospital == null || hospital.isEmpty) {
      return "";
    }
    return hospital;
  }

  static void setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_FCM_TOKEN, value);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PREF_FCM_TOKEN);
    if (token == null || token.isEmpty) {
      return "";
    }
    return token;
  }

  static void setPaymentCard(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(PREF_PAYMENT_CARD, value);
  }

  static Future<int> getPaymentCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? card = prefs.getInt(PREF_PAYMENT_CARD);
    if (card == null) {
      return 0;
    }
    return card;
  }
}
