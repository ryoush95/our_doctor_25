// To parse this JSON data, do
//
//     final monitorHealthResultModel = monitorHealthResultModelFromJson(jsonString);

import 'dart:convert';

class MonitorHealthResultModel {
  MonitorHealthResultModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Map<String, DevelopmentScoreDto>? data;
  int? result;
  String? msg;
  String? reason;

  factory MonitorHealthResultModel.fromRawJson(String str) => MonitorHealthResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitorHealthResultModel.fromJson(Map<String, dynamic> json) => MonitorHealthResultModel(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, DevelopmentScoreDto>(k, DevelopmentScoreDto.fromJson(v))),
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

class DevelopmentScoreDto {
  DevelopmentScoreDto({
    this.score,
    this.status,
    this.feedbackTitle,
    this.feedbackDescription,
    this.solutionList,
  });

  int? score;
  String? status;
  String? feedbackTitle;
  String? feedbackDescription;
  Map<String, RecommendList>? solutionList;

  factory DevelopmentScoreDto.fromRawJson(String str) => DevelopmentScoreDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DevelopmentScoreDto.fromJson(Map<String, dynamic> json) => DevelopmentScoreDto(
    score: json["score"],
    status: json["status"],
    feedbackTitle: json["feedback_title"],
    feedbackDescription: json["feedback_description"],
    solutionList: Map.from(json["recommend_list"]!).map((k, v) => MapEntry<String, RecommendList>(k, RecommendList.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "status": status,
    "feedback_title": feedbackTitle,
    "feedback_description": feedbackDescription,
    "recommend_list": Map.from(solutionList!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class RecommendList {
  RecommendList({
    this.type,
    this.id,
    this.imageUrl,
    this.title,
  });

  String? type;
  String? id;
  String? imageUrl;
  String? title;

  factory RecommendList.fromRawJson(String str) => RecommendList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendList.fromJson(Map<String, dynamic> json) => RecommendList(
    type: json["type"] ?? "",
    id: json["id"] ?? "",
    imageUrl: json["image_url"] ?? "",
    title: json["title"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "image_url": imageUrl,
    "title": title,
  };
}