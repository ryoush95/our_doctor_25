// To parse this JSON data, do
//
//     final foodItemListModel = foodItemListModelFromJson(jsonString);

import 'dart:convert';

class FoodItemListModel {
  FoodItemListModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Data? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodItemListModel.fromRawJson(String str) => FoodItemListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodItemListModel.fromJson(Map<String, dynamic> json) => FoodItemListModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
  Data({
    this.result,
    this.standardImageList,
  });

  List<Map<String, FoodItem>>? result;
  List<String>? standardImageList;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<Map<String, FoodItem>>.from(json["result"]!.map((x) => Map.from(x).map((k, v) => MapEntry<String, FoodItem>(k, FoodItem.fromJson(v))))),
    standardImageList: json["standard_image_list"] == null ? [] : List<String>.from(json["standard_image_list"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
    "standard_image_list": standardImageList == null ? [] : List<dynamic>.from(standardImageList!.map((x) => x)),
  };
}

class FoodItem {
  FoodItem({
    this.name,
    this.unitName,
    this.unit,
    this.image,
    this.count,
  });

  String? name;
  String? unitName;
  String? unit;
  String? image;
  int? count;

  factory FoodItem.fromRawJson(String str) => FoodItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    name: json["name"],
    unitName: json["unit_name"],
    unit: json["unit"],
    image: json["image"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "unit_name": unitName,
    "unit": unit,
    "image": image,
    "count": count,
  };
}
