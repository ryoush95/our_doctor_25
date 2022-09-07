class PointHisResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  PointHisResModel({this.data, this.result, this.msg, this.reason});

  PointHisResModel.fromJson(Map<String, dynamic> json) {
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
  List<PointHisDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <PointHisDto>[];
      json['list'].forEach((v) {
        list!.add(new PointHisDto.fromJson(v));
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

class PointHisDto {
  String? id;
  String? patientId;
  String? type;
  String? targetId;
  String? createdAt;
  int? point;

  PointHisDto({this.id, this.patientId, this.type, this.targetId, this.createdAt, this.point});

  PointHisDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    type = json['type'] ?? "";
    targetId = json['target_id'] ?? "";
    createdAt = json['created_at'] ?? "";
    point = int.parse(json['point'] ?? "0");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['type'] = this.type;
    data['target_id'] = this.targetId;
    data['created_at'] = this.createdAt;
    data['point'] = this.point;
    return data;
  }
}
