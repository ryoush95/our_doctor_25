class MonitorListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  MonitorListResModel({this.data, this.result, this.msg, this.reason});

  MonitorListResModel.fromJson(Map<String, dynamic> json) {
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
  List<MonitorListDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <MonitorListDto>[];
      json['list'].forEach((v) {
        list!.add(new MonitorListDto.fromJson(v));
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

class MonitorListDto {
  String? uid;
  String? regtime;
  String? status;
  String? temperature;
  String? oxygen;
  String? symptom;
  String? pillUrl;
  String? patientUid;
  String? writeStep;
  String? speciality;
  String? stepTimes;
  String? comment;
  String? commentTime;
  String? heartCnt;

  MonitorListDto({this.uid, this.regtime, this.status, this.temperature, this.oxygen, this.symptom, this.pillUrl, this.patientUid, this.writeStep, this.speciality, this.stepTimes, this.comment, this.commentTime, this.heartCnt});

  MonitorListDto.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? "";
    regtime = json['regtime'] ?? "";
    status = json['status'] ?? "";
    temperature = json['temperature'] ?? "";
    oxygen = json['oxygen'] ?? "";
    symptom = json['symptom'] ?? "";
    pillUrl = json['pill_url'] ?? "";
    patientUid = json['patient_uid'] ?? "";
    writeStep = json['write_step'] ?? "";
    speciality = json['speciality'] ?? "";
    stepTimes = json['step_times'] ?? "";
    comment = json['comment'] ?? "";
    commentTime = json['comment_time'] ?? "";
    heartCnt = json['heart_cnt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['regtime'] = this.regtime;
    data['status'] = this.status;
    data['temperature'] = this.temperature;
    data['oxygen'] = this.oxygen;
    data['symptom'] = this.symptom;
    data['pill_url'] = this.pillUrl;
    data['patient_uid'] = this.patientUid;
    data['write_step'] = this.writeStep;
    data['speciality'] = this.speciality;
    data['step_times'] = this.stepTimes;
    data['comment'] = this.comment;
    data['comment_time'] = this.commentTime;
    data['heart_cnt'] = this.heartCnt;
    return data;
  }
}
