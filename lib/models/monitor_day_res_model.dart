import 'package:ourdoctor/models/food_list_res_model.dart';

class MonitorDayResModel {
  List<MonitoringDayDto>? data;
  int? result;
  String? msg;
  String? reason;

  MonitorDayResModel({this.data, this.result, this.msg, this.reason});

  MonitorDayResModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MonitoringDayDto>[];
      json['data'].forEach((v) {
        data!.add(new MonitoringDayDto.fromJson(v));
      });
    }
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class MonitoringDayDto {
  String? height;
  String? weight;
  String? nutrition;
  String? sleep_at_night;
  String? sleep_at_lunch;
  String? language;
  String? sociability;
  String? work_out;
  List<MonitoringSymptomDto>? symptom_list;

  List<FoodDto>? foodAddList1 = []; //아침
  List<FoodDto>? foodAddList2 = []; //점심
  List<FoodDto>? foodAddList3 = []; //간식
  List<FoodDto>? foodAddList4 = []; //저녁

  MonitoringDayDto({this.height, this.weight, this.nutrition, this.sleep_at_night, this.sleep_at_lunch, this.language, this.sociability, this.work_out, this.symptom_list});

  MonitoringDayDto.fromJson(Map<String, dynamic> json) {
    height = json['height'] ?? "";
    weight = json['weight'] ?? "";
    nutrition = json['nutrition'] ?? "";
    sleep_at_night = json['sleep_at_night'] ?? "";
    sleep_at_lunch = json['sleep_at_lunch'] ?? "";
    language = json['language'] ?? "";
    sociability = json['sociability'] ?? "";
    work_out = json['work_out'] ?? "";
    if (json['symptom_list'] != null) {
      symptom_list = <MonitoringSymptomDto>[];
      json['symptom_list'].forEach((v) {
        symptom_list!.add(new MonitoringSymptomDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['nutrition'] = this.nutrition;
    data['sleep_at_night'] = this.sleep_at_night;
    data['sleep_at_lunch'] = this.sleep_at_lunch;
    data['language'] = this.language;
    data['sociability'] = this.sociability;
    data['work_out'] = this.work_out;
    if (this.symptom_list != null) {
      data['symptom_list'] = this.symptom_list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MonitoringSymptomDto {
  String? category;
  String? symptom;
  String? record_time;
  String? surgey_name;
  String? surgey_time;
  String? medication;

  MonitoringSymptomDto({this.category, this.symptom, this.record_time, this.surgey_name, this.surgey_time, this.medication});

  MonitoringSymptomDto.fromJson(Map<String, dynamic> json) {
    category = json['category'] ?? "";
    symptom = json['symptom'] ?? "";
    record_time = json['record_time'] ?? "";
    surgey_name = json['surgery_name'] ?? "";
    surgey_time = json['surgery_time'] ?? "";
    medication = json['medication'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['symptom'] = this.symptom;
    data['record_time'] = this.record_time;
    data['surgery_name'] = this.surgey_name;
    data['surgery_time'] = this.surgey_time;
    data['medication'] = this.medication;
    return data;
  }
}
