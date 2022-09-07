import 'package:event_bus/event_bus.dart';
import 'package:ourdoctor/global/app_event.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_res_model.g.dart';

@JsonSerializable()
class ApiResModel {
  int? result;
  String? msg;
  String? reason;

  ApiResModel({this.result, this.msg, this.reason});

  factory ApiResModel.fromJson(Map<String, dynamic> json) {
    ApiResModel model =
    json['data'] != null ? _$ApiResModelFromJson(json) : ApiResModel();
    model.fromJson(json); // parse api_res_model
    return model;
  }

  void fromJson(Map<String, dynamic> json) {
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];

    if (result == 104) {
      getIt<EventBus>().fire(AccessTokenFailed());
    }
  }
}