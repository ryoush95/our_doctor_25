class ChildQuizListResModel {
  List<ChildQuizDto>? data;
  int? result;
  String? msg;
  String? reason;

  ChildQuizListResModel ({this.data, this.result, this.msg, this.reason});

  ChildQuizListResModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ChildQuizDto>[];
      json['data'].forEach((v) {
        data!.add(new ChildQuizDto.fromJson(v));
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

class ChildQuizDto {
  String? id;
  String? quiz;
  String? age;
  String? type;
  String? page;
  String? result;
  int answer = 0;

  ChildQuizDto({this.id, this.quiz, this.age, this.type, this.page, this.result});

  ChildQuizDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quiz = json['quiz'];
    age = json['age'];
    type = json['main_type'];
    page = json['page'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quiz'] = this.quiz;
    data['main_type'] = this.type;
    data['age_type'] = this.age;
    data['result'] = this.result;
    return data;
  }
}