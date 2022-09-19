class CheckChildQuizModel {
  CheckChildData? data;
  int? result;
  String? msg;
  String? reason;

  CheckChildQuizModel({this.data, this.result, this.msg, this.reason});

  CheckChildQuizModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CheckChildData.fromJson(json['data']) : null;
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

class CheckChildData {
  int? parent_id;
  String? access_token;

  CheckChildData({this.parent_id, this.access_token});

  CheckChildData.fromJson(Map<String, dynamic> json) {
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
