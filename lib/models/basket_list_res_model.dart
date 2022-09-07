class BasketListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  BasketListResModel({this.data, this.result, this.msg, this.reason});

  BasketListResModel.fromJson(Map<String, dynamic> json) {
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
  int? total_price;
  int? discount_price;
  String? deliver_price;
  int? tip_point;
  List<BasketDto>? lists;

  Data({this.total_price, this.discount_price, this.deliver_price, this.tip_point, this.lists});

  Data.fromJson(Map<String, dynamic> json) {
    total_price = json['total_price'] ?? 0;
    discount_price = json['discount_price'] ?? 0;
    deliver_price = json['deliver_price'] ?? "";
    tip_point = json['tip_point'] ?? 0;
    if (json['list'] != null) {
      lists = <BasketDto>[];
      json['list'].forEach((v) {
        lists!.add(new BasketDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_price'] = this.total_price;
    data['discount_price'] = this.discount_price;
    data['deliver_price'] = this.deliver_price;
    data['tip_point'] = this.tip_point;
    if (this.lists != null) {
      data['list'] = this.lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BasketDto {
  String? id;
  String? patient_id;
  String? product_id;
  String? created_at;
  String? name;
  String? price;
  String? discount;
  String? count;
  String? max_cnt;
  String? updated_at;
  String? status;
  String? pdt_name;
  String? main_image;

  BasketDto(
      {this.id,
      this.patient_id,
      this.product_id,
      this.created_at,
      this.name,
      this.price,
      this.discount,
      this.count,
      this.max_cnt,
      this.updated_at,
      this.status,
      this.pdt_name,
      this.main_image});

  BasketDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patient_id = json['patient_id'] ?? "";
    product_id = json['product_id'] ?? "";
    created_at = json['created_at'] ?? "";
    name = json['name'] ?? "";
    price = json['price'] ?? "";
    discount = json['discount'] ?? "";
    count = json['count'] ?? "";
    max_cnt = json['max_cnt'] ?? "";
    updated_at = json['updated_at'] ?? "";
    status = json['status'] ?? "";
    pdt_name = json['pdt_name'] ?? "";
    main_image = json['main_image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['product_id'] = this.product_id;
    data['created_at'] = this.created_at;
    data['name'] = this.name;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['count'] = this.count;
    data['max_cnt'] = this.max_cnt;
    data['updated_at'] = this.updated_at;
    data['status'] = this.status;
    data['pdt_name'] = this.pdt_name;
    data['main_image'] = this.main_image;
    return data;
  }
}
