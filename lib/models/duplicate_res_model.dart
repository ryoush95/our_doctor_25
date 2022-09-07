class DuplicateResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  DuplicateResModel({this.data, this.result, this.msg, this.reason});

  DuplicateResModel.fromJson(Map<String, dynamic> json) {
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
  bool? isDuplicated;

  Data({this.isDuplicated});

  Data.fromJson(Map<String, dynamic> json) {
    isDuplicated = json['is_duplicated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_duplicated'] = this.isDuplicated;
    return data;
  }
}
