// To parse this JSON data, do
//
//     final foodChekcList1 = foodChekcList1FromJson(jsonString);

import 'dart:convert';

class FoodCheckList1 {
  FoodCheckList1({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Map<String, FoodCheck1>? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodCheckList1.fromRawJson(String str) => FoodCheckList1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodCheckList1.fromJson(Map<String, dynamic> json) => FoodCheckList1(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, FoodCheck1>(k, FoodCheck1.fromJson(v))),
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

class FoodCheck1 {
  FoodCheck1({
    this.question,
    this.choices,
  });

  String? question;
  String? choices;
  String answer = "-1";

  factory FoodCheck1.fromRawJson(String str) => FoodCheck1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodCheck1.fromJson(Map<String, dynamic> json) => FoodCheck1(
    question: json["question"],
    choices: json["choices"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "choices": choices,
  };
}
