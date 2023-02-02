// To parse this JSON data, do
//
//     final monitorHealthResultModel = monitorHealthResultModelFromJson(jsonString);

import 'dart:convert';

class MonitoringHealthListModel {
  MonitoringHealthListModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Map<String, Map<String, HealthTestDto>>? data;
  int? result;
  String? msg;
  String? reason;

  factory MonitoringHealthListModel.fromRawJson(String str) => MonitoringHealthListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitoringHealthListModel.fromJson(Map<String, dynamic> json) => MonitoringHealthListModel(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, Map<String, HealthTestDto>>(k, Map.from(v).map((k, v) => MapEntry<String, HealthTestDto>(k, HealthTestDto.fromJson(v))))),
    result: json["result"],
    msg: json["msg"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, Map.from(v).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
    "result": result,
    "msg": msg,
    "reason": reason,
  };
}

class HealthTestDto {
  HealthTestDto({
    this.question,
    this.imageUrl,
  });

  String? question;
  String? imageUrl;

  factory HealthTestDto.fromRawJson(String str) => HealthTestDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HealthTestDto.fromJson(Map<String, dynamic> json) => HealthTestDto(
    question: json["question"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "image_url": imageUrl,
  };
}
