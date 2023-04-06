import 'dart:convert';

class FoodHabitModel {
  FoodHabitModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  FoodHabitModelDto? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodHabitModel.fromRawJson(String str) => FoodHabitModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodHabitModel.fromJson(Map<String, dynamic> json) => FoodHabitModel(
    data: json["data"] == null ? null : FoodHabitModelDto.fromJson(json["data"]),
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

//TODO 실 데이터에 따라 수정하기
//image Name, comment, category
class FoodHabitModelDto {
  FoodHabitModelDto({
    this.title,
    this.content,
    this.img,
    this.missions,
    this.solutions,
  });

  String? title;
  String? content;
  String? img;
  List<String>? missions;
  List<String>? solutions;

  factory FoodHabitModelDto.fromRawJson(String str) => FoodHabitModelDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodHabitModelDto.fromJson(Map<String, dynamic> json) => FoodHabitModelDto(
    title: json["title"],
    content: json["content"],
    img: json["img"],
    missions: json["missions"],
    solutions: json["solutions"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "img": img,
    "missions": missions,
    "solutions": solutions,
  };
}