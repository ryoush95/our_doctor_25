// To parse this JSON data, do
//
//     final foodListModel = foodListModelFromJson(jsonString);

import 'dart:convert';

class FoodListModel {
  FoodListModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  FoodListDto? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodListModel.fromRawJson(String str) => FoodListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodListModel.fromJson(Map<String, dynamic> json) => FoodListModel(
    data: json["data"] == null ? null : FoodListDto.fromJson(json["data"]),
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

class FoodListDto {
  FoodListDto({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
    this.comment,
  });

  String? breakfast;
  String? lunch;
  String? dinner;
  String? snack;
  String? comment;

  factory FoodListDto.fromRawJson(String str) => FoodListDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodListDto.fromJson(Map<String, dynamic> json) => FoodListDto(
    breakfast: json["breakfast"] ?? "",
    lunch: json["lunch"] ?? "",
    dinner: json["dinner"] ?? "",
    snack: json["snack"] ?? "",
    comment: json["comment"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "breakfast": breakfast,
    "lunch": lunch,
    "dinner": dinner,
    "snack": snack,
    "comment" : comment,
  };
}
