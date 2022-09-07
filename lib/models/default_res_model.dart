class DefaultResModel {
  int? result;
  String? msg;
  String? reason;

  DefaultResModel({this.result, this.msg, this.reason});

  DefaultResModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}
