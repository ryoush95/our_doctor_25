import 'package:ourdoctor/models/homecare_data_res_model.dart';

class HomeCareListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  HomeCareListResModel({this.data, this.result, this.msg, this.reason});

  HomeCareListResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.data != null) {
    //   data['data'] = this.data!.toJson();
    // }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class Data {
  List<PdtLikeDto>? list1;
  List<PdtLikeDto>? list2;

  Data({this.list1, this.list2});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list1 = <PdtLikeDto>[];
      list2 = <PdtLikeDto>[];
      var data = json['list'];
      var data1 = data[0];
      var data2 = data[1];
      data1.forEach((v) {
        list1!.add(new PdtLikeDto.fromJson(v));
      });
      data2.forEach((v) {
        list2!.add(new PdtLikeDto.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.list != null) {
  //     data['list'] = this.list!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}
