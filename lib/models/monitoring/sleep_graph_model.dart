// To parse this JSON data, do
//
//     final monitorHealthResultModel = monitorHealthResultModelFromJson(jsonString);

import 'dart:convert';

class SleepGraphModel {
  SleepGraphModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  SleepDataDto? data;
  int? result;
  String? msg;
  String? reason;

  factory SleepGraphModel.fromRawJson(String str) => SleepGraphModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SleepGraphModel.fromJson(Map<String, dynamic> json) => SleepGraphModel(
    data: json["data"] == null ? null : SleepDataDto.fromJson(json["data"]),
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

class SleepDataDto {
  SleepDataDto({
    this.avgSleepLaunch,
    this.avgSleepNight,
    this.yesterdaySleepNight,
    this.yesterdaySleepLaunch,
    this.graphSleep,
  });

  int? avgSleepLaunch;
  int? avgSleepNight;
  String? yesterdaySleepNight;
  String? yesterdaySleepLaunch;
  List<GraphSleep>? graphSleep;

  factory SleepDataDto.fromRawJson(String str) => SleepDataDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SleepDataDto.fromJson(Map<String, dynamic> json) => SleepDataDto(
    avgSleepLaunch: json["avg_sleep_launch"],
    avgSleepNight: json["avg_sleep_night"],
    yesterdaySleepNight: json["yesterday_sleep_night"] ?? "0",
    yesterdaySleepLaunch: json["yesterday_sleep_launch"] ?? "0",
    graphSleep: json["graph_sleep"] == null ? [] : List<GraphSleep>.from(json["graph_sleep"]!.map((x) => GraphSleep.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "avg_sleep_launch": avgSleepLaunch,
    "avg_sleep_night": avgSleepNight,
    "yesterday_sleep_night": yesterdaySleepNight,
    "yesterday_sleep_launch": yesterdaySleepLaunch,
    "graph_sleep": graphSleep == null ? [] : List<dynamic>.from(graphSleep!.map((x) => x.toJson())),
  };
}

class GraphSleep {
  GraphSleep({
    this.date,
    this.sleepNight,
    this.sleepLaunch,
  });

  String? date;
  int? sleepNight;
  int? sleepLaunch;

  factory GraphSleep.fromRawJson(String str) => GraphSleep.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GraphSleep.fromJson(Map<String, dynamic> json) => GraphSleep(
    date: json["date"],
    sleepNight: json["sleep_night"],
    sleepLaunch: json["sleep_launch"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "sleep_night": sleepNight,
    "sleep_launch": sleepLaunch,
  };
}
