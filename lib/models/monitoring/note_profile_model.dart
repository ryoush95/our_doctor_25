// To parse this JSON data, do
//
//     final topAreaModel = topAreaModelFromJson(jsonString);

import 'dart:convert';

class NoteProfileModel {
  NoteProfileModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  MonitoringProfileDto? data;
  int? result;
  String? msg;
  String? reason;

  factory NoteProfileModel.fromRawJson(String str) => NoteProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NoteProfileModel.fromJson(Map<String, dynamic> json) => NoteProfileModel(
    data: json["data"] == null ? null : MonitoringProfileDto.fromJson(json["data"]),
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

class MonitoringProfileDto {
  MonitoringProfileDto({
    this.monitoringProgress,
    this.monitoringStatus,
    this.todayNote,
    this.health,
    this.development,
    this.lifestyle,
    this.sleep,
    this.food,
    this.temperature,
    this.symptomList,
  });

  int? monitoringProgress;
  MonitoringStatus? monitoringStatus;
  bool? todayNote;
  Development? health;
  Development? development;
  Lifestyle? lifestyle;
  Lifestyle? sleep;
  Lifestyle? food;
  Temperature? temperature;
  List<dynamic>? symptomList;

  factory MonitoringProfileDto.fromRawJson(String str) => MonitoringProfileDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitoringProfileDto.fromJson(Map<String, dynamic> json) => MonitoringProfileDto(
    monitoringProgress: json["monitoringProgress"],
    monitoringStatus: json["monitoringStatus"] == null ? null : MonitoringStatus.fromJson(json["monitoringStatus"]),
    todayNote: json["todayNote"],
    health: json["health"] == null ? null : Development.fromJson(json["health"]),
    development: json["development"] == null ? null : Development.fromJson(json["development"]),
    lifestyle: json["lifestyle"] == null ? null : Lifestyle.fromJson(json["lifestyle"]),
    sleep: json["sleep"] == null ? null : Lifestyle.fromJson(json["sleep"]),
    food: json["food"] == null ? null : Lifestyle.fromJson(json["food"]),
    temperature: json["temperature"] == null ? null : Temperature.fromJson(json["temperature"]),
    symptomList: json["symptom_list"] == null ? [] : List<dynamic>.from(json["symptom_list"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "monitoringProgress" : monitoringProgress,
    "monitoringStatus": monitoringStatus?.toJson(),
    "todayNote": todayNote,
    "health": health?.toJson(),
    "development": development?.toJson(),
    "lifestyle": lifestyle?.toJson(),
    "sleep": sleep?.toJson(),
    "food": food?.toJson(),
    "temperature": temperature?.toJson(),
    "symptom_list": symptomList == null ? [] : List<dynamic>.from(symptomList!.map((x) => x)),
  };
}

class Development {
  Development({
    this.score,
    this.status,
  });

  int? score;
  String? status;

  factory Development.fromRawJson(String str) => Development.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Development.fromJson(Map<String, dynamic> json) => Development(
    score: json["score"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "status": status,
  };
}

class Lifestyle {
  Lifestyle({
    this.status,
  });

  String? status;

  factory Lifestyle.fromRawJson(String str) => Lifestyle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Lifestyle.fromJson(Map<String, dynamic> json) => Lifestyle(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}

class MonitoringStatus {
  MonitoringStatus({
    this.lastMonitoring,
    this.nextMonitoring,
  });

  int? lastMonitoring;
  int? nextMonitoring;

  factory MonitoringStatus.fromRawJson(String str) => MonitoringStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitoringStatus.fromJson(Map<String, dynamic> json) => MonitoringStatus(
    lastMonitoring: json["last_monitoring"],
    nextMonitoring: json["next_monitoring"],
  );

  Map<String, dynamic> toJson() => {
    "last_monitoring": lastMonitoring,
    "next_monitoring": nextMonitoring,
  };
}

class Temperature {
  Temperature({
    this.temperature,
    this.status,
  });

  String? temperature;
  String? status;

  factory Temperature.fromRawJson(String str) => Temperature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
    temperature: json["temperature"].toString(),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "temperature": temperature,
    "status": status,
  };
}
