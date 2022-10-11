// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:ourdoctor/pages/dialog/dlg_phone_list.dart';
import 'package:package_info/package_info.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

void showToast(String msg) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14.0);
}

String enumToString(value) {
  return value.toString().split('.').last;
}

String formatAmount(int num) {
  NumberFormat format = new NumberFormat("#,###");
  return format.format(num);
}

double doubleParse(dynamic val) {
  if (val == null) return 0;

  if (val.runtimeType == double) {
    return val;
  }

  return double.parse(val);
}

Future<String> getVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

bool keyboardIsVisible(BuildContext context) {
  return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
}

Future<String> getShareUrl(int _uid) async {
  var result = "";

  // Todo yj
  /*
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://semari.page.link',
    link: Uri.parse('https://semari.com/detail?id=' + _uid.toString()),
    androidParameters: AndroidParameters(
      packageName: 'com.kyad.semari',
      minimumVersion: 1,
    ),
    dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
    ),
    iosParameters: IosParameters(
      bundleId: 'com.kyad.semari',
      minimumVersion: '1.0.0',
      appStoreId: '1597695150',
    ),
  );

  final ShortDynamicLink shortLink = await parameters.buildShortLink();
  Uri url = shortLink.shortUrl;
  result = url.toString();
   */
  return result;
}

bool validPwd(String pwd) {
  String pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(pwd);
}

bool validPhone(String phone) {
  String pattern = r"^01(?:0|1|[6-9])[-\\s\\.]?[0-9]{4}[-\\s\\.]?[0-9]{4}$";
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phone);
}

String getAreaName(String name) {
  String result = "";
  if (name == "gangnam") {
    result = "강남구";
  } else if (name == "guro") {
    result = "구로구";
  } else if (name == "seongbuk") {
    result = "성북구";
  }

  return result;
}

String getAge(String birth) {
  String result = "";
  if (birth == "") {
    return "";
  }
  var arr = birth.substring(0, 4);
  int nYear = int.parse(arr);
  var dt = DateTime.now();
  int curYear = dt.year;
  int diff = curYear - nYear;
  diff = diff;
  result = diff.toString();

  return result;
}

Future<void> callPhone(
  BuildContext context,
) async {
  //UrlLauncher.launch("tel://" + phone);
  var _result = await showDialog(context: context, builder: (_) => PhoneListDialog());
  if (_result != null && _result != "") {
    UrlLauncher.launch("tel://" + _result);
  }
}

String getRandomImg() {
  String result = "";
  List<String> imgs = ['assets/group_19975.png', 'assets/group_19976.png', 'assets/group_19977.png', 'assets/group_20021.png', 'assets/group_20025.png'];
  Random random = new Random();
  int randomNumber = random.nextInt(5);
  if (randomNumber < 0) {
    randomNumber = 0;
  }
  if (randomNumber > 4) {
    randomNumber = 4;
  }
  result = imgs.elementAt(randomNumber);
  return result;
}

//오전 오후 시간 얻기
bool isMorning() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return true;
  } else {
    return false;
  }
}

//재택치료 남은 일 게산
int getLeffDay() {
  int diffday = 0;

  if (gSelChildInfo!.monitoringDate! == "") {
    return diffday;
  }

  var arr = gSelChildInfo!.monitoringDate!.split("-");
  int year = int.parse(arr[0]);
  int moth = int.parse(arr[1]);
  int day = int.parse(arr[2]);
  var date = DateTime(year, moth, day);

  final date1 = DateTime(date.year, date.month, date.day + 8);
  final date2 = DateTime.now();
  diffday = date1.difference(date2).inDays;
  if (diffday < 0 || diffday > 7) {
    diffday = 0;
  }

  return diffday;
}

//재택치료 남은 일 % 게산
double getLeffDayRate() {
  double result = 0;
  int diffday = 0;
  int allday = 7;

  if (gSelChildInfo!.monitoringDate! == "") {
    return 1.0;
  }

  String temp = gSelChildInfo!.monitoringDate!.replaceAll("-", "");
  int year = int.parse(temp.substring(0, 4));
  int moth = int.parse(temp.substring(4, 6));
  int day = int.parse(temp.substring(6, 8));
  var date = DateTime(year, moth, day);

  final date1 = DateTime(date.year, date.month, date.day + 8);
  final date2 = DateTime.now();
  diffday = date1.difference(date2).inDays;
  if (diffday < 0 || diffday > 7) {
    return 1.0;
  }

  result = 1 - (diffday / allday);

  return result;
}

//기침 외 3개
String getSymptomsContent(String data) {
  String result = "";

  if (data == "") {
    return "";
  }

  if (data == "-1") {
    return "없음";
  }

  var arr = data.split(",");
  if (arr.length == 1) {
    return arr[0];
  } else {
    result = arr[0] + " 외 " + (arr.length - 1).toString() + "개";
  }

  return result;
}

// 체온 상태 얻기
String getTemperatureStatus(String data) {
  String result = "";

  if (data == "") {
    return "미측정";
  }

  double value = double.parse(data.trim());
  if (value >= 37.8 && value <= 38.4) {
    result = "주의";
  } else if (value >= 38.5) {
    result = "위험";
  } else {
    result = "정상";
  }

  return result;
}

// 산소 상태 얻기
String getOxygenStatus(String data) {
  String result = "";

  if (data == "") {
    return "미측정";
  }

  if (data == "-1") {
    return "정상";
  }

  double value = double.parse(data.trim());
  if (value >= 90.1 && value <= 94.9) {
    result = "주의";
  } else if (value <= 90) {
    result = "위험";
  } else {
    result = "정상";
  }

  return result;
}

// 복약 상태 얻기
String getMedicationStatus(String data) {
  if (data == "") {
    return "미측정";
  } else if (data == "-1") {
    return "정상";
  } else {
    return "주의";
  }
}

// 증상 상태 얻기
String getSymptomsStatus(String data) {
  if (data == "-1") {
    return "정상";
  }

  var arr = data.split(",");
  if (arr.isEmpty) {
    return "정상";
  } else {
    return "주의";
  }
}

// 호흡수 상태 얻기
String getBreathStatus(String data) {
  String result = "";
  if (data == "") {
    return "미측정";
  }

  if (data == "-1") {
    return "정상";
  }

  var arr = gUserInfo!.birth!.split("-");
  int nYear = int.parse(arr[0]);
  var dt = DateTime.now();
  int curYear = dt.year;
  int myAge = curYear - nYear;
  myAge = myAge - 1;

  int breathCnt = int.parse(data);
  if (myAge < 6) {
    if (breathCnt >= 40) {
      result = "위험";
    } else if (breathCnt >= 29 && breathCnt <= 39) {
      result = "주의";
    } else {
      result = "정상";
    }
  } else if (myAge >= 6 && myAge <= 10) {
    if (breathCnt >= 40) {
      result = "위험";
    } else if (breathCnt >= 26 && breathCnt <= 39) {
      result = "주의";
    } else {
      result = "정상";
    }
  } else {
    if (breathCnt >= 40) {
      result = "위험";
    } else if (breathCnt >= 25 && breathCnt <= 39) {
      result = "주의";
    } else {
      result = "정상";
    }
  }
  // } else if (myAge >= 11 && myAge <= 15) {
  //   if (breathCnt >= 40) {
  //     result = "위험";
  //   } else if (breathCnt >= 25 && breathCnt <= 39) {
  //     result = "주의";
  //   } else {
  //     result = "정상";
  //   }
  // }

  return result;
}

//상태에 따르는 색표시
Color getStatusColor(String status) {
  if (status == "미측정") {
    return const Color(0xFF111112);
  } else if (status == "주의") {
    return const Color(0xFFFFB238);
  } else if (status == "위험") {
    return const Color(0xFFFF3838);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

//상태에 따르는 색표시
Color getValueColor(int index) {
  if (index == 0) {
    return const Color(0xFF111112);
  } else if (index == 1) {
    return const Color(0xFFFFCE20);
  } else if (index == 2) {
    return const Color(0xFFFF3838);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

//주민등록번호 변경  000000-0000000 -> 000000 - *******
String getJuminNum(String num) {
  var result = "";
  num = num.replaceAll(" ", "");
  var arr = num.split("-");
  if (arr.length == 1) {
    result = arr[0];
  } else {
    result = arr[0] + "-";
    for (int i = 0; i < arr[1].length; i++) {
      result = result + "*";
    }
  }

  return result;
}

String diffTime(String regTime) {
  int diffSeconds = 0;
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String curDate = dateFormat.format(now);

  DateTime date1 = dateFormat.parse(regTime);
  DateTime date2 = dateFormat.parse(curDate);
  diffSeconds = date2.difference(date1).inSeconds;

  if (diffSeconds < 60) {
    return "방금";
  } else if (diffSeconds < 60 * 60) {
    return (diffSeconds ~/ 60).toString() + "분 전";
  } else if (diffSeconds < 60 * 60 * 24) {
    return (diffSeconds ~/ 60 ~/ 60).toString() + "시간 전";
  } else if (diffSeconds < 60 * 60 * 24 * 2) {
    return (diffSeconds ~/ 60 ~/ 60 ~/ 24).toString() + "일 전";
    // var arr = regTime.split(" ");
    // if (arr.length == 1) {
    //   return regTime;
    // } else {
    //   return arr[0];
    // }
  // } else if (diffSeconds < 60 * 60 * 60 * 24 * 2) {s
  // } else if (date2.difference(date1).inDays < 365) {
  } else if (diffSeconds < 60 * 60 * 24 * 365) {
    return setDateFormat(DateTime.parse(regTime), true);
  } else if(diffSeconds >= 60 * 60 * 24 * 365) {
    return setDateFormat(DateTime.parse(regTime), false);
  }
  // } else if (diffSeconds < 60 * 60 * 60 * 24 * 365 ) {
  //   // return (diffSeconds ~/ 60 ~/ 60 ~/ 24 ~/ 7).toString() + "주 전";
  //   return setDateFormat(DateTime.parse(regTime), true);
  // } else if (diffSeconds >= 60 * 60 * 60 * 24 * 365) {
  //   // return (diffSeconds ~/ 60 ~/ 60 ~/ 24 ~/ 365).toString() + "년 전";
  //    return setDateFormat(DateTime.parse(regTime), false);
  // }
  return '';
}

int checkSelDate(String date) {
  int diffDays = 0;
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String curDate = dateFormat.format(now);

  DateTime date1 = dateFormat.parse(date);
  DateTime date2 = dateFormat.parse(curDate);
  diffDays = date2.difference(date1).inDays;

  return diffDays;
}

int getDateCount() {
  if (gSelChildInfo!.createdAt! == "") {
    return 7;
  }

  final date1 = DateFormat("yyyy-MM-dd").parse(gSelChildInfo!.createdAt!);
  final date2 = DateTime.now();
  int diffday = date2.difference(date1).inDays + 1;
  if (diffday < 7) {
    return diffday;
  } else {
    return 7;
  }
}

bool getPossibleDate(DateTime selDate) {
  if (gSelChildInfo!.createdAt! == "") {
    return false;
  }

  String temp = DateFormat('yyyy-MM-dd').format(selDate);
  final date1 = DateFormat("yyyy-MM-dd").parse(gSelChildInfo!.createdAt!);
  final date2 = DateFormat("yyyy-MM-dd").parse(temp);
  int diffday = date2.difference(date1).inDays;
  if (diffday < 0) {
    return false;
  } else {
    return true;
  }
}

String ValidPrice(String value) {
  String result = "";
  String subdot = "";
  if (value.length == 0) return "0";
  if (value.indexOf(".") >= 0) {
    subdot = value.substring(value.indexOf("."), value.length);
    value = value.substring(0, value.indexOf("."));
  }
  for (var i = 0; i < value.length; i++) {
    result += value[value.length - i - 1];
    if (i % 3 == 2 && i + 1 != value.length) result += ",";
  }
  String result1 = "";
  for (var i = 0; i < result.length; i++) {
    result1 += result[result.length - i - 1];
  }
  //return result1 + subdot;
  return result1;
}

//나이 계산
String getChildAge(int value) {
  String result = "";

  double fValue = value / 12;
  int temp = fValue.toInt();
  result = temp.toString();
  return result;
}

String getDateFormatString(DateTime date, String format) {
  initializeDateFormatting();
  return DateFormat(format, "ko").format(date);
}

String convertDate(String date) {
  if (date.length < 10) {
    return date;
  }

  String temp = date.substring(0, 10);

  return temp.replaceAll("-", ".");
}

int getResFromString(String status) {
  String s = status;
  // if (status.contains('과신장') || status.contains('저체중')) {
  //   s = "Y";
  // } else if (status.contains('정상')) {
  //   s = "";
  // } else {
  //   s = "R";
  // }
  if (s == "Y") {
    return 0;
  } else if (s == "R") {
    return 2;
  } else {
    return 1;
  }
}

Color getColorFromString(String status) {
  if (status == "Y") {
    return const Color(0xFFFFCE20);
  } else if (status == "R") {
    return const Color(0xFFFF3838);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

Color getColorFromString1(String status) {
  if (status == "주의") {
    return const Color(0xFFFFCE20);
  } else if (status == "부족") {
    return const Color(0xFFFF3838);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

Color getColorFromString2(String status) {
  if (status == "부족") {
    return const Color(0xFFFF3838);
  } else if (status == "과다") {
    return const Color(0xFFFFCE20);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

Color getColorFromHeight(String status) {
  if ( status == "과신장") {
    return const Color(0xFFFFCE20);
  } else if (status == "의학적 저신장" || status == "부모마음 저신장") {
    return const Color(0xFFFF3838);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

Color getColorFromWeight(String status) {
  if (status == "의학적 저체중" || status == "부모마음 저체중") {
    return const Color(0xFFFFCE20);
  } else if (status == "과체중" || status == "비만") {
    return const Color(0xFFFF3838);
  } else {
    return const Color(0xFF4B9EFF);
  }
}

String getStatusFromString(String status) {
  if (status == "Y") {
    return "주의";
  } else if (status == "R") {
    return "부족";
  } else {
    return "충분";
  }
}

String convertScore(String score) {
  double hrs = fromJsonDouble(score);
  if (hrs - hrs.toInt() == 0.0) {
    return sprintf("%d", [hrs.toInt()]);
  }
  return sprintf("%.1f", [hrs]);
}

String roundOff(String value) {
  double num = double.parse(value);
  int res = num.floor();

  return res.toString(); 
}

//몇개월 이상인지 체크
bool isMoreBirth(int diff) {
  final childBirth = DateFormat("yyyy-MM-dd").parse(gSelChildInfo!.birth!);
  int year = DateTime.now().year;
  year = year - diff;
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  String diffDate = sprintf("%02d-%02d-%02d", [year, month, day]);
  final curDate = DateFormat("yyyy-MM-dd").parse(diffDate);

  int diffday = curDate.difference(childBirth).inDays;
  if (diffday > 0) {
    return true;
  } else {
    return false;
  }
}

//몇개월 이상인지 체크
bool isMoreBirth1(int diff) {
  final childBirth = DateFormat("yyyy-MM-dd").parse(gSelChildInfo!.birth!);
  var newDate = DateTime(childBirth.year, childBirth.month + diff, childBirth.day);
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  String diffDate = sprintf("%02d-%02d-%02d", [year, month, day]);
  final curDate = DateFormat("yyyy-MM-dd").parse(diffDate);

  int diffday = curDate.difference(newDate).inDays;
  if (diffday >= 0) {
    return true;
  } else {
    return false;
  }
}

String setDateFormat(DateTime date, bool currYear) {
  if(currYear) {
    return DateFormat('M월 d일').format(date);
  } else {
    return DateFormat('yyyy년 M월 d일').format(date);
  }
}


