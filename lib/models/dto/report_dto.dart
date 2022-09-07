import 'package:json_annotation/json_annotation.dart';
import 'package:ourdoctor/helpers/bind_json.dart';

part 'report_dto.g.dart';

@JsonSerializable()
class ReportDto {
  @JsonKey(fromJson: fromJsonInt, toJson: toJsonInt)
  int report_uid;
  String morning_time;
  String am_time;
  String morning_temperature;
  String morning_saturation;
  String am_saturation;
  String morning_symptom;
  String morning_breath;
  String am_breath;
  String morning_medication;
  String am_medication;
  String afternoon_time;
  String pm_time;
  String afternoon_temperature;
  String afternoon_saturation;
  String pm_saturation;
  String afternoon_breath;
  String pm_breath;
  String afternoon_symptom;
  String afternoon_medication;
  String pm_medication;

  ReportDto({
    this.report_uid = 0,
    this.morning_time = '',
    this.am_time = '',
    this.morning_temperature = '',
    this.morning_saturation = '',
    this.am_saturation = '',
    this.morning_breath = '',
    this.am_breath = '',
    this.morning_symptom = '',
    this.morning_medication = '',
    this.am_medication = '',
    this.afternoon_time = '',
    this.pm_time = '',
    this.afternoon_temperature = '',
    this.afternoon_saturation = '',
    this.pm_saturation = '',
    this.afternoon_breath = '',
    this.pm_breath = '',
    this.afternoon_symptom = '',
    this.afternoon_medication = '',
    this.pm_medication = '',
  });

  factory ReportDto.fromJson(Map<String, dynamic> json) => _$ReportDtoFromJson(json);

  Map toJson() => _$ReportDtoToJson(this);
}

@JsonSerializable()
class ReportListDto {
  List<ReportDto> list;

  ReportListDto({required this.list}) : super();

  factory ReportListDto.fromJson(Map<String, dynamic> json) => _$ReportListDtoFromJson(json);
}
