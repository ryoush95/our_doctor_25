import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {

  late String access_token;
  @JsonKey(fromJson: fromJsonInt, toJson: toJsonInt)
  late int uid;
  late String userName;
  late String sex;
  @JsonKey(fromJson: fromJsonInt, toJson: toJsonInt)
  late int age;
  late String profile;
  late String chartNumber;
  late String district;
  late String hospital;
  late String resident;
  late String phone;
  late String relation;
  late String location;
  late String symptom;
  late String quarantine;
  late String disease;
  late String medication;
  late String symptomDate;
  late String startDate;
  late String endDate;

  UserDto({
    this.access_token = "",
    this.uid = 0,
    this.userName = "",
    this.sex = "",
    this.age = 0,
    this.profile = "",
    this.chartNumber = "",
    this.district = "",
    this.hospital = "",
    this.resident = "",
    this.location = "",
    this.symptom = "",
    this.quarantine = "",
    this.disease = "",
    this.medication = "",
    this.symptomDate = "",
    this.startDate = "",
    this.endDate = "",
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
