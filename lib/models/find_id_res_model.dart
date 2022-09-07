class FindIdResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  FindIdResModel({this.data, this.result, this.msg, this.reason});

  FindIdResModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? signupType;

  Data({this.id, this.signupType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    signupType = json['signup_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['signup_type'] = this.signupType;
    return data;
  }
}
