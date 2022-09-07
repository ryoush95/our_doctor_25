class ProductListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  ProductListResModel({this.data, this.result, this.msg, this.reason});

  ProductListResModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductDto>? lists;

  Data({this.totalCount, this.totalPage, this.isLast, this.lists});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      lists = <ProductDto>[];
      json['list'].forEach((v) {
        lists!.add(new ProductDto.fromJson(v));
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

class ProductDto {
  String? id;
  String? category;
  String? name;
  String? option;
  String? price;
  String? tags;
  String? add_time;
  String? liked;
  String? mainImage;
  String? discount;

  ProductDto({this.id, this.category, this.name, this.option, this.price, this.tags, this.add_time, this.liked, this.mainImage, this.discount});

  ProductDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    name = json['name'] ?? "";
    option = json['option'] ?? "";
    price = json['price'] ?? "";
    tags = json['tags'] ?? "";
    add_time = json['add_time'] ?? "";
    liked = json['liked'] ?? "";
    mainImage = json['main_image'] ?? "";
    discount = json['discount'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['name'] = this.name;
    data['option'] = this.option;
    data['price'] = this.price;
    data['tags'] = this.tags;
    data['add_time'] = this.add_time;
    data['liked'] = this.liked;
    return data;
  }
}
