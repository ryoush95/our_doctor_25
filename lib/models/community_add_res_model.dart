class CommunityAddResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  CommunityAddResModel({this.data, this.result, this.msg, this.reason});

  CommunityAddResModel.fromJson(Map<String, dynamic> json) {
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
  String? uid;

  Data({this.uid});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    return data;
  }
}
