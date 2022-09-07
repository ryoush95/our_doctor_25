class MyReviewListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  MyReviewListResModel({this.data, this.result, this.msg, this.reason});

  MyReviewListResModel.fromJson(Map<String, dynamic> json) {
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
  List<MyReviewDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <MyReviewDto>[];
      json['list'].forEach((v) {
        list!.add(new MyReviewDto.fromJson(v));
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

class MyReviewDto {
  String? productId;
  String? name;
  String? mainImage;
  String? confirmDate;
  String? dDay;
  String? optionName;
  String? orderProductId;

  MyReviewDto({this.productId, this.name, this.mainImage, this.confirmDate, this.dDay, this.optionName, this.orderProductId});

  MyReviewDto.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? "";
    name = json['name'] ?? "";
    mainImage = json['main_image'] ?? "";
    confirmDate = json['confirm_date'] ?? "";
    dDay = json['d_day'] ?? "";
    optionName = json['option_name'] ?? "";
    orderProductId = json['order_product_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['main_image'] = this.mainImage;
    data['confirm_date'] = this.confirmDate;
    data['d_day'] = this.dDay;
    data['option_name'] = this.optionName;
    data['order_product_id'] = this.orderProductId;
    return data;
  }
}
