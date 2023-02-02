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
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.j,
    this.k,
    this.l,
    this.i,
  });

  Map<String, A>? a;
  Map<String, A>? b;
  Map<String, A>? c;
  Map<String, A>? d;
  Map<String, A>? e;
  Map<String, A>? f;
  Map<String, A>? g;
  Map<String, A>? h;
  Map<String, A>? j;
  Map<String, A>? k;
  Map<String, A>? l;
  Map<String, A>? i;

  factory LifeTestDto.fromRawJson(String str) => LifeTestDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LifeTestDto.fromJson(Map<String, dynamic> json) => LifeTestDto(
    a: Map.from(json["A"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    b: Map.from(json["B"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    c: Map.from(json["C"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    d: Map.from(json["D"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    e: Map.from(json["E"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    f: Map.from(json["F"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    g: Map.from(json["G"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    h: Map.from(json["H"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    j: Map.from(json["J"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    k: Map.from(json["K"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    l: Map.from(json["L"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
    i: Map.from(json["I"]!).map((k, v) => MapEntry<String, A>(k, A.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "A": Map.from(a!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "B": Map.from(b!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "C": Map.from(c!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "D": Map.from(d!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "E": Map.from(e!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "F": Map.from(f!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "G": Map.from(g!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "H": Map.from(h!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "J": Map.from(j!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "K": Map.from(k!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "L": Map.from(l!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "I": Map.from(i!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class A {
  A({
    required this.question,
    required this.imageUrl,
  });

  String question;
  String? imageUrl;

  factory A.fromRawJson(String str) => A.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory A.fromJson(Map<String, dynamic> json) => A(
    question: json["question"] ?? "",
    imageUrl: json["image_url"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "image_url": imageUrl,
  };
}