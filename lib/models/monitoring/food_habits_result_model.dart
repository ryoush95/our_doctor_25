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

class FoodHabitModelDto {
  FoodHabitModelDto({
    this.comments,
    this.missions,
  });

  List<dynamic>? comments;
  Map<String, dynamic>? missions;

  factory FoodHabitModelDto.fromRawJson(String str) => FoodHabitModelDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodHabitModelDto.fromJson(Map<String, dynamic> json) => FoodHabitModelDto(
    comments: json["comments"],
    missions: json["missions"],
  );

  Map<String, dynamic> toJson() => {
    "comments": comments,
    "missions": missions,
  };
}

class CommentDto {
  CommentDto({
    this.title,
    this.content,
  });

  String? title;
  String? content;

  factory CommentDto.fromRawJson(String str) => CommentDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentDto.fromJson(Map<String, dynamic> json) => CommentDto(
    title: json["title"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
  };
}