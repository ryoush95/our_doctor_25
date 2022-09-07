class MonitoringListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  MonitoringListResModel({this.data, this.result, this.msg, this.reason});

  MonitoringListResModel.fromJson(Map<String, dynamic> json) {
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
  List<MonitoringListDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <MonitoringListDto>[];
      json['list'].forEach((v) {
        list!.add(new MonitoringListDto.fromJson(v));
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

class MonitoringListDto {
  String? id;
  String? patient_id;
  String? height;
  String? weight;
  String? nutrition;
  String? sleep_at_night;
  String? sleep_at_lunch;
  String? language;
  String? sociability;
  String? work_out;
  String? reg_date;

  MonitoringListDto({this.id, this.patient_id, this.height, this.weight, this.nutrition, this.sleep_at_night, this.sleep_at_lunch, this.language, this.sociability, this.work_out, this.reg_date});

  MonitoringListDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patient_id = json['patient_id'] ?? "";
    height = json['height'] ?? "";
    weight = json['weight'] ?? "";
    nutrition = json['nutrition'] ?? "";
    sleep_at_night = json['sleep_at_night'] ?? "";
    sleep_at_lunch = json['sleep_at_lunch'] ?? "";
    language = json['language'] ?? "";
    sociability = json['sociability'] ?? "";
    work_out = json['work_out'] ?? "";
    reg_date = json['reg_date'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['nutrition'] = this.nutrition;
    data['sleep_at_night'] = this.sleep_at_night;
    data['sleep_at_lunch'] = this.sleep_at_lunch;
    data['language'] = this.language;
    data['sociability'] = this.sociability;
    data['work_out'] = this.work_out;
    data['reg_date'] = this.reg_date;
    return data;
  }
}
