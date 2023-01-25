// To parse this JSON data, do
//
//     final monitoringTestListModel = monitoringTestListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MonitoringTestListModel monitoringTestListModelFromJson(String str) => MonitoringTestListModel.fromJson(json.decode(str));

String monitoringTestListModelToJson(MonitoringTestListModel data) => json.encode(data.toJson());

class MonitoringTestListModel {
  MonitoringTestListModel({
    required this.data,
    required this.result,
    required this.msg,
    required this.reason,
  });

  Data data;
  int result;
  String msg;
  String reason;

  factory MonitoringTestListModel.fromJson(Map<String, dynamic> json) => MonitoringTestListModel(
    data: Data.fromJson(json["data"]),
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

class Data {
  Data({
    required this.muscle1,
    required this.muscle2,
    required this.dlswl,
    required this.djsdj,
    required this.tkghltjd,
    required this.wkwh,
  });

  Map<String, Empty> muscle1;
  Map<String, Empty> muscle2;
  Map<String, Empty> dlswl;
  Map<String, Empty> djsdj;
  Map<String, Empty> tkghltjd;
  Map<String, Empty> wkwh;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    muscle1: Map.from(json["대근육운동"]).map((k, v) => MapEntry<String, Empty>(k, Empty.fromJson(v))),
    muscle2: Map.from(json["소근육운동"]).map((k, v) => MapEntry<String, Empty>(k, Empty.fromJson(v))),
    dlswl: Map.from(json["인지"]).map((k, v) => MapEntry<String, Empty>(k, Empty.fromJson(v))),
    djsdj: Map.from(json["언어"]).map((k, v) => MapEntry<String, Empty>(k, Empty.fromJson(v))),
    tkghltjd: Map.from(json["사회성"]).map((k, v) => MapEntry<String, Empty>(k, Empty.fromJson(v))),
    wkwh: Map.from(json["자조"]).map((k, v) => MapEntry<String, Empty>(k, Empty.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "대근육운동": Map.from(muscle1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "소근육운동": Map.from(muscle2).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "인지": Map.from(dlswl).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "언어": Map.from(djsdj).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "사회성": Map.from(tkghltjd).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "자조": Map.from(wkwh).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Empty {
  Empty({
    required this.question,
    required this.imageUrl,
  });

  String question;
  dynamic imageUrl;

  factory Empty.fromJson(Map<String, dynamic> json) => Empty(
    question: json["question"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "image_url": imageUrl,
  };
}
