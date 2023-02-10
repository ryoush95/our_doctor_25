class CommentListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  CommentListResModel({this.data, this.result, this.msg, this.reason});

  CommentListResModel.fromJson(Map<String, dynamic> json) {
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
  List<ReplyDto>? contents;

  Data({this.totalCount, this.totalPage, this.isLast, this.contents});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['contents'] != null) {
      contents = <ReplyDto>[];
      json['contents'].forEach((v) {
        contents!.add(new ReplyDto.fromJson(v));
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

class ReplyDto {
  String? name;
  String? nickname;
  String? userType;
  String? id;
  String? content;
  String? commentUid;
  String? regTime;
  String? likeCnt;
  String? likeYn;
  String? delYn;
  String? secret;
  List<ReplyReplyDto>? replyList;

  ReplyDto({
    this.name, 
    this.nickname, 
    this.userType, 
    this.id, 
    this.content, 
    this.commentUid, 
    this.regTime, 
    this.likeCnt, 
    this.likeYn, 
    this.delYn,
    this.secret,
    this.replyList,
  });

  ReplyDto.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    userType = json['user_type'] ?? "";
    nickname = json['nickname'] ?? "";
    id = json['id'] ?? "";
    content = json['content'] ?? "";
    commentUid = json['comment_uid'] ?? "";
    regTime = json['reg_time'] ?? "";
    likeCnt = json['like_cnt'] ?? "";
    likeYn = json['like_yn'] ?? "";
    delYn = json['del_yn'] ?? "";
    secret = json['secret'] ?? "";
    if (json['reply_list'] != null) {
      replyList = <ReplyReplyDto>[];
      json['reply_list'].forEach((v) {
        replyList!.add(new ReplyReplyDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user_type'] = this.userType;
    data['nickname'] = this.nickname;
    data['id'] = this.id;
    data['content'] = this.content;
    data['comment_uid'] = this.commentUid;
    data['reg_time'] = this.regTime;
    data['like_cnt'] = this.likeCnt;
    data['like_yn'] = this.likeYn;
    data['del_yn'] = this.delYn;
    data['secret'] = this.secret;
    if (this.replyList != null) {
      data['reply_list'] = this.replyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReplyReplyDto {
  String? name;
  String? nickname;
  String? userType;
  String? id;
  String? content;
  String? commentUid;
  String? regTime;
  String? likeCnt;
  String? likeYn;
  String? delYn;
  String? secret;

  ReplyReplyDto(
      {this.name,
      this.nickname,
      this.userType,
      this.id,
      this.content,
      this.commentUid,
      this.regTime,
      this.likeCnt,
      this.likeYn,
      this.delYn,
        this.secret,
      });

  ReplyReplyDto.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    nickname = json['nickname'] ?? "";
    userType = json['user_type'] ?? "";
    id = json['id'] ?? "";
    content = json['content'] ?? "";
    commentUid = json['comment_uid'] ?? "";
    regTime = json['reg_time'] ?? "";
    likeCnt = json['like_cnt'] ?? "";
    likeYn = json['like_yn'] ?? "";
    delYn = json['del_yn'] ?? "";
    secret = json['secret'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['user_type'] = this.userType;
    data['id'] = this.id;
    data['content'] = this.content;
    data['comment_uid'] = this.commentUid;
    data['reg_time'] = this.regTime;
    data['like_cnt'] = this.likeCnt;
    data['like_yn'] = this.likeYn;
    data['del_yn'] = this.delYn;
    data['secret'] = this.secret;
    return data;
  }
}
