class ProductReviewListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  ProductReviewListResModel({this.data, this.result, this.msg, this.reason});

  ProductReviewListResModel.fromJson(Map<String, dynamic> json) {
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
  int? totalCount;
  int? totalPage;
  bool? isLast;
  List<ProductReviewDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <ProductReviewDto>[];
      json['list'].forEach((v) {
        list!.add(new ProductReviewDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['total_page'] = this.totalPage;
    data['is_last'] = this.isLast;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductReviewDto {
  String? id;
  String? patientId;
  String? productId;
  String? rating;
  String? text;
  String? photos;
  String? deletedAt;
  String? createdAt;
  String? patientName;

  ProductReviewDto({this.id, this.patientId, this.productId, this.rating, this.text, this.photos, this.deletedAt, this.createdAt, this.patientName});

  ProductReviewDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    productId = json['product_id'] ?? "";
    rating = json['rating'] ?? "";
    text = json['text'] ?? "";
    photos = json['photos'] ?? "";
    deletedAt = json['deleted_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    patientName = json['patient_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['product_id'] = this.productId;
    data['rating'] = this.rating;
    data['text'] = this.text;
    data['photos'] = this.photos;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['patient_name'] = this.patientName;
    return data;
  }
}
