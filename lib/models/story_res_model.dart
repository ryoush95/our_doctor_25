class StoryResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  StoryResModel({this.data, this.result, this.msg, this.reason});

  StoryResModel.fromJson(Map<String, dynamic> json) {
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
  List<StoryInfo>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <StoryInfo>[];
      json['list'].forEach((v) {
        list!.add(new StoryInfo.fromJson(v));
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

class StoryInfo {
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

  StoryInfo({this.id, this.category, this.categoryName, this.title, this.url, this.createdAt, this.updatedAt, this.contents, this.tags, this.viewCnt});

  StoryInfo.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
