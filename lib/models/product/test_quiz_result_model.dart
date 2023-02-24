// To parse this JSON data, do
//
//     final testQuizResultModel = testQuizResultModelFromJson(jsonString);

import 'dart:convert';

class TestQuizResultModel {
  TestQuizResultModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  TestResultDto? data;
  int? result;
  String? msg;
  String? reason;

  factory TestQuizResultModel.fromRawJson(String str) => TestQuizResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TestQuizResultModel.fromJson(Map<String, dynamic> json) => TestQuizResultModel(
    data: json["data"] == null ? null : TestResultDto.fromJson(json["data"]),
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

class TestResultDto {
  TestResultDto({
    this.id,
    this.quizId,
    this.quizResult,
    this.resultImage,
    this.etc,
  });

  String? id;
  String? quizId;
  String? quizResult;
  String? resultImage;
  String? etc;

  factory TestResultDto.fromRawJson(String str) => TestResultDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TestResultDto.fromJson(Map<String, dynamic> json) => TestResultDto(
    id: json["id"] ?? "",
    quizId: json["quiz_id"] ?? "",
    quizResult: json["quiz_result"] ?? "",
    resultImage: json["result_image"] ?? "",
    etc: json["etc"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quiz_id": quizId,
    "quiz_result": quizResult,
    "result_image": resultImage,
    "etc": etc,
  };
}
