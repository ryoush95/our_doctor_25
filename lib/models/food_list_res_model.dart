class FoodListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  FoodListResModel({this.data, this.result, this.msg, this.reason});

  FoodListResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<FoodDto>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <FoodDto>[];
      json['list'].forEach((v) {
        list!.add(new FoodDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodDto {
  String? id;
  String? category;
  String? subCategory;
  String? name;
  String? kcal;
  String? createdAt;
  String? updatedAt;
  double? count = 0.25;

  FoodDto({this.id, this.category, this.subCategory, this.name, this.kcal, this.createdAt, this.updatedAt, this.count});

  FoodDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    subCategory = json['sub_category'] ?? "";
    name = json['name'] ?? "";
    kcal = json['kcal'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    count = json['count'] ?? 0.25;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    data['name'] = this.name;
    data['kcal'] = this.kcal;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['count'] = this.count;
    return data;
  }
}
