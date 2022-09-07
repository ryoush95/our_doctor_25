import 'package:ourdoctor/helpers/bind_json.dart';

class MonitoringResultResModel {
  MonitorResultDto? data;
  int? result;
  String? msg;
  String? reason;

  MonitoringResultResModel({this.data, this.result, this.msg, this.reason});

  MonitoringResultResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new MonitorResultDto.fromJson(json['data']) : null;
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

class MonitorResultDto {
  HEIGHT? hEIGHT;
  HEIGHT? wEIGHT;
  SLEEP? sLEEP;
  FOOD? fOOD;
  SYMPTOM? sYMPTOM;
  LANGUAGE? lANGUAGE;
  LANGUAGE? wORKOUT;
  LANGUAGE? sOCIAL;
  String? name;
  String? date;

  MonitorResultDto({this.hEIGHT, this.wEIGHT, this.sLEEP, this.fOOD, this.sYMPTOM, this.lANGUAGE, this.wORKOUT, this.sOCIAL, this.name, this.date});

  MonitorResultDto.fromJson(Map<String, dynamic> json) {
    hEIGHT = json['HEIGHT'] != null ? new HEIGHT.fromJson(json['HEIGHT']) : null;
    wEIGHT = json['WEIGHT'] != null ? new HEIGHT.fromJson(json['WEIGHT']) : null;
    sLEEP = json['SLEEP'] != null ? new SLEEP.fromJson(json['SLEEP']) : null;
    fOOD = json['FOOD'] != null ? new FOOD.fromJson(json['FOOD']) : null;
    sYMPTOM = json['SYMPTOM'] != null ? new SYMPTOM.fromJson(json['SYMPTOM']) : null;
    lANGUAGE = json['LANGUAGE'] != null ? new LANGUAGE.fromJson(json['LANGUAGE']) : null;
    wORKOUT = json['WORKOUT'] != null ? new LANGUAGE.fromJson(json['WORKOUT']) : null;
    sOCIAL = json['SOCIAL'] != null ? new LANGUAGE.fromJson(json['SOCIAL']) : null;
    name = json['name'] ?? "";
    date = json['date'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hEIGHT != null) {
      data['HEIGHT'] = this.hEIGHT!.toJson();
    }
    if (this.wEIGHT != null) {
      data['WEIGHT'] = this.wEIGHT!.toJson();
    }
    if (this.sLEEP != null) {
      data['SLEEP'] = this.sLEEP!.toJson();
    }
    if (this.fOOD != null) {
      data['FOOD'] = this.fOOD!.toJson();
    }
    if (this.sYMPTOM != null) {
      data['SYMPTOM'] = this.sYMPTOM!.toJson();
    }
    if (this.lANGUAGE != null) {
      data['LANGUAGE'] = this.lANGUAGE!.toJson();
    }
    if (this.wORKOUT != null) {
      data['WORKOUT'] = this.wORKOUT!.toJson();
    }
    if (this.sOCIAL != null) {
      data['SOCIAL'] = this.sOCIAL!.toJson();
    }
    data['name'] = this.name;
    data['date'] = this.date;
    return data;
  }
}

class HEIGHT {
  double? value;
  double? percent;
  String? inputTime;
  Diagnose? diagnose;
  double? difference;

  HEIGHT({this.value, this.percent, this.inputTime, this.diagnose, this.difference});

  HEIGHT.fromJson(Map<String, dynamic> json) {
    if (json['value'] == null) {
      value = 0;
    } else {
      value = fromJsonDouble(json['value']);
    }
    if (json['percent'] == null) {
      percent = 0;
    } else {
      percent = fromJsonDouble(json['percent']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    if (json['difference'] == null) {
      difference = 0;
    } else {
      difference = fromJsonDouble(json['difference']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    data['difference'] = this.difference;
    return data;
  }
}

class Diagnose {
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

  Diagnose({this.id, this.diagnosis, this.result, this.color, this.comment, this.reserve1, this.min, this.max, this.minAge, this.maxAge, this.value, this.gender, this.enough});

  Diagnose.fromJson(Map<String, dynamic> json) {
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

class SLEEP {
  String? value;
  double? percent;
  String? inputTime;
  Diagnose? diagnose;
  double? difference;

  SLEEP({this.value, this.percent, this.inputTime, this.diagnose, this.difference});

  SLEEP.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    if (json['percent'] == null) {
      percent = 0;
    } else {
      percent = fromJsonDouble(json['percent']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    if (json['difference'] == null) {
      difference = 0;
    } else {
      difference = fromJsonDouble(json['difference']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    data['hashCode'] = this.hashCode;
    return data;
  }
}

class FOOD {
  String? value;
  double? percent;
  String? inputTime;
  Diagnose? diagnose;
  FoodDto? data;
  double? difference;

  FOOD({this.value, this.percent, this.inputTime, this.diagnose, this.data, this.difference});

  FOOD.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    if (json['percent'] == null) {
      percent = 0;
    } else {
      percent = fromJsonDouble(json['percent']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    data = json['data'] != null ? new FoodDto.fromJson(json['data']) : null;
    if (json['difference'] == null) {
      difference = 0;
    } else {
      difference = fromJsonDouble(json['difference']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['difference'] = this.difference;
    return data;
  }
}

class FoodDto {
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

  FoodDto(
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

  FoodDto.fromJson(Map<String, dynamic> json) {
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

class SYMPTOM {
  String? value;
  double? percent;
  String? inputTime;
  Diagnose? diagnose;
  List<SymptomDto>? data;

  SYMPTOM({this.value, this.percent, this.inputTime, this.diagnose, this.data});

  SYMPTOM.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    if (json['percent'] == null) {
      percent = 0;
    } else {
      percent = fromJsonDouble(json['percent']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    if (json['data'] != null) {
      data = <SymptomDto>[];
      json['data'].forEach((v) {
        data!.add(new SymptomDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SymptomDto {
  String? id;
  String? monitoringId;
  String? category;
  String? symptom;
  String? recordTime;
  String? surgeryName;
  String? surgeryTime;
  String? medication;
  String? status;
  String? patientId;
  String? createdAt;
  String? updateAt;
  String? medicationUrl;

  SymptomDto({this.id, this.monitoringId, this.category, this.symptom, this.recordTime, this.surgeryName, this.surgeryTime, this.medication, this.status, this.patientId, this.createdAt, this.updateAt, this.medicationUrl});

  SymptomDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    monitoringId = json['monitoring_id'] ?? "";
    category = json['category'] ?? "";
    symptom = json['symptom'] ?? "";
    recordTime = json['record_time'] ?? "";
    surgeryName = json['surgery_name'] ?? "";
    surgeryTime = json['surgery_time'] ?? "";
    medication = json['medication'] ?? "";
    status = json['status'] ?? "";
    patientId = json['patient_id'] ?? "";
    createdAt = json['created_at'] ?? "";
    updateAt = json['update_at'] ?? "";
    medicationUrl = json['medication_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['monitoring_id'] = this.monitoringId;
    data['category'] = this.category;
    data['symptom'] = this.symptom;
    data['record_time'] = this.recordTime;
    data['surgery_name'] = this.surgeryName;
    data['surgery_time'] = this.surgeryTime;
    data['medication'] = this.medication;
    data['status'] = this.status;
    data['patient_id'] = this.patientId;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['medication_url'] = this.medicationUrl;
    return data;
  }
}

class LANGUAGE {
  String? value;
  String? percent;
  String? inputTime;
  Diagnose? diagnose;

  LANGUAGE({this.value, this.percent, this.inputTime, this.diagnose});

  LANGUAGE.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    percent = json['percent'] ?? "";
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    return data;
  }
}
