class Test2QuizListModel {
  List<Test2QuizDto>? data;
  int? result;
  String? msg;
  String? reason;

  Test2QuizListModel ({this.data, this.result, this.msg, this.reason});

  Test2QuizListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Test2QuizDto>[];
      json['data'].forEach((v) {
        data!.add(new Test2QuizDto.fromJson(v));
      });
    }
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      print(this.data!.map((v) => v.toJson()));
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['msg'] = this.msg;
    data['reason'] = this.reason;
    return data;
  }
}

class Test2QuizDto {
  String? id;
  String? quizId;
  String? title;
  String? quiz1;
  String? quiz2;
  String? quiz1Image;
  String? quiz2Image;
  String? type;
  String? page;
  String? result;
  String answer = "";

  Test2QuizDto({this.id, this.quizId, this.title, this.quiz1, this.quiz2, this.quiz1Image, this.quiz2Image, this.type, this.page, this.result});

  Test2QuizDto.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    quizId = json['quiz_id'] ?? "";
    title = json['title'] ?? "";
    quiz1 = json['quiz1'] ?? "";
    quiz2 = json['quiz2'] ?? "";
    quiz1Image = json['quiz1_image'] ?? "";
    quiz2Image = json['quiz2_image'] ?? "";
    type = json['main_type'] ?? "";
    page = json['page'] ?? "";
    result = json['results'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quiz_id'] = this.quizId;
    data['title'] = this.title;
    data['quiz1'] = this.quiz1;
    data['quiz2'] = this.quiz2;
    data['quiz1_image'] = this.quiz1Image;
    data['quiz2_image'] = this.quiz2Image;
    data['main_type'] = this.type;
    data['results'] = this.result;
    return data;
  }
}