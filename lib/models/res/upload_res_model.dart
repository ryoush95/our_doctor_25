import 'package:json_annotation/json_annotation.dart';
import 'package:ourdoctor/models/dto/upload_dto.dart';

import 'api_res_model.dart';

part 'upload_res_model.g.dart';

@JsonSerializable()
class UploadResModel extends ApiResModel {
  UploadDto? data;

  UploadResModel({this.data}) : super();

  factory UploadResModel.fromJson(Map<String, dynamic> json) {
    UploadResModel model = json['data'] != null
        ? _$UploadResModelFromJson(json)
        : UploadResModel();
    model.fromJson(json); // parse api_res_model
    return model;
  }

  Map toJson() => _$UploadResModelToJson(this);
}
