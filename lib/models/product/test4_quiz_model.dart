// To parse this JSON data, do
//
//     final test4QuizModel = test4QuizModelFromJson(jsonString);

import 'dart:convert';

class Test4QuizModel {
  Test4QuizModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  List<Test4QuizDto>? data;
  int? result;
  String? msg;
  String? reason;

  factory Test4QuizModel.fromRawJson(String str) => Test4QuizModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Test4QuizModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Test4QuizDto>[];
      json['data'].forEach((v) {
        data!.add(new Test4QuizDto.fromJson(v));
      });
    }
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      print(this.data!.map((v) => v.toJson()));
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class Test4QuizDto {
  Test4QuizDto({
    this.id,
    this.quizId,
    this.mainType,
    this.quizImage,
    this.page,
    this.result,
    this.quiz,
    this.title,
  });

  String? id;
  String? quizId;
  String? mainType;
  String? quizImage;
  String? page;
  String? result;
  String? quiz;
  String? title;
  String answer = "-1";

  factory Test4QuizDto.fromRawJson(String str) => Test4QuizDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Test4QuizDto.fromJson(Map<String, dynamic> json) => Test4QuizDto(
    id: json["id"] ?? "",
    quizId: json["quiz_id"] ?? "",
    mainType: json["main_type"] ?? "",
    quizImage: json["quiz_image"] ?? "",
    page: json["page"] ?? "",
    result: json["result"] ?? "",
    quiz: json["quiz"] ?? "",
    title: json["title"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quiz_id": quizId,
    "main_type": mainType,
    "quiz_image": quizImage,
    "page": page,
    "result": result,
    "quiz": quiz,
    "title": title,
  };
}