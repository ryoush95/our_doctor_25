// To parse this JSON data, do
//
//     final healthResultModel = healthResultModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MonitorHealthResultModel {
  MonitorHealthResultModel({
    required this.data,
    required this.result,
    required this.msg,
    required this.reason,
  });

  HealthResultDto data;
  int result;
  String msg;
  String reason;

  factory MonitorHealthResultModel.fromRawJson(String str) => MonitorHealthResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitorHealthResultModel.fromJson(Map<String, dynamic> json) => MonitorHealthResultModel(
    data: HealthResultDto.fromJson(json["data"]),
    result: json["result"],
    msg: json["msg"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "result": result,
    "msg": msg,
    "reason": reason,
  };
}

class HealthResultDto {
  HealthResultDto({
    required this.bigMuscle,
    required this.smallMuscle,
    required this.dlswl,
    required this.djsdj,
    required this.tkghltjd,
    required this.wkwh,
  });

  Empty bigMuscle;
  Empty smallMuscle;
  Empty dlswl;
  Empty djsdj;
  Empty tkghltjd;
  Empty wkwh;

  factory HealthResultDto.fromRawJson(String str) => HealthResultDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HealthResultDto.fromJson(Map<String, dynamic> json) => HealthResultDto(
    bigMuscle: Empty.fromJson(json["대근육"]),
    smallMuscle: Empty.fromJson(json["소근육"]),
    dlswl: Empty.fromJson(json["인지"]),
    djsdj: Empty.fromJson(json["언어"]),
    tkghltjd: Empty.fromJson(json["사회성"]),
    wkwh: Empty.fromJson(json["자조"]),
  );

  Map<String, dynamic> toJson() => {
    "대근육": bigMuscle.toJson(),
    "소근육": smallMuscle.toJson(),
    "인지": dlswl.toJson(),
    "언어": djsdj.toJson(),
    "사회성": tkghltjd.toJson(),
    "자조": wkwh.toJson(),
  };
}

class Empty {
  Empty({
    required this.score,
    required this.feedbackTitle,
    required this.feedbackDescription,
    required this.status,
  });

  int score;
  String feedbackTitle;
  String feedbackDescription;
  String status;

  factory Empty.fromRawJson(String str) => Empty.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Empty.fromJson(Map<String, dynamic> json) => Empty(
    score: json["score"],
    feedbackTitle: json["feedback_title"],
    feedbackDescription: json["feedback_description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "feedback_title": feedbackTitle,
    "feedback_description": feedbackDescription,
    "status": status,
  };
}
