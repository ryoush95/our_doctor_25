class OrderDetailResModel {
  OrderDto? data;
  int? result;
  String? msg;
  String? reason;

  OrderDetailResModel({this.data, this.result, this.msg, this.reason});

  OrderDetailResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderDto.fromJson(json['data']) : null;
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

class OrderDto {
  String? id;
  String? patientId;
  String? deliverAddress;
  String? point;
  String? totalPrice;
  String? deliverPrice;
  String? payMethod;
  String? merchantUid;
  String? status;
  String? updatedAt;
  String? createdAt;
  String? deliverAddressDetail;
  String? deliverPostcode;
  String? basketIds;
  String? discountPrice;
  String? deliverCompany;
  String? deliverNumber;
  List<ProductInfo>? productList;

  OrderDto(
      {this.id,
      this.patientId,
      this.deliverAddress,
      this.point,
      this.totalPrice,
      this.deliverPrice,
      this.payMethod,
      this.merchantUid,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.deliverAddressDetail,
      this.deliverPostcode,
      this.basketIds,
      this.discountPrice,
      this.deliverCompany,
      this.deliverNumber,
      this.productList});

  OrderDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    deliverAddress = json['deliver_address'] ?? "";
    point = json['point'] ?? "";
    totalPrice = json['total_price'] ?? "";
    deliverPrice = json['deliver_price'] ?? "";
    payMethod = json['pay_method'] ?? "";
    merchantUid = json['merchant_uid'] ?? "";
    status = json['status'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    createdAt = json['created_at'] ?? "";
    deliverAddressDetail = json['deliver_address_detail'] ?? "";
    deliverPostcode = json['deliver_postcode'] ?? "";
    basketIds = json['basket_ids'] ?? "";
    discountPrice = json['discount_price'] ?? "";
    deliverCompany = json['deliver_company'] ?? "";
    deliverNumber = json['deliver_number'] ?? "";
    if (json['products'] != null) {
      productList = <ProductInfo>[];
      json['products'].forEach((v) {
        productList!.add(new ProductInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['deliver_address'] = this.deliverAddress;
    data['point'] = this.point;
    data['total_price'] = this.totalPrice;
    data['deliver_price'] = this.deliverPrice;
    data['pay_method'] = this.payMethod;
    data['merchant_uid'] = this.merchantUid;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['deliver_address_detail'] = this.deliverAddressDetail;
    data['deliver_postcode'] = this.deliverPostcode;
    data['basket_ids'] = this.basketIds;
    data['discount_price'] = this.discountPrice;
    data['deliver_company'] = this.deliverCompany;
    data['deliver_number'] = this.deliverNumber;
    return data;
  }
}

class ProductInfo {
  String? orderProductId;
  String? optionName;
  String? optionPrice;
  String? optionCnt;
  String? optionDiscount;
  String? name;
  String? mainImage;
  String? productId;
  int? payPrice;
  String? remainCnt;

  ProductInfo(
      {this.orderProductId,
      this.optionName,
      this.optionPrice,
      this.optionCnt,
      this.optionDiscount,
      this.name,
      this.mainImage,
      this.productId,
      this.payPrice,
      this.remainCnt});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    orderProductId = json['order_product_id'] ?? "";
    optionName = json['option_name'] ?? "";
    optionPrice = json['option_price'] ?? "";
    optionCnt = json['option_cnt'] ?? "";
    optionDiscount = json['option_discount'] ?? "";
    name = json['name'] ?? "";
    mainImage = json['main_image'] ?? "";
    productId = json['product_id'] ?? "";
    payPrice = json['pay_price'] ?? 0;
    remainCnt = json['remain_cnt'] ?? "";
  }
}
