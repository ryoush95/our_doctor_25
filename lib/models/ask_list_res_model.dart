class AskListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  AskListResModel({this.data, this.result, this.msg, this.reason});

  AskListResModel.fromJson(Map<String, dynamic> json) {
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
  List<AskDto>? contents;

  Data({this.totalCount, this.totalPage, this.isLast, this.contents});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['contents'] != null) {
      contents = <AskDto>[];
      json['contents'].forEach((v) {
        contents!.add(new AskDto.fromJson(v));
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

class AskDto {
  String? uid;
  String? regTime;
  String? title;
  String? content;
  String? status;
  String? userUid;
  String? answer;
  String? imgUrl;
  String? answerTime;

  AskDto({this.uid, this.regTime, this.title, this.content, this.status, this.userUid, this.answer, this.imgUrl, this.answerTime});

  AskDto.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? "";
    regTime = json['reg_time'] ?? "";
    title = json['title'] ?? "";
    content = json['content'] ?? "";
    status = json['status'] ?? "";
    userUid = json['user_uid'] ?? "";
    answer = json['answer'] ?? "";
    imgUrl = json['img_url'] ?? "";
    answerTime = json['answer_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['reg_time'] = this.regTime;
    data['title'] = this.title;
    data['content'] = this.content;
    data['status'] = this.status;
    data['user_uid'] = this.userUid;
    data['answer'] = this.answer;
    data['img_url'] = this.imgUrl;
    data['answer_time'] = this.answerTime;
    return data;
  }
}
