// To parse this JSON data, do
//
//     final monitoringTestListModel2 = monitoringTestListModel2FromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MonitoringLifeListModel {
  MonitoringLifeListModel({
    required this.data,
    required this.result,
    required this.msg,
    required this.reason,
  });

  LifeTestDto data;
  int result;
  String msg;
  String reason;

  factory MonitoringLifeListModel.fromRawJson(String str) => MonitoringLifeListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitoringLifeListModel.fromJson(Map<String, dynamic> json) => MonitoringLifeListModel(
    data: LifeTestDto.fromJson(json["data"]),
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

class LifeTestDto {
  LifeTestDto({
    required this.a1,
    required this.b1,
    required this.c1,
    required this.d1,
    required this.e1,
    required this.f1,
    required this.g1,
    required this.h1,
    required this.j1,
    required this.k1,
    required this.l1,
    required this.i1,
  });

  Map<String, A1> a1;
  Map<String, A1> b1;
  Map<String, A1> c1;
  Map<String, A1> d1;
  Map<String, A1> e1;
  Map<String, A1> f1;
  Map<String, A1> g1;
  Map<String, A1> h1;
  Map<String, A1> j1;
  Map<String, A1> k1;
  Map<String, A1> l1;
  Map<String, A1> i1;

  factory LifeTestDto.fromRawJson(String str) => LifeTestDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LifeTestDto.fromJson(Map<String, dynamic> json) => LifeTestDto(
    a1: Map.from(json["A1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    b1: Map.from(json["B1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    c1: Map.from(json["C1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    d1: Map.from(json["D1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    e1: Map.from(json["E1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    f1: Map.from(json["F1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    g1: Map.from(json["G1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    h1: Map.from(json["H1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    j1: Map.from(json["J1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    k1: Map.from(json["K1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    l1: Map.from(json["L1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
    i1: Map.from(json["I1"]).map((k, v) => MapEntry<String, A1>(k, A1.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "A1": Map.from(a1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "B1": Map.from(b1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "C1": Map.from(c1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "D1": Map.from(d1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "E1": Map.from(e1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "F1": Map.from(f1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "G1": Map.from(g1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "H1": Map.from(h1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "J1": Map.from(j1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "K1": Map.from(k1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "L1": Map.from(l1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "I1": Map.from(i1).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class A1 {
  A1({
    required this.question,
    required this.imageUrl,
  });

  String question;
  dynamic imageUrl;

  factory A1.fromRawJson(String str) => A1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory A1.fromJson(Map<String, dynamic> json) => A1(
    question: json["question"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "image_url": imageUrl,
  };
}
