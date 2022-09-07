import 'package:ourdoctor/helpers/bind_json.dart';

class HomeMonitorResModel {
  HomeMonitorDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeMonitorResModel({this.data, this.result, this.msg, this.reason});

  HomeMonitorResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeMonitorDto.fromJson(json['data']) : null;
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

class HomeMonitorDto {
  String? name;
  int? age;
  int? gender;
  String? profileImgUrl;
  String? bodyLastDate;
  double? height;
  double? heightPercent;
  HeightDiagnose? heightDiagnose;
  double? weight;
  double? weightPercent;
  HeightDiagnose? weightDiagnose;
  String? kcal;
  double? kcalLack;
  String? kcalResult;
  double? sleep;
  double? sleepLack;
  String? sleepResult;
  String? symptom;
  int? symptomCnt;
  String? brainLastDate;
  String? social;
  String? socialVal;
  String? workout;
  String? workoutVal;
  String? language;
  String? languageVal;
  String? mchat;
  String? mchatVal;
  double? totalScore;
  double? bodyScore;
  double? brainScore;
  TodayResult? todayResult;

  HomeMonitorDto(
      {this.name,
      this.age,
      this.gender,
      this.profileImgUrl,
      this.bodyLastDate,
      this.height,
      this.heightPercent,
      this.heightDiagnose,
      this.weight,
      this.weightPercent,
      this.weightDiagnose,
      this.kcal,
      this.kcalLack,
      this.kcalResult,
      this.sleep,
      this.sleepLack,
      this.sleepResult,
      this.symptom,
      this.symptomCnt,
      this.brainLastDate,
      this.social,
      this.socialVal,
      this.workout,
      this.workoutVal,
      this.language,
      this.languageVal,
      this.mchat,
      this.mchatVal,
      this.totalScore,
      this.bodyScore,
      this.brainScore,
      this.todayResult});

  HomeMonitorDto.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    age = json['age'];
    gender = json['gender'];
    profileImgUrl = json['profile_img_url'] ?? "";
    bodyLastDate = json['body_last_date'] ?? "";
    if (json['height'] == null) {
      height = 0;
    } else {
      height = fromJsonDouble(json['height']);
    }
    if (json['height_percent'] == null) {
      heightPercent = 0;
    } else {
      heightPercent = fromJsonDouble(json['height_percent']);
    }
    heightDiagnose = json['height_diagnose'] != null ? new HeightDiagnose.fromJson(json['height_diagnose']) : null;
    if (json['weight'] == null) {
      weight = 0;
    } else {
      weight = fromJsonDouble(json['weight']);
    }
    if (json['weight_percent'] == null) {
      weightPercent = 0;
    } else {
      weightPercent = fromJsonDouble(json['weight_percent']);
    }
    weightDiagnose = json['weight_diagnose'] != null ? new HeightDiagnose.fromJson(json['weight_diagnose']) : null;
    kcal = json['kcal'] ?? "0";
    if (json['kcal_lack'] == null) {
      kcalLack = 0;
    } else {
      kcalLack = fromJsonDouble(json['kcal_lack']);
    }
    kcalResult = json['kcal_result'] ?? "";
    if (json['sleep'] == null) {
      sleep = 0;
    } else {
      sleep = fromJsonDouble(json['sleep']);
    }
    if (json['sleep_lack'] == null) {
      sleepLack = 0;
    } else {
      sleepLack = fromJsonDouble(json['sleep_lack']);
    }
    if (json['kcal_lack'] == null) {
      kcalLack = 0;
    } else {
      kcalLack = fromJsonDouble(json['kcal_lack']);
    }
    sleepResult = json['sleep_result'] ?? "";
    symptom = json['symptom'] ?? "";
    symptomCnt = json['symptom_cnt'] ?? 0;
    brainLastDate = json['brain_last_date'] ?? "";
    social = json['social'] ?? "";
    socialVal = json['social_val'] ?? "";
    workout = json['workout'] ?? "";
    workoutVal = json['workout_val'] ?? "";
    language = json['language'] ?? "";
    languageVal = json['language_val'] ?? "";
    mchat = json['mchat'] ?? "";
    mchatVal = json['mchat_val'] ?? "";
    if (json['total_score'] == null) {
      totalScore = 0;
    } else {
      totalScore = fromJsonDouble(json['total_score']);
    }
    if (json['body_score'] == null) {
      bodyScore = 0;
    } else {
      bodyScore = fromJsonDouble(json['body_score']);
    }
    if (json['brain_score'] == null) {
      brainScore = 0;
    } else {
      brainScore = fromJsonDouble(json['brain_score']);
    }
    todayResult = json['today_result'] != null ? new TodayResult.fromJson(json['today_result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['profile_img_url'] = this.profileImgUrl;
    data['body_last_date'] = this.bodyLastDate;
    data['height'] = this.height;
    if (this.heightDiagnose != null) {
      data['height_diagnose'] = this.heightDiagnose!.toJson();
    }
    data['height_percent'] = this.heightPercent;
    data['weight'] = this.weight;
    data['weight_percent'] = this.weightPercent;
    if (this.weightDiagnose != null) {
      data['weight_diagnose'] = this.weightDiagnose!.toJson();
    }
    data['kcal'] = this.kcal;
    data['kcal_lack'] = this.kcalLack;
    data['kcal_result'] = this.kcalResult;
    data['sleep'] = this.sleep;
    data['sleep_lack'] = this.sleepLack;
    data['sleep_result'] = this.sleepResult;
    data['symptom'] = this.symptom;
    data['symptom_cnt'] = this.symptomCnt;
    data['brain_last_date'] = this.brainLastDate;
    data['social'] = this.social;
    data['social_val'] = this.socialVal;
    data['workout'] = this.workout;
    data['workout_val'] = this.workoutVal;
    data['language'] = this.language;
    data['language_val'] = this.languageVal;
    data['mchat'] = this.mchat;
    data['mchat_val'] = this.mchatVal;
    data['total_score'] = this.totalScore;
    data['body_score'] = this.bodyScore;
    data['brain_score'] = this.brainScore;
    data['today_result'] = this.todayResult;
    if (this.todayResult != null) {
      data['today_result'] = this.todayResult!.toJson();
    }
    return data;
  }
}

class TodayResult {
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

  TodayResult(
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

  TodayResult.fromJson(Map<String, dynamic> json) {
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
    breakfastKcal = json['breakfast_kcal'] ?? "";
    launchKcal = json['launch_kcal'] ?? "";
    snackKcal = json['snack_kcal'] ?? "";
    dinnerKcal = json['dinner_kcal'] ?? "";
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

class HeightDiagnose {
  String? id;
  String? diagnosis;
  String? result;
  String? color;
  String? comment;
  String? reserve1;
  String? min;
  String? max;
  String? minAge;
  String? maxAge;
  String? value;
  String? gender;
  String? enough;

  HeightDiagnose({this.id, this.diagnosis, this.result, this.color, this.comment, this.reserve1, this.min, this.max, this.minAge, this.maxAge, this.value, this.gender, this.enough});

  HeightDiagnose.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    diagnosis = json['diagnosis'] ?? "";
    result = json['result'] ?? "";
    color = json['color'] ?? "";
    comment = json['comment'] ?? "";
    reserve1 = json['reserve1'] ?? "";
    min = json['min'] ?? "";
    max = json['max'] ?? "";
    minAge = json['min_age'] ?? "";
    maxAge = json['max_age'] ?? "";
    value = json['value'] ?? "";
    gender = json['gender'] ?? "";
    enough = json['enough'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['diagnosis'] = this.diagnosis;
    data['result'] = this.result;
    data['color'] = this.color;
    data['comment'] = this.comment;
    data['reserve1'] = this.reserve1;
    data['min'] = this.min;
    data['max'] = this.max;
    data['min_age'] = this.minAge;
    data['max_age'] = this.maxAge;
    data['value'] = this.value;
    data['gender'] = this.gender;
    data['enough'] = this.enough;
    return data;
  }
}
