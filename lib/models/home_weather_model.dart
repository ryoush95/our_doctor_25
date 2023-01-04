// To parse this JSON data, do
//
//     final homeWeatherModel = homeWeatherModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class HomeWeatherModel {

  HomeWearherDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeWeatherModel({
    required this.data,
    required this.result,
    required this.msg,
    required this.reason,
  });

  HomeWeatherModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeWearherDto.fromJson(json['data']) : null;
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class HomeWearherDto {
  HomeWearherDto({
    required this.pm10Grade,
    required this.humidity,
    required this.temperature,
  });

  final String pm10Grade;
  final String humidity;
  final String temperature;

  factory HomeWearherDto.fromJson(Map<String, dynamic> json) => HomeWearherDto(
    pm10Grade: json["pm10Grade"],
    humidity: json["humidity"],
    temperature: json["temperature"],
  );

  Map<String, dynamic> toJson() => {
    "pm10Grade": pm10Grade,
    "humidity": humidity,
    "temperature": temperature,
  };
}
