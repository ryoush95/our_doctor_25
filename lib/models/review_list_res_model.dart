class ReviewListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  ReviewListResModel({this.data, this.result, this.msg, this.reason});

  ReviewListResModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductInfo>? lists;

  Data({this.totalCount, this.totalPage, this.isLast, this.lists});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      lists = <ProductInfo>[];
      json['list'].forEach((v) {
        lists!.add(new ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['total_page'] = this.totalPage;
    data['is_last'] = this.isLast;
    if (this.lists != null) {
      data['list'] = this.lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductInfo {
  String? id;
  String? category;
  String? name;
  String? mainImage;
  String? detailImage;
  String? option;
  String? price;
  String? discount;
  String? description;
  String? confirmDate;

  ProductInfo({this.id, this.category, this.name, this.mainImage, this.detailImage, this.option, this.price, this.discount, this.description, this.confirmDate});
  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    name = json['name'] ?? "";
    mainImage = json['main_image'] ?? "";
    detailImage = json['detail_image'] ?? "";
    option = json['option'] ?? "";
    price = json['price'] ?? "";
    discount = json['discount'] ?? "";
    description = json['description'] ?? "";
    confirmDate = json['confirm_date'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['main_image'] = this.mainImage;
    data['detail_image'] = this.detailImage;
    data['option'] = this.option;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['description'] = this.description;
    return data;
  }
}
