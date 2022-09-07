import 'package:json_annotation/json_annotation.dart';
import 'package:ourdoctor/models/dto/user_dto.dart';

import 'api_res_model.dart';

part 'user_res_model.g.dart';

@JsonSerializable()
class UserResModel extends ApiResModel {
  UserDto? data;

  UserResModel({this.data}) : super();

  factory UserResModel.fromJson(Map<String, dynamic> json) {
    UserResModel model =
        json['data'] != null ? _$UserResModelFromJson(json) : UserResModel();
    model.fromJson(json); // parse api_res_model
    return model;
  }
}
