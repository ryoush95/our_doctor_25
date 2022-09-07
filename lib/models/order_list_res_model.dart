class OrderListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  OrderListResModel({this.data, this.result, this.msg, this.reason});

  OrderListResModel.fromJson(Map<String, dynamic> json) {
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
  List<OrderDto>? lists;

  Data({this.totalCount, this.totalPage, this.isLast, this.lists});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      lists = <OrderDto>[];
      json['list'].forEach((v) {
        lists!.add(new OrderDto.fromJson(v));
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
  String? addDate;
  List<ProductInfo>? productList;
  String? exchangeAction;
  String? exchangeStatus;
  String? exchangeDeliverCompany;
  String? exchangeDeliverNumber;
  List<ExchangeProductInfo>? exchangeProductList;

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
      this.addDate,
      this.productList,
      this.exchangeAction,
      this.exchangeStatus,
      this.exchangeDeliverCompany,
      this.exchangeDeliverNumber,
      this.exchangeProductList});

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
    addDate = json['add_date'] ?? "";
    if (json['products'] != null) {
      productList = <ProductInfo>[];
      json['products'].forEach((v) {
        productList!.add(new ProductInfo.fromJson(v));
      });
    }
    exchangeAction = json['exchange_action'] ?? "";
    exchangeStatus = json['exchange_status'] ?? "";
    exchangeDeliverCompany = json['exchange_deliver_company'] ?? "";
    exchangeDeliverNumber = json['exchange_deliver_number'] ?? "";
    if (json['exchange_product'] != null) {
      exchangeProductList = <ExchangeProductInfo>[];
      json['exchange_product'].forEach((v) {
        exchangeProductList!.add(new ExchangeProductInfo.fromJson(v));
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
    data['add_date'] = this.addDate;
    data['exchange_action'] = this.exchangeAction;
    data['exchange_status'] = this.exchangeStatus;
    data['exchange_deliver_company'] = this.exchangeDeliverCompany;
    data['exchange_deliver_number'] = this.exchangeDeliverNumber;
    return data;
  }
}

class ProductInfo {
  String? productId;
  String? basketId;
  String? optionName;
  String? optionPrice;
  String? optionCnt;
  String? optionDiscount;
  String? name;
  String? mainImage;
  int? payPrice;
  String? orderProductId;
  String? remainCnt;

  ProductInfo(
      {this.productId,
        this.basketId,
        this.optionName,
        this.optionPrice,
        this.optionCnt,
        this.optionDiscount,
        this.name,
        this.mainImage,
        this.payPrice,
        this.orderProductId,
        this.remainCnt});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? "";
    basketId = json['basket_id'] ?? "";
    optionName = json['option_name'] ?? "";
    optionPrice = json['option_price'] ?? "";
    optionCnt = json['option_cnt'] ?? "";
    optionDiscount = json['option_discount'] ?? "";
    name = json['name'] ?? "";
    mainImage = json['main_image'] ?? "";
    payPrice = json['pay_price'] ?? 0;
    orderProductId = json['order_product_id'] ?? "";
    remainCnt = json['remain_cnt'] ?? "";
  }
}

class ExchangeProductInfo {
  String? id;
  String? patientId;
  String? orderId;
  String? orderProductId;
  String? count;
  String? action;
  String? problem;
  String? problemDetail;
  String? createdAt;
  String? productAddressDetail;
  String? productAddress;
  String? productPostcode;
  String? productPhoneNumber;
  String? productOwner;
  String? deliverAddressDetail;
  String? deliverAddress;
  String? deliverPostcode;
  String? refundPrice;
  String? status;
  String? deliverNum;
  String? deliverCompany;

  ExchangeProductInfo(
      {this.id,
      this.patientId,
      this.orderId,
      this.orderProductId,
      this.count,
      this.action,
      this.problem,
      this.problemDetail,
      this.createdAt,
      this.productAddressDetail,
      this.productAddress,
      this.productPostcode,
      this.productPhoneNumber,
      this.productOwner,
      this.deliverAddressDetail,
      this.deliverAddress,
      this.deliverPostcode,
      this.refundPrice,
      this.status,
      this.deliverNum,
      this.deliverCompany});

  ExchangeProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    orderId = json['order_id'] ?? "";
    orderProductId = json['order_product_id'] ?? "";
    count = json['count'] ?? "";
    action = json['action'] ?? "";
    problem = json['problem'] ?? "";
    problemDetail = json['problem_detail'] ?? "";
    createdAt = json['created_at'] ?? "";
    productAddressDetail = json['product_address_detail'] ?? "";
    productAddress = json['product_address'] ?? "";
    productPostcode = json['product_postcode'] ?? "";
    productPhoneNumber = json['product_phone_number'] ?? "";
    productOwner = json['product_owner'] ?? "";
    deliverAddressDetail = json['deliver_address_detail'] ?? "";
    deliverAddress = json['deliver_address'] ?? "";
    deliverPostcode = json['deliver_postcode'] ?? "";
    refundPrice = json['refund_price'] ?? "";
    status = json['status'] ?? "";
    deliverNum = json['deliver_num'] ?? "";
    deliverCompany = json['deliver_company'] ?? "";
  }
}
