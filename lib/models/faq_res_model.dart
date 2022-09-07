class FaqResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  FaqResModel({this.data, this.result, this.msg, this.reason});

  FaqResModel.fromJson(Map<String, dynamic> json) {
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
  List<FaqListDto>? list;

  Data({this.totalCount, this.totalPage, this.isLast, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    totalPage = json['total_page'];
    isLast = json['is_last'];
    if (json['list'] != null) {
      list = <FaqListDto>[];
      json['list'].forEach((v) {
        list!.add(new FaqListDto.fromJson(v));
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

class FaqListDto {
  String? id;
  String? category;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;
  String? viewCnt;

  FaqListDto({this.id, this.category, this.question, this.answer, this.createdAt, this.updatedAt, this.viewCnt});

  FaqListDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    category = json['category'] ?? "";
    question = json['question'] ?? "";
    answer = json['answer'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    viewCnt = json['view_cnt'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['view_cnt'] = this.viewCnt;
    return data;
  }
}
