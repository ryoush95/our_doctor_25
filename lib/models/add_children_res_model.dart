class AddChildResModel {
  int? data;
  int? result;
  String? msg;
  String? reason;

  AddChildResModel({this.data, this.result, this.msg, this.reason});

  AddChildResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] ?? 0;
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}
