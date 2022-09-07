class FreeTestResModel {
  FreeTtestDto? data;
  int? result;
  String? msg;
  String? reason;

  FreeTestResModel({this.data, this.result, this.msg, this.reason});

  FreeTestResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new FreeTtestDto.fromJson(json['data']) : null;
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

class FreeTtestDto {
  String? gender;
  int? ageMonth;
  HEIGHT? hEIGHT;
  WEIGHT? wEIGHT;
  SLEEP? sLEEP;

  FreeTtestDto({this.gender, this.ageMonth, this.hEIGHT, this.wEIGHT, this.sLEEP});

  FreeTtestDto.fromJson(Map<String, dynamic> json) {
    gender = json['gender'] ?? "";
    ageMonth = json['age_month'];
    hEIGHT = json['HEIGHT'] != null ? new HEIGHT.fromJson(json['HEIGHT']) : null;
    wEIGHT = json['WEIGHT'] != null ? new WEIGHT.fromJson(json['WEIGHT']) : null;
    sLEEP = json['SLEEP'] != null ? new SLEEP.fromJson(json['SLEEP']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['age_month'] = this.ageMonth;
    if (this.hEIGHT != null) {
      data['HEIGHT'] = this.hEIGHT!.toJson();
    }
    if (this.wEIGHT != null) {
      data['WEIGHT'] = this.wEIGHT!.toJson();
    }
    if (this.sLEEP != null) {
      data['SLEEP'] = this.sLEEP!.toJson();
    }
    return data;
  }
}

class HEIGHT {
  double? predict;
  double? percent;
  double? diff;
  double? min;
  double? max;
  String? curValue;
  Diagnose? diagnose;

  HEIGHT({this.predict, this.percent, this.min, this.max, this.diagnose});

  HEIGHT.fromJson(Map<String, dynamic> json) {
    predict = double.parse(json["predict"].toString());
    percent = double.parse(json["percent"].toString());
    diff = double.parse(json["diff"].toString());
    min = double.parse(json["min"].toString());
    max = double.parse(json["max"].toString());
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['predict'] = this.predict;
    data['percent'] = this.percent;
    data['diff'] = this.diff;
    data['min'] = this.min;
    data['max'] = this.max;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
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
  bool? lack;

  Diagnose({this.id, this.diagnosis, this.result, this.color, this.comment, this.reserve1, this.min, this.max, this.minAge, this.maxAge, this.value, this.gender, this.enough, this.lack});

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
    lack = json['lack'] ?? false;
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
    data['lack'] = this.lack;
    return data;
  }
}

class WEIGHT {
  double? predict;
  double? percent;
  double? diff;
  double? min;
  double? max;
  String? curValue;
  Diagnose? diagnose;

  WEIGHT({this.predict, this.percent, this.min, this.max, this.diagnose});

  WEIGHT.fromJson(Map<String, dynamic> json) {
    predict = double.parse(json["predict"].toString());
    percent = double.parse(json["percent"].toString());
    min = double.parse(json["min"].toString());
    diff = double.parse(json["diff"].toString());
    max = double.parse(json["max"].toString());
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['predict'] = this.predict;
    data['percent'] = this.percent;
    data['diff'] = this.diff;
    data['min'] = this.min;
    data['max'] = this.max;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    return data;
  }
}

class SLEEP {
  double? predict;
  double? percent;
  double? min;
  double? max;
  Diagnose? diagnose;

  SLEEP({this.predict, this.percent, this.min, this.max, this.diagnose});

  SLEEP.fromJson(Map<String, dynamic> json) {
    predict = double.parse(json["predict"].toString());
    percent = double.parse(json["percent"].toString());
    min = double.parse(json["min"].toString());
    max = double.parse(json["max"].toString());
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['predict'] = this.predict;
    data['percent'] = this.percent;
    data['min'] = this.min;
    data['max'] = this.max;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    return data;
  }
}
