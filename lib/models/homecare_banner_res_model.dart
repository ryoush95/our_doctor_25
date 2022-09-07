class HomeCareBannerResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  HomeCareBannerResModel({this.data, this.result, this.msg, this.reason});

  HomeCareBannerResModel.fromJson(Map<String, dynamic> json) {
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
  List<HomeCareBannerDto>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <HomeCareBannerDto>[];
      json['list'].forEach((v) {
        list!.add(new HomeCareBannerDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeCareBannerDto {
  String? id;
  String? category;
  String? title;
  String? content;
  String? image;

  HomeCareBannerDto({this.id, this.category, this.title, this.content, this.image});

  HomeCareBannerDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
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
