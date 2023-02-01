// To parse this JSON data, do
//
//     final lifeResultModel = lifeResultModelFromJson(jsonString);

import 'dart:convert';

class LifeResultModel {
  LifeResultModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Map<String, LifeCateDto>? data;
  int? result;
  String? msg;
  String? reason;

  factory LifeResultModel.fromRawJson(String str) => LifeResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LifeResultModel.fromJson(Map<String, dynamic> json) => LifeResultModel(
    data: Map.from(json["data"]!).map((k, v) => MapEntry<String, LifeCateDto>(k, LifeCateDto.fromJson(v))),
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

class LifeCateDto {
  LifeCateDto({
    this.score,
    this.totalScore,
    this.feedbackDescription,
    this.status,
    this.wrongAnswers,
  });

  int? score;
  int? totalScore;
  String? feedbackDescription;
  String? status;
  Map<String, WrongAnswer>? wrongAnswers;

  factory LifeCateDto.fromRawJson(String str) => LifeCateDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LifeCateDto.fromJson(Map<String, dynamic> json) => LifeCateDto(
    score: json["score"],
    totalScore: json["total_score"],
    feedbackDescription: json["feedback_description"],
    status: json["status"],
    wrongAnswers: Map.from(json["wrong_answers"]!).map((k, v) => MapEntry<String, WrongAnswer>(k, WrongAnswer.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "total_score": totalScore,
    "feedback_description": feedbackDescription,
    "status": status,
    "wrong_answers": Map.from(wrongAnswers!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class WrongAnswer {
  WrongAnswer({
    this.question,
    this.imageUrl,
    this.answer,
    this.description,
  });

  String? question;
  String? imageUrl;
  int? answer;
  String? description;

  factory WrongAnswer.fromRawJson(String str) => WrongAnswer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WrongAnswer.fromJson(Map<String, dynamic> json) => WrongAnswer(
    question: json["question"],
    imageUrl: json["image_url"] ?? "",
    answer: json["answer"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "image_url": imageUrl,
    "answer": answer,
    "description": description,
  };
}