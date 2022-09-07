class CommunityDetailResModel {
  CommunityDetailDto? data;
  int? result;
  String? msg;
  String? reason;

  CommunityDetailResModel({this.data, this.result, this.msg, this.reason});

  CommunityDetailResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CommunityDetailDto.fromJson(json['data']) : null;
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

class CommunityDetailDto {
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
  String? secret;
  String? admin;
  String? slideImages;
  String? imgUrls;
  String? tags;
  String? age;
  String? name;
  String? nickname;
  String? commentCnt;
  String? likeCnt;
  String? likeYn;
  String? blogUrl;

  CommunityDetailDto(
      {this.uid,
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
      this.secret,
      this.admin,
      this.slideImages,
      this.imgUrls,
      this.tags,
      this.age,
      this.name,
      this.nickname,
      this.commentCnt,
      this.likeCnt,
      this.likeYn,
      this.blogUrl,
    });

  CommunityDetailDto.fromJson(Map<String, dynamic> json) {
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
    secret = json['secret'] ?? "";
    admin = json['admin'] ?? "";
    slideImages = json['slide_images'] ?? "";
    imgUrls = json['img_urls'] ?? "";
    tags = json['tags'] ?? "";
    age = json['age'] ?? "";
    name = json['name'] ?? "";
    nickname = json['nickname'] ?? "";
    commentCnt = json['comment_cnt'] ?? "";
    likeCnt = json['like_cnt'] ?? "";
    likeYn = json['like_yn'] ?? "";
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
    data['secret'] = this.secret;
    data['admin'] = this.admin;
    data['slide_images'] = this.slideImages;
    data['img_urls'] = this.imgUrls;
    data['tags'] = this.tags;
    data['age'] = this.age;
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['comment_cnt'] = this.commentCnt;
    data['like_cnt'] = this.likeCnt;
    data['blog_url'] = this.blogUrl;
    return data;
  }
}
