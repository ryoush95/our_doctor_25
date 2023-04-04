// To parse this JSON data, do
//
//     final foodItemListModel = foodItemListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class FoodItemListModel {
  FoodItemListModel({
    required this.data,
    required this.result,
    required this.msg,
    required this.reason,
  });

  List<Map<String, FoodItem>> data;
  int result;
  String msg;
  String reason;

  factory FoodItemListModel.fromRawJson(String str) => FoodItemListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodItemListModel.fromJson(Map<String, dynamic> json) => FoodItemListModel(
    data: List<Map<String, FoodItem>>.from(json["data"].map((x) => Map.from(x).map((k, v) => MapEntry<String, FoodItem>(k, FoodItem.fromJson(v))))),
    result: json["result"],
    msg: json["msg"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
    "result": result,
    "msg": msg,
    "reason": reason,
  };
}

class FoodItem {
  FoodItem({
    required this.name,
    required this.unitName,
    required this.unit,
    required this.image,
  });

  String name;
  String unitName;
  String unit;
  String image;

  factory FoodItem.fromRawJson(String str) => FoodItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    name: json["name"],
    unitName: json["unit_name"],
    unit: json["unit"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "unit_name": unitName,
    "unit": unit,
    "image": image,
  };
}
