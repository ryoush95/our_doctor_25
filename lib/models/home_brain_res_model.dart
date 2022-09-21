class HomeBrainResModel {
  HomeBraninDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeBrainResModel({this.data, this.result, this.msg, this.reason});

  HomeBrainResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeBraninDto.fromJson(json['data']) : null;
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

class HomeBraninDto {
  String? value;
  String? percent;
  String? inputTime;
  Diagnose? diagnose;
  bool? classExist;
  bool? storeExist;
  String? quizCode;

  HomeBraninDto({this.value, this.percent, this.inputTime, this.diagnose, this.classExist, this.storeExist, this.quizCode});

  HomeBraninDto.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    percent = json['percent'] ?? "";
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    classExist = json['class_exist'];
    storeExist = json['store_exist'];
    quizCode = json['quiz_code'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    data['class_exist'] = this.classExist;
    data['store_exist'] = this.storeExist;
    data['quiz_code'] = this.quizCode;
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
