class MbtiQuizSendResModel {
  int? result;
  String? msg;
  String? reason;

  MbtiQuizSendResModel ({this.result, this.msg, this.reason});

  MbtiQuizSendResModel.fromJson(Map<String, dynamic> json) {
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