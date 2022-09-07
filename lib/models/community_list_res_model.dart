class CommunityListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  CommunityListResModel({this.data, this.result, this.msg, this.reason});

  CommunityListResModel.fromJson(Map<String, dynamic> json) {
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
  List<CommunityDto>? contents;

  Data({this.totalCount, this.totalPage, this.isLast, this.contents});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['contents'] != null) {
      contents = <CommunityDto>[];
      json['contents'].forEach((v) {
        contents!.add(new CommunityDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['total_page'] = this.totalPage;
    data['is_last'] = this.isLast;
    if (this.contents != null) {
      data['contents'] = this.contents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunityDto {
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
  String? name;
  String? nickname;
  String? commentCnt;
  String? likeCnt;
  String? likeYn;
  String? secret;
  String? admin;
  String? imgUrls;
  String? blogUrl;

  CommunityDto({
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
    this.name, 
    this.nickname, 
    this.commentCnt, 
    this.likeCnt, 
    this.likeYn, 
    this.secret, 
    this.admin, 
    this.imgUrls,
    this.blogUrl,
  });

  CommunityDto.fromJson(Map<String, dynamic> json) {
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
    name = json['name'] ?? "";
    nickname = json['nickname'] ?? "";
    commentCnt = json['comment_cnt'] ?? "";
    likeCnt = json['like_cnt'] ?? "";
    likeYn = json['like_yn'] ?? "";
    secret = json['secret'] ?? "0";
    admin = json['admin'] ?? "0";
    imgUrls = json['img_urls'] ?? "";
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
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['comment_cnt'] = this.commentCnt;
    data['like_cnt'] = this.likeCnt;
    data['like_yn'] = this.likeYn;
    data['secret'] = this.secret;
    data['admin'] = this.admin;
    data['blog_url'] = this.blogUrl;
    return data;
  }
}
