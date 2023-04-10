// To parse this JSON data, do
//
//     final foodRadarchartModel = foodRadarchartModelFromJson(jsonString);

import 'dart:convert';

class FoodRadarchartModel {
  FoodRadarchartModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  ChartData? data;
  int? result;
  String? msg;
  String? reason;

  factory FoodRadarchartModel.fromRawJson(String str) => FoodRadarchartModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodRadarchartModel.fromJson(Map<String, dynamic> json) => FoodRadarchartModel(
    data: json["data"] == null ? null : ChartData.fromJson(json["data"]),
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

class ChartData {
  ChartData({
    this.graph,
    this.comment,
  });

  Map<String, Graph>? graph;
  Comment? comment;

  factory ChartData.fromRawJson(String str) => ChartData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
    graph: Map.from(json["graph"]!).map((k, v) => MapEntry<String, Graph>(k, Graph.fromJson(v))),
    comment: json["comment"] == null ? null : Comment.fromJson(json["comment"]),
  );

  Map<String, dynamic> toJson() => {
    "graph": Map.from(graph!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "comment": comment?.toJson(),
  };
}

class Comment {
  Comment({
    required this.title,
    required this.content,
  });

  String title;
  String content;

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

class Graph {
  Graph({
    required this.average,
    required this.data,
    this.comment,
  });

  double average;
  double data;
  Comment? comment;

  factory Graph.fromRawJson(String str) => Graph.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Graph.fromJson(Map<String, dynamic> json) => Graph(
    average: json["average"]?.toDouble(),
    data: json["data"]?.toDouble(),
    comment: json["comment"] == null ? null : Comment.fromJson(json["comment"]),
  );

  Map<String, dynamic> toJson() => {
    "average": average,
    "data": data,
    "comment": comment?.toJson(),
  };
}
