class HospitalListResModel {
  List<HospitalDto>? data;
  int? result;
  String? msg;
  String? reason;

  HospitalListResModel({this.data, this.result, this.msg, this.reason});

  HospitalListResModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HospitalDto>[];
      json['data'].forEach((v) {
        data!.add(new HospitalDto.fromJson(v));
      });
    }
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class HospitalDto {
  String? id;
  String? district;
  String? name;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  String? zipCode;
  String? address;
  String? addressDetail;
  String? longitude;
  String? latitude;
  String? city;

  HospitalDto({this.id, this.district, this.name, this.phoneNumber, this.createdAt, this.updatedAt, this.zipCode, this.address, this.addressDetail, this.longitude, this.latitude, this.city});

  HospitalDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    district = json['district'] ?? "";
    name = json['name'] ?? "";
    phoneNumber = json['phone_number'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    zipCode = json['zip_code'] ?? "";
    address = json['address'] ?? "";
    addressDetail = json['address_detail'] ?? "";
    longitude = json['longitude'] ?? "";
    latitude = json['latitude'] ?? "";
    city = json['city'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district'] = this.district;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['zip_code'] = this.zipCode;
    data['address'] = this.address;
    data['address_detail'] = this.addressDetail;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['city'] = this.city;
    return data;
  }
}
