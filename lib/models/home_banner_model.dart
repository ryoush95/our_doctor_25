// To parse this JSON data, do
//
//     final solutionAreaModel = solutionAreaModelFromJson(jsonString);

import 'dart:convert';

class HomeBannerModel {
  HomeBannerModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  List<BannerDto>? data;
  int? result;
  String? msg;
  String? reason;

  factory HomeBannerModel.fromRawJson(String str) => HomeBannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) => HomeBannerModel(
    data: json["data"] == null ? null : List<BannerDto>.from(json["data"].map((x) => BannerDto.fromJson(x))),
    result: json["result"],
    msg: json["msg"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "result": result,
    "msg": msg,
    "reason": reason,
  };
}

class BannerDto {
  BannerDto({
    this.type,
    this.imgUrl,
    this.url,
    this.title,
    this.uid,
  });

  String? type;
  String? imgUrl;
  String? url;
  String? title;
  String? uid;

  factory BannerDto.fromRawJson(String str) => BannerDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerDto.fromJson(Map<String, dynamic> json) => BannerDto(
    type: json["type"] ?? "",
    imgUrl: json["image_url"] ?? "",
    url: json["url"] ?? "",
    title: json["title"] ?? "",
    uid: json["id"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "image_url": imgUrl,
    "url": url,
    "title": title,
    "id": uid,
  };
}
