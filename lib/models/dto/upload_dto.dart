import 'package:ourdoctor/helpers/common_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_dto.g.dart';

@JsonSerializable()
class UploadDto {
  late final String file_url;

  UploadDto({this.file_url = ''});

  factory UploadDto.fromJson(Map<String, dynamic> json) => _$UploadDtoFromJson(json);

  Map toJson() => _$UploadDtoToJson(this);
}
