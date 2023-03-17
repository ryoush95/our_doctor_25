import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';

class ChildInfoResModel {
  ChildDto? data;
  int? result;
  String? msg;
  String? reason;

  ChildInfoResModel({this.data, this.result, this.msg, this.reason});

  ChildInfoResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ChildDto.fromJson(json['data']) : null;
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

class ChildDto {
  String? id;
  String? uid;
  String? confirmedDate;
  String? confirmedNumber;
  String? name;
  String? registrationNumber;
  String? birth;
  String? age;
  String? phoneNumber;
  String? address;
  String? symptom;
  String? appearanceDate;
  String? people;
  String? disease;
  String? medications;
  String? speciality;
  String? startDate;
  String? expectedDate;
  String? monitoringExpectedDate;
  String? monitoringDate;
  String? transfer;
  String? kitDate;
  String? note;
  String? prescription;
  String? createdAt;
  String? updatedAt;
  String? approvedDate;
  String? endDate;
  String? keyword;
  String? phone;
  String? devType;
  String? fcmToken;
  String? accessToken;
  String? loginTime;
  String? area;
  String? message;
  String? newAlarmCnt;
  String? profileImgUrl;
  String? hospitalId;
  String? hospitalName;
  String? hospitalArea;
  String? signupType;
  String? loginId;
  String? password;
  String? postcode;
  String? addressDetail;
  String? addChild;
  String? alarmYn;
  String? systemAlarmYn;
  String? selectedChildUid;
  String? weight;
  String? height;
  List<ChildList>? childList;
  int? gender;
  List<EmergencyList1>? emergencyList;
  String? hospitalPhoneNumber;
  String? nickname;
  List<Null>? phoneInfo;

  ChildDto(
      {this.id,
      this.uid,
      this.confirmedDate,
      this.confirmedNumber,
      this.name,
      this.registrationNumber,
      this.birth,
      this.age,
      this.phoneNumber,
      this.address,
      this.symptom,
      this.appearanceDate,
      this.people,
      this.disease,
      this.medications,
      this.speciality,
      this.startDate,
      this.expectedDate,
      this.monitoringExpectedDate,
      this.monitoringDate,
      this.transfer,
      this.kitDate,
      this.note,
      this.prescription,
      this.createdAt,
      this.updatedAt,
      this.approvedDate,
      this.endDate,
      this.keyword,
      this.phone,
      this.devType,
      this.fcmToken,
      this.accessToken,
      this.loginTime,
      this.area,
      this.message,
      this.newAlarmCnt,
      this.profileImgUrl,
      this.hospitalId,
      this.hospitalName,
      this.hospitalArea,
      this.signupType,
      this.loginId,
      this.password,
      this.postcode,
      this.addressDetail,
      this.addChild,
      this.alarmYn,
      this.systemAlarmYn,
      this.selectedChildUid,
      this.weight,
      this.height,
      this.childList,
      this.gender,
      this.emergencyList,
      this.hospitalPhoneNumber,
      this.nickname,
      this.phoneInfo});

  ChildDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    uid = json['uid'] ?? "";
    confirmedDate = json['confirmed_date'] ?? "";
    confirmedNumber = json['confirmed_number'] ?? "";
    name = json['name'] ?? "";
    registrationNumber = json['registration_number'] ?? "";
    birth = json['birth'] ?? "";
    age = json['age'] ?? "";
    phoneNumber = json['phone_number'] ?? "";
    address = json['address'] ?? "";
    symptom = json['symptom'] ?? "";
    appearanceDate = json['appearance_date'] ?? "";
    people = json['people'] ?? "";
    disease = json['disease'] ?? "";
    medications = json['medications'] ?? "";
    speciality = json['speciality'] ?? "";
    startDate = json['start_date'] ?? "";
    expectedDate = json['expected_date'] ?? "";
    monitoringExpectedDate = json['monitoring_expected_date'] ?? "";
    monitoringDate = json['monitoring_date'] ?? "";
    transfer = json['transfer'] ?? "";
    kitDate = json['kit_date'] ?? "";
    note = json['note'] ?? "";
    prescription = json['prescription'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    approvedDate = json['approved_date'] ?? "";
    endDate = json['end_date'] ?? "";
    keyword = json['keyword'] ?? "";
    phone = json['phone'] ?? "";
    devType = json['dev_type'] ?? "";
    fcmToken = json['fcm_token'] ?? "";
    accessToken = json['access_token'] ?? "";
    loginTime = json['login_time'] ?? "";
    area = json['area'] ?? "";
    message = json['message'] ?? "";
    newAlarmCnt = json['new_alarm_cnt'] ?? "";
    profileImgUrl = json['profile_img_url'] ?? "";
    hospitalId = json['hospital_id'] ?? "";
    hospitalName = json['hospital_name'] ?? "";
    hospitalArea = json['hospital_area'] ?? "";
    signupType = json['signup_type'] ?? "";
    loginId = json['login_id'] ?? "";
    password = json['password'] ?? "";
    postcode = json['postcode'] ?? "";
    addressDetail = json['address_detail'] ?? "";
    addChild = json['add_child'] ?? "";
    alarmYn = json['alarm_yn'] ?? "";
    systemAlarmYn = json['system_alarm_yn'] ?? "";
    selectedChildUid = json['selected_child_uid'] ?? "";
    weight = json['weight'] ?? "";
    height = json['height'] ?? "";
    if (json['child_list'] != null) {
      childList = <ChildList>[];
      json['child_list'].forEach((v) {
        childList!.add(new ChildList.fromJson(v));
      });
    }
    gender = json['gender'];
    if (json['emergency_list'] != null) {
      emergencyList = <EmergencyList1>[];
      json['emergency_list'].forEach((v) {
        emergencyList!.add(new EmergencyList1.fromJson(v));
      });
    }
    hospitalPhoneNumber = json['hospital_phone_number'] ?? "";
    nickname = json['nickname'] ?? "";
    // if (json['phone_info'] != null) {
    //   phoneInfo = <Null>[];
    //   json['phone_info'].forEach((v) {
    //     phoneInfo!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['confirmed_date'] = this.confirmedDate;
    data['confirmed_number'] = this.confirmedNumber;
    data['name'] = this.name;
    data['registration_number'] = this.registrationNumber;
    data['birth'] = this.birth;
    data['age'] = this.age;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    data['symptom'] = this.symptom;
    data['appearance_date'] = this.appearanceDate;
    data['people'] = this.people;
    data['disease'] = this.disease;
    data['medications'] = this.medications;
    data['speciality'] = this.speciality;
    data['start_date'] = this.startDate;
    data['expected_date'] = this.expectedDate;
    data['monitoring_expected_date'] = this.monitoringExpectedDate;
    data['monitoring_date'] = this.monitoringDate;
    data['transfer'] = this.transfer;
    data['kit_date'] = this.kitDate;
    data['note'] = this.note;
    data['prescription'] = this.prescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['approved_date'] = this.approvedDate;
    data['end_date'] = this.endDate;
    data['keyword'] = this.keyword;
    data['phone'] = this.phone;
    data['dev_type'] = this.devType;
    data['fcm_token'] = this.fcmToken;
    data['access_token'] = this.accessToken;
    data['login_time'] = this.loginTime;
    data['area'] = this.area;
    data['message'] = this.message;
    data['new_alarm_cnt'] = this.newAlarmCnt;
    data['profile_img_url'] = this.profileImgUrl;
    data['hospital_id'] = this.hospitalId;
    data['hospital_name'] = this.hospitalName;
    data['hospital_area'] = this.hospitalArea;
    data['signup_type'] = this.signupType;
    data['login_id'] = this.loginId;
    data['password'] = this.password;
    data['postcode'] = this.postcode;
    data['address_detail'] = this.addressDetail;
    data['add_child'] = this.addChild;
    data['alarm_yn'] = this.alarmYn;
    data['system_yn'] = this.systemAlarmYn;
    data['selected_child_uid'] = this.selectedChildUid;
    data['weight'] = this.weight;
    data['height'] = this.height;
    if (this.childList != null) {
      data['child_list'] = this.childList!.map((v) => v.toJson()).toList();
    }
    data['gender'] = this.gender;
    if (this.emergencyList != null) {
      data['emergency_list'] = this.emergencyList!.map((v) => v.toJson()).toList();
    }
    data['hospital_phone_number'] = this.hospitalPhoneNumber;
    data['nickname'] = this.nickname;
    // if (this.phoneInfo != null) {
    //   data['phone_info'] = this.phoneInfo!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
