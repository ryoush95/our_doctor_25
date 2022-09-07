class ChatQuizListResModel2 {
  List<QuizDto2>? data;
  int? result;
  String? msg;
  String? reason;

  ChatQuizListResModel2 ({this.data, this.result, this.msg, this.reason});

  ChatQuizListResModel2.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <QuizDto2>[];
      json['data'].forEach((v) {
        data!.add(new QuizDto2.fromJson(v));
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

class QuizDto2 {
  String? id;
  String? quiz;
  String? type;
  int answer = 0;

  QuizDto2({this.id, this.quiz, this.type});

  QuizDto2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quiz = json['quiz'];
    type = json['give_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quiz'] = this.quiz;
    data['main_type'] = this.type;
    return data;
  }
}