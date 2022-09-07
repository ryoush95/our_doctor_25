class ActiveListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  ActiveListResModel({this.data, this.result, this.msg, this.reason});

  ActiveListResModel.fromJson(Map<String, dynamic> json) {
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
  List<ActiveDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <ActiveDto>[];
      json['list'].forEach((v) {
        list!.add(new ActiveDto.fromJson(v));
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

class ActiveDto {
  String? patientId;
  String? notificationType;
  String? description;
  String? createdAt;
  String? data;
  String? likeYn;

  ActiveDto({this.patientId, this.notificationType, this.description, this.createdAt, this.data, this.likeYn});

  ActiveDto.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'] ?? "";
    notificationType = json['notification_type'] ?? "";
    description = json['description'] ?? "";
    createdAt = json['created_at'] ?? "";
    data = json['data'] ?? "";
    likeYn = json['like_yn'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['notification_type'] = this.notificationType;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['data'] = this.data;
    data['like_yn'] = this.likeYn;
    return data;
  }
}
