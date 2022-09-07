class SignupParentResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  SignupParentResModel({this.data, this.result, this.msg, this.reason});

  SignupParentResModel.fromJson(Map<String, dynamic> json) {
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
  int? parent_id;
  String? access_token;

  Data({this.parent_id, this.access_token});

  Data.fromJson(Map<String, dynamic> json) {
    parent_id = json['parent_id'] ?? 0;
    access_token = json['access_token'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent_id'] = this.parent_id;
    data['access_token'] = this.access_token;
    return data;
  }
}
