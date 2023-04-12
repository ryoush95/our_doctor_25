// To parse this JSON data, do
//
//     final foodHomeModel = foodHomeModelFromJson(jsonString);

import 'dart:convert';

class FoodHomeModel {
  FoodHomeModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  FoodHomeData? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodHomeModel.fromRawJson(String str) =>
      FoodHomeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodHomeModel.fromJson(Map<String, dynamic> json) => FoodHomeModel(
        data: json["data"] == null ? null : FoodHomeData.fromJson(json["data"]),
        result: json["result"],
        msg: json["msg"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "result": result,
        "msg": msg,
        "reason": reason,
      };
}

class FoodHomeData {
  FoodHomeData({
    this.title,
    this.calendar,
    this.food,
    this.habits,
  });

  String? title;
  List<DateTime>? calendar;
  Map<String, StatusItem>? food;
  Habits? habits;

  factory FoodHomeData.fromRawJson(String str) =>
      FoodHomeData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodHomeData.fromJson(Map<String, dynamic> json) => FoodHomeData(
        title: json["title"] ?? "",
        calendar: json["calendar"] == null
            ? []
            : List<DateTime>.from(json["calendar"]!.map((x) {
                DateTime parse1 = DateTime.parse(x);
                parse1 = DateTime.utc(parse1.year, parse1.month, parse1.day);
                return parse1;
              })),
        food: Map.from(json["food"]!).map(
            (k, v) => MapEntry<String, StatusItem>(k, StatusItem.fromJson(v))),
        habits: json["habits"] == null ? null : Habits.fromJson(json["habits"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "calendar": calendar == null
            ? []
            : List<dynamic>.from(calendar!.map((x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "food": Map.from(food!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "habits": habits?.toJson(),
      };
}

class StatusItem {
  StatusItem({
    this.status,
    this.text,
  });

  String? status;
  String? text;

  factory StatusItem.fromRawJson(String str) =>
      StatusItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatusItem.fromJson(Map<String, dynamic> json) => StatusItem(
        status: json["status"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "text": text,
      };
}

class Habits {
  Habits({
    this.lastMonitoring,
    this.score,
    this.missions,
  });

  DateTime? lastMonitoring;
  StatusItem? score;
  Map<String, Mission>? missions;

  factory Habits.fromRawJson(String str) => Habits.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Habits.fromJson(Map<String, dynamic> json) => Habits(
        lastMonitoring: json["last_monitoring"] == null
            ? null
            : DateTime.parse(json["last_monitoring"]),
        score:
            json["score"] == null ? null : StatusItem.fromJson(json["score"]),
        missions: Map.from(json["missions"]!)
            .map((k, v) => MapEntry<String, Mission>(k, Mission.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "last_monitoring":
            "${lastMonitoring!.year.toString().padLeft(4, '0')}-${lastMonitoring!.month.toString().padLeft(2, '0')}-${lastMonitoring!.day.toString().padLeft(2, '0')}",
        "score": score?.toJson(),
        "missions": Map.from(missions!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Mission {
  Mission({
    this.text,
    this.complete,
  });

  String? text;
  bool? complete;

  factory Mission.fromRawJson(String str) => Mission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        text: json["text"] ?? "",
        complete: json["complete"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "complete": complete,
      };
}
