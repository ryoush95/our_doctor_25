class OrderStartResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  OrderStartResModel({this.data, this.result, this.msg, this.reason});

  OrderStartResModel.fromJson(Map<String, dynamic> json) {
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
  String? merchantUid;
  int? id;

  Data({this.merchantUid});

  Data.fromJson(Map<String, dynamic> json) {
    merchantUid = json['merchant_uid'] ?? "";
    id = json['id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_uid'] = this.merchantUid;
    return data;
  }
}