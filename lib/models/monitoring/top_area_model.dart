// To parse this JSON data, do
//
//     final topAreaModel = topAreaModelFromJson(jsonString);

import 'dart:convert';

class TopAreaModel {
  TopAreaModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  TopAreaDto? data;
  int? result;
  String? msg;
  String? reason;

  factory TopAreaModel.fromRawJson(String str) => TopAreaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TopAreaModel.fromJson(Map<String, dynamic> json) => TopAreaModel(
    data: json["data"] == null ? null : TopAreaDto.fromJson(json["data"]),
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

class TopAreaDto {
  TopAreaDto({
    this.height,
    this.weight,
    this.lastMonitoring,
    this.nextMonitoring,
  });

  String? height;
  String? weight;
  String? lastMonitoring;
  String? nextMonitoring;

  factory TopAreaDto.fromRawJson(String str) => TopAreaDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TopAreaDto.fromJson(Map<String, dynamic> json) => TopAreaDto(
    height: json["height"].toString(),
    weight: json["weight"].toString(),
    lastMonitoring: json["last_monitoring"].toString(),
    nextMonitoring: json["next_monitoring"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "weight": weight,
    "last_monitoring": lastMonitoring,
    "next_monitoring": nextMonitoring,
  };
}
