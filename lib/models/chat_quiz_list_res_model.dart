class ChatQuizListResModel {
  List<QuizDto>? data;
  int? result;
  String? msg;
  String? reason;

  ChatQuizListResModel ({this.data, this.result, this.msg, this.reason});

  ChatQuizListResModel .fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <QuizDto>[];
      json['data'].forEach((v) {
        data!.add(new QuizDto.fromJson(v));
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

class QuizDto {
  String? id;
  String? quiz;
  List<String>? addtionalQuizs;
  String? giveFlag;
  int answer = 0;

  QuizDto({this.id, this.quiz, this.addtionalQuizs, this.giveFlag});

  QuizDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quiz = json['quiz'];
    addtionalQuizs = json['addtional_quizs'].cast<String>();
    giveFlag = json['give_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quiz'] = this.quiz;
    data['addtional_quizs'] = this.addtionalQuizs;
    data['give_flag'] = this.giveFlag;
    return data;
  }
}