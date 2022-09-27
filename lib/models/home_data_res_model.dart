class HomeDataResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  HomeDataResModel({this.data, this.result, this.msg, this.reason});

  HomeDataResModel.fromJson(Map<String, dynamic> json) {
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
  List<StoryList>? storyList;
  List<CommunityList>? communityList;
  List<GrowthList>? growthList;
  List<DevelopmentList>? developmentList;


  Data({this.storyList, this.communityList, this.growthList, this.developmentList, });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['story_list'] != null) {
      storyList = <StoryList>[];
      json['story_list'].forEach((v) {
        storyList!.add(new StoryList.fromJson(v));
      });
    }
    if (json['community_list'] != null) {
      communityList = <CommunityList>[];
      json['community_list'].forEach((v) {
        communityList!.add(new CommunityList.fromJson(v));
      });
    }
    if (json['growth_list'] != null) {
      growthList = <GrowthList>[];
      json['growth_list'].forEach((v) {
        growthList!.add(new GrowthList.fromJson(v));
      });
    }
    if (json['development_list'] != null) {
      developmentList = <DevelopmentList>[];
      json['development_list'].forEach((v) {
        developmentList!.add(new DevelopmentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storyList != null) {
      data['story_list'] = this.storyList!.map((v) => v.toJson()).toList();
    }
    if (this.communityList != null) {
      data['community_list'] = this.communityList!.map((v) => v.toJson()).toList();
    }
    if (this.growthList != null) {
      data['growth_list'] = this.growthList!.map((v) => v.toJson()).toList();
    }
    if (this.developmentList != null) {
      data['development_list'] = this.developmentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoryList {
  String? id;
  String? category;
  String? categoryName;
  String? title;
  String? url;
  String? createdAt;
  String? updatedAt;
  String? contents;
  String? tags;
  String? viewCnt;
  String? description;

  StoryList({this.id, this.category, this.categoryName, this.title, this.url, this.createdAt, this.updatedAt, this.contents, this.tags, this.viewCnt, this.description});

  StoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    categoryName = json['category_name'] ?? "";
    title = json['title'] ?? "";
    url = json['url'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    contents = json['contents'] ?? "";
    tags = json['tags'] ?? "";
    viewCnt = json['view_cnt'] ?? "";
    description = json['description'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['category_name'] = this.categoryName;
    data['title'] = this.title;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['contents'] = this.contents;
    data['tags'] = this.tags;
    data['view_cnt'] = this.viewCnt;
    data['description'] = this.description;
    return data;
  }
}

class CommunityList {
  String? uid;
  String? topic;
  String? content;
  String? regTime;
  String? userUid;
  String? code;
  String? status;
  String? delYn;
  String? title;
  String? imgUrl;
  String? fixed;
  String? image;
  String? tabKind;
  String? blogUrl;

  CommunityList({
    this.uid,
    this.topic,
    this.content,
    this.regTime,
    this.userUid,
    this.code,
    this.status,
    this.delYn,
    this.title,
    this.imgUrl,
    this.fixed,
    this.image,
    this.tabKind,
    this.blogUrl,
  });

  CommunityList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? "";
    topic = json['topic'] ?? "";
    content = json['content'] ?? "";
    regTime = json['reg_time'] ?? "";
    userUid = json['user_uid'] ?? "";
    code = json['code'] ?? "";
    status = json['status'] ?? "";
    delYn = json['del_yn'] ?? "";
    title = json['title'] ?? "";
    imgUrl = json['img_url'] ?? "";
    fixed = json['fixed'] ?? "";
    image = json['image'] ?? "";
    tabKind = json['tab_kind'] ?? "";
    blogUrl = json['blog_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['topic'] = this.topic;
    data['content'] = this.content;
    data['reg_time'] = this.regTime;
    data['user_uid'] = this.userUid;
    data['code'] = this.code;
    data['status'] = this.status;
    data['del_yn'] = this.delYn;
    data['title'] = this.title;
    data['img_url'] = this.imgUrl;
    data['fixed'] = this.fixed;
    data['image'] = this.image;
    data['tab_kind'] = this.tabKind;
    data['blog_url'] = this.blogUrl;
    return data;
  }
}

class GrowthList {
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
  String? maxCnt;
  String? liked;
  String? rating;
  String? buyCnt;

  GrowthList(
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
      this.maxCnt,
      this.liked,
      this.rating,
      this.buyCnt});

  GrowthList.fromJson(Map<String, dynamic> json) {
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
    maxCnt = json['max_cnt'] ?? "";
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
    data['max_cnt'] = this.maxCnt;
    data['liked'] = this.liked;
    data['rating'] = this.rating;
    data['buy_cnt'] = this.buyCnt;
    return data;
  }
}

class DevelopmentList {
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
  String? maxCnt;
  String? liked;
  String? rating;
  String? buyCnt;

  DevelopmentList(
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
      this.maxCnt,
      this.liked,
      this.rating,
      this.buyCnt});

  DevelopmentList.fromJson(Map<String, dynamic> json) {
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
    maxCnt = json['max_cnt'] ?? "";
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
    data['max_cnt'] = this.maxCnt;
    data['liked'] = this.liked;
    data['rating'] = this.rating;
    data['buy_cnt'] = this.buyCnt;
    return data;
  }
}
