class HomeVaccineResModel {
  HomeVaccineDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeVaccineResModel({this.data, this.result, this.msg, this.reason});

  HomeVaccineResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeVaccineDto.fromJson(json['data']) : null;
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

class HomeVaccineDto {
  List<HealthListDto>? healthList;
  List<HealthListDto>? vaccineList;
  String? tipImage;

  HomeVaccineDto({this.healthList, this.vaccineList, this.tipImage});

  HomeVaccineDto.fromJson(Map<String, dynamic> json) {
    if (json['health_list'] != null) {
      healthList = <HealthListDto>[];
      json['health_list'].forEach((v) {
        healthList!.add(new HealthListDto.fromJson(v));
      });
    }
    if (json['vaccine_list'] != null) {
      vaccineList = <HealthListDto>[];
      json['vaccine_list'].forEach((v) {
        vaccineList!.add(new HealthListDto.fromJson(v));
      });
    }
    tipImage = json['tip_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.healthList != null) {
      data['health_list'] = this.healthList!.map((v) => v.toJson()).toList();
    }
    if (this.vaccineList != null) {
      data['vaccine_list'] = this.vaccineList!.map((v) => v.toJson()).toList();
    }
    data['tip_image'] = this.tipImage;
    return data;
  }
}

class HealthListDto {
  String? id;
  String? name;
  String? periodStart;
  String? periodEnd;
  String? isDay;
  String? createdAt;
  String? updatedAt;
  String? periodStartMonth;
  String? periodEndMonth;

  HealthListDto({this.id, this.name, this.periodStart, this.periodEnd, this.isDay, this.createdAt, this.updatedAt, this.periodStartMonth, this.periodEndMonth});

  HealthListDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    periodStart = json['period_start'];
    periodEnd = json['period_end'];
    isDay = json['is_day'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    periodStartMonth = json['period_start_month'];
    periodEndMonth = json['period_end_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['period_start'] = this.periodStart;
    data['period_end'] = this.periodEnd;
    data['is_day'] = this.isDay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['period_start_month'] = this.periodStartMonth;
    data['period_end_month'] = this.periodEndMonth;
    return data;
  }
}
