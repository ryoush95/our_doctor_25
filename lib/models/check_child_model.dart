class CheckChildQuizModel {
  // Data? data;
  int? result;
  String? msg;
  String? reason;

  CheckChildQuizModel({this.result, this.msg, this.reason});

  CheckChildQuizModel.fromJson(Map<String, dynamic> json) {
    // data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
