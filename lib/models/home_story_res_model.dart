class HomeStoryResModel {
  List<HomeStoryInfo>? data;
  int? result;
  String? msg;
  String? reason;

  HomeStoryResModel({this.data, this.result, this.msg, this.reason});

  HomeStoryResModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HomeStoryInfo>[];
      json['data'].forEach((v) {
        data!.add(new HomeStoryInfo.fromJson(v));
      });
    }
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class HomeStoryInfo {
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

  HomeStoryInfo({this.id, this.category, this.categoryName, this.title, this.url, this.createdAt, this.updatedAt, this.contents, this.tags, this.viewCnt});

  HomeStoryInfo.fromJson(Map<String, dynamic> json) {
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
