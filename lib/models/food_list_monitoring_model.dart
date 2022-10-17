import 'food_list_res_model.dart';

class FoodListMonitorModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  FoodListMonitorModel({this.data, this.result, this.msg, this.reason});

  FoodListMonitorModel.fromJson(Map<String, dynamic> json) {
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
  // List<String>? list;
  String? breakfast;
  String? lunch;
  String? snack;
  String? dinner;
  String? created_at;

  Data({this.breakfast, this.lunch, this.snack, this.dinner, this.created_at});

  Data.fromJson(Map<String, dynamic> json) {
    breakfast = json["breakfast_list"] ?? "";
    lunch = json["lunch_list"] ?? "";
    snack = json["snack_list"] ?? "";
    dinner = json["dinner_list"] ?? "";
    created_at = json["created_at"] ?? "";
    // count = json['count'] ?? 0.25;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      // data['food_sel_list'] = this.list!.map((v) => v.toJson()).toList();
    data['breakfast_list'] = this.breakfast;
    data['lunch_list'] = this.lunch;
    data['snack_list'] = this.snack;
    data['dinner_list'] = this.dinner;
    data['created_at'] = this.created_at;
    // data['count'] = this.count;
    return data;
  }
}