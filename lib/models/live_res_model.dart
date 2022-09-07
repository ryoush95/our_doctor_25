class LiveResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  LiveResModel({this.data, this.result, this.msg, this.reason});

  LiveResModel.fromJson(Map<String, dynamic> json) {
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
  bool? isNew;
  String? point;

  Data({this.isNew, this.point});

  Data.fromJson(Map<String, dynamic> json) {
    isNew = json['is_new'];
    point = json['point'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_new'] = this.isNew;
    data['point'] = this.point;
    return data;
  }
}
