// To parse this JSON data, do
//
//     final foodCheckList2 = foodCheckList2FromJson(jsonString);

import 'dart:convert';

class FoodCheckList2 {
  FoodCheckList2({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Map<String, FoodCheck2>? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodCheckList2.fromRawJson(String str) => FoodCheckList2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodCheckList2.fromJson(Map<String, dynamic> json) => FoodCheckList2(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, FoodCheck2>(k, FoodCheck2.fromJson(v))),
    result: json["result"],
    msg: json["msg"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "result": result,
    "msg": msg,
    "reason": reason,
  };
}

class FoodCheck2 {
  FoodCheck2({
    this.question,
  });

  String? question;
  String answer = "0";

  factory FoodCheck2.fromRawJson(String str) => FoodCheck2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodCheck2.fromJson(Map<String, dynamic> json) => FoodCheck2(
    question: json["question"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
  };
}
