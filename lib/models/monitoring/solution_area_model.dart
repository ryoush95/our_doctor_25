// To parse this JSON data, do
//
//     final solutionAreaModel = solutionAreaModelFromJson(jsonString);

import 'dart:convert';

class SolutionAreaModel {
  SolutionAreaModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  SolutionAreaDto? data;
  int? result;
  String? msg;
  String? reason;

  factory SolutionAreaModel.fromRawJson(String str) => SolutionAreaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SolutionAreaModel.fromJson(Map<String, dynamic> json) => SolutionAreaModel(
    data: json["data"] == null ? null : SolutionAreaDto.fromJson(json["data"]),
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

class SolutionAreaDto {
  SolutionAreaDto({
    this.type,
    this.imgUrl,
    this.url,
    this.title,
    this.communityUid,
  });

  String? type;
  String? imgUrl;
  String? url;
  String? title;
  String? communityUid;

  factory SolutionAreaDto.fromRawJson(String str) => SolutionAreaDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SolutionAreaDto.fromJson(Map<String, dynamic> json) => SolutionAreaDto(
    type: json["type"],
    imgUrl: json["img_url"],
    url: json["url"],
    title: json["title"],
    communityUid: json["community_uid"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "img_url": imgUrl,
    "url": url,
    "title": title,
    "community_uid": communityUid,
  };
}
