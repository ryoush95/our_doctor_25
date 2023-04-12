// To parse this JSON data, do
//
//     final foodHabitModel = foodHabitModelFromJson(jsonString);

import 'dart:convert';

class FoodHabitModel {
  FoodHabitModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Data? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodHabitModel.fromRawJson(String str) =>
      FoodHabitModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodHabitModel.fromJson(Map<String, dynamic> json) => FoodHabitModel(
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
    this.comments,
    this.missions,
  });

  Map<String, Comment>? comments;
  Map<String, Mission>? missions;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        comments: Map.from(json["comments"]!)
            .map((k, v) => MapEntry<String, Comment>(k, Comment.fromJson(v))),
        missions: Map.from(json["missions"]!)
            .map((k, v) => MapEntry<String, Mission>(k, Mission.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "comments": Map.from(comments!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "missions": Map.from(missions!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Comment {
  Comment({
    this.title,
    this.content,
  });

  String? title;
  String? content;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}

class Mission {
  Mission({
    this.text,
    this.complete,
  });

  String? text;
  bool? complete;

  factory Mission.fromRawJson(String str) => Mission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        text: json["text"],
        complete: json["complete"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "complete": complete,
      };
}
