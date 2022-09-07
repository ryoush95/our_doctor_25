class ReviewDetailResModel {
  ReviewDetailDto? data;
  int? result;
  String? msg;
  String? reason;

  ReviewDetailResModel({this.data, this.result, this.msg, this.reason});

  ReviewDetailResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ReviewDetailDto.fromJson(json['data']) : null;
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

class ReviewDetailDto {
  String? id;
  String? patientId;
  String? productId;
  String? orderProductId;
  String? rating;
  String? text;
  String? photos;
  String? deletedAt;
  String? createdAt;
  String? addDate;
  String? name;
  String? mainImage;
  String? optionName;
  String? photosUrl;

  ReviewDetailDto({this.id, this.patientId, this.productId, this.orderProductId, this.rating, this.text, this.photos, this.deletedAt, this.createdAt, this.addDate, this.name, this.mainImage, this.optionName, this.photosUrl});

  ReviewDetailDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    productId = json['product_id'] ?? "";
    orderProductId = json['order_product_id'] ?? "";
    rating = json['rating'] ?? "";
    text = json['text'] ?? "";
    photos = json['photos'] ?? "";
    deletedAt = json['deleted_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    addDate = json['add_date'] ?? "";
    name = json['name'] ?? "";
    mainImage = json['main_image'] ?? "";
    optionName = json['option_name'] ?? "";
    photosUrl = json['photos_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['product_id'] = this.productId;
    data['order_product_id'] = this.orderProductId;
    data['rating'] = this.rating;
    data['text'] = this.text;
    data['photos'] = this.photos;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['add_date'] = this.addDate;
    data['name'] = this.name;
    data['main_image'] = this.mainImage;
    data['option_name'] = this.optionName;
    data['photos_url'] = this.photosUrl;
    return data;
  }
}
