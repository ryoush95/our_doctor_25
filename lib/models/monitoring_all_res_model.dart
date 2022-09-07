class MonitoringAllResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  MonitoringAllResModel({this.data, this.result, this.msg, this.reason});

  MonitoringAllResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? totalCount;
  int? totalPage;
  bool? isLast;
  List<MonitoringAlldto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <MonitoringAlldto>[];
      json['list'].forEach((v) {
        list!.add(new MonitoringAlldto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['total_page'] = this.totalPage;
    data['is_last'] = this.isLast;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MonitoringAlldto {
  String? id;
  String? patientId;
  String? height;
  String? weight;
  String? sleepAtNight;
  String? sleepAtLunch;
  String? language;
  String? languageJson;
  String? sociability;
  String? sociabilityJson;
  String? workOut;
  String? workOutJson;
  String? regDate;
  String? breakfastKcal;
  String? launchKcal;
  String? snackKcal;
  String? dinnerKcal;
  String? foodInputTime;
  String? languageInputTime;
  String? sociabilityInputTime;
  String? workoutInputTime;
  String? heightInputTime;
  String? weightInputTime;
  String? sleepInputTime;
  String? createdAt;
  String? updatedAt;
  String? monitoringTime;
  String? status;

  MonitoringAlldto(
      {this.id,
      this.patientId,
      this.height,
      this.weight,
      this.sleepAtNight,
      this.sleepAtLunch,
      this.language,
      this.languageJson,
      this.sociability,
      this.sociabilityJson,
      this.workOut,
      this.workOutJson,
      this.regDate,
      this.breakfastKcal,
      this.launchKcal,
      this.snackKcal,
      this.dinnerKcal,
      this.foodInputTime,
      this.languageInputTime,
      this.sociabilityInputTime,
      this.workoutInputTime,
      this.heightInputTime,
      this.weightInputTime,
      this.sleepInputTime,
      this.createdAt,
      this.updatedAt,
      this.monitoringTime,
      this.status});

  MonitoringAlldto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    height = json['height'] ?? "";
    weight = json['weight'] ?? "";
    sleepAtNight = json['sleep_at_night'] ?? "";
    sleepAtLunch = json['sleep_at_lunch'] ?? "";
    language = json['language'] ?? "";
    languageJson = json['language_json'] ?? "";
    sociability = json['sociability'] ?? "";
    sociabilityJson = json['sociability_json'] ?? "";
    workOut = json['work_out'] ?? "";
    workOutJson = json['work_out_json'] ?? "";
    regDate = json['reg_date'] ?? "";
    breakfastKcal = json['breakfast_kcal'] ?? "0";
    launchKcal = json['launch_kcal'] ?? "0";
    snackKcal = json['snack_kcal'] ?? "0";
    dinnerKcal = json['dinner_kcal'] ?? "0";
    foodInputTime = json['food_input_time'] ?? "";
    languageInputTime = json['language_input_time'] ?? "";
    sociabilityInputTime = json['sociability_input_time'] ?? "";
    workoutInputTime = json['workout_input_time'] ?? "";
    heightInputTime = json['height_input_time'] ?? "";
    weightInputTime = json['weight_input_time'] ?? "";
    sleepInputTime = json['sleep_input_time'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    monitoringTime = json['monitoring_time'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['sleep_at_night'] = this.sleepAtNight;
    data['sleep_at_lunch'] = this.sleepAtLunch;
    data['language'] = this.language;
    data['language_json'] = this.languageJson;
    data['sociability'] = this.sociability;
    data['sociability_json'] = this.sociabilityJson;
    data['work_out'] = this.workOut;
    data['work_out_json'] = this.workOutJson;
    data['reg_date'] = this.regDate;
    data['breakfast_kcal'] = this.breakfastKcal;
    data['launch_kcal'] = this.launchKcal;
    data['snack_kcal'] = this.snackKcal;
    data['dinner_kcal'] = this.dinnerKcal;
    data['food_input_time'] = this.foodInputTime;
    data['language_input_time'] = this.languageInputTime;
    data['sociability_input_time'] = this.sociabilityInputTime;
    data['workout_input_time'] = this.workoutInputTime;
    data['height_input_time'] = this.heightInputTime;
    data['weight_input_time'] = this.weightInputTime;
    data['sleep_input_time'] = this.sleepInputTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['monitoring_time'] = this.monitoringTime;
    data['status'] = this.status;
    return data;
  }
}
