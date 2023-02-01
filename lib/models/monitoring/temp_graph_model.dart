// To parse this JSON data, do
//
//     final tempGraphModel = tempGraphModelFromJson(jsonString);

import 'dart:convert';

class TempGraphModel {
  TempGraphModel({
    this.data,
    this.result,
    this.msg,
    this.reason,
  });

  Data? data;
  int? result;
  String? msg;
  String? reason;

  factory TempGraphModel.fromRawJson(String str) => TempGraphModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TempGraphModel.fromJson(Map<String, dynamic> json) => TempGraphModel(
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
    this.avgTemperature,
    this.graphTemperature,
  });

  double? avgTemperature;
  List<GraphTemperature>? graphTemperature;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    avgTemperature: json["avg_temperature"]?.toDouble(),
    graphTemperature: json["graph_temperature"] == null ? [] : List<GraphTemperature>.from(json["graph_temperature"]!.map((x) => GraphTemperature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "avg_temperature": avgTemperature,
    "graph_temperature": graphTemperature == null ? [] : List<dynamic>.from(graphTemperature!.map((x) => x.toJson())),
  };
}

class GraphTemperature {
  GraphTemperature({
    this.date,
    this.temperature,
  });

  String? date;
  double? temperature;

  factory GraphTemperature.fromRawJson(String str) => GraphTemperature.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GraphTemperature.fromJson(Map<String, dynamic> json) => GraphTemperature(
    date: json["date"],
    temperature: json["temperature"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "temperature": temperature,
  };
}
