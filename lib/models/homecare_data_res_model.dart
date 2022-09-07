class HomeCareDataResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  HomeCareDataResModel({this.data, this.result, this.msg, this.reason});

  HomeCareDataResModel.fromJson(Map<String, dynamic> json) {
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
  List<BannerList>? bannerList;
  List<PdtLikeDto>? pdtLikeList;
  List<PdtLikeDto>? pdtNewList;

  Data({this.bannerList, this.pdtLikeList, this.pdtNewList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banner_list'] != null) {
      bannerList = <BannerList>[];
      json['banner_list'].forEach((v) {
        bannerList!.add(new BannerList.fromJson(v));
      });
    }
    if (json['pdt_like_list'] != null) {
      pdtLikeList = <PdtLikeDto>[];
      json['pdt_like_list'].forEach((v) {
        pdtLikeList!.add(new PdtLikeDto.fromJson(v));
      });
    }
    if (json['pdt_new_list'] != null) {
      pdtNewList = <PdtLikeDto>[];
      json['pdt_new_list'].forEach((v) {
        pdtNewList!.add(new PdtLikeDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerList != null) {
      data['banner_list'] = this.bannerList!.map((v) => v.toJson()).toList();
    }
    if (this.pdtLikeList != null) {
      data['pdt_like_list'] = this.pdtLikeList!.map((v) => v.toJson()).toList();
    }
    if (this.pdtNewList != null) {
      data['pdt_new_list'] = this.pdtNewList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerList {
  String? id;
  String? category;
  String? title;
  String? content;
  String? image;

  BannerList({this.id, this.category, this.title, this.content, this.image});

  BannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    title = json['title'] ?? "";
    content = json['content'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['title'] = this.title;
    data['content'] = this.content;
    data['image'] = this.image;
    return data;
  }
}

class PdtLikeDto {
  String? id;
  String? category;
  String? category2;
  String? category3;
  String? name;
  String? mainImage;
  String? detailImage;
  String? price;
  String? discount;
  String? description;
  String? tags;
  String? createdAt;
  String? videoLink;
  String? sellerId;
  String? notice;
  String? updatedAt;
  String? status;
  String? minAge;
  String? maxAge;
  String? tabKind;
  String? liked;
  String? rating;
  String? buyCnt;

  PdtLikeDto(
      {this.id,
      this.category,
      this.category2,
      this.category3,
      this.name,
      this.mainImage,
      this.detailImage,
      this.price,
      this.discount,
      this.description,
      this.tags,
      this.createdAt,
      this.videoLink,
      this.sellerId,
      this.notice,
      this.updatedAt,
      this.status,
      this.minAge,
      this.maxAge,
      this.tabKind,
      this.liked,
      this.rating,
      this.buyCnt});

  PdtLikeDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    category2 = json['category2'] ?? "";
    category3 = json['category3'] ?? "";
    name = json['name'] ?? "";
    mainImage = json['main_image'] ?? "";
    detailImage = json['detail_image'] ?? "";
    price = json['price'] ?? "";
    discount = json['discount'] ?? "";
    description = json['description'] ?? "";
    tags = json['tags'] ?? "";
    createdAt = json['created_at'] ?? "";
    videoLink = json['video_link'] ?? "";
    sellerId = json['seller_id'] ?? "";
    notice = json['notice'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    status = json['status'] ?? "";
    minAge = json['min_age'] ?? "";
    maxAge = json['max_age'] ?? "";
    tabKind = json['tab_kind'] ?? "";
    liked = json['liked'] ?? "";
    rating = json['rating'] ?? "";
    buyCnt = json['buy_cnt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['category2'] = this.category2;
    data['category3'] = this.category3;
    data['name'] = this.name;
    data['main_image'] = this.mainImage;
    data['detail_image'] = this.detailImage;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['created_at'] = this.createdAt;
    data['video_link'] = this.videoLink;
    data['seller_id'] = this.sellerId;
    data['notice'] = this.notice;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['min_age'] = this.minAge;
    data['max_age'] = this.maxAge;
    data['tab_kind'] = this.tabKind;
    data['liked'] = this.liked;
    data['rating'] = this.rating;
    data['buy_cnt'] = this.buyCnt;
    return data;
  }
}
