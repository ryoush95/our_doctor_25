class MbtiQuizListResModel {
  List<MbtiQuizDto>? data;
  int? result;
  String? msg;
  String? reason;

  MbtiQuizListResModel ({this.data, this.result, this.msg, this.reason});

  MbtiQuizListResModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MbtiQuizDto>[];
      json['data'].forEach((v) {
        data!.add(new MbtiQuizDto.fromJson(v));
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

class MbtiQuizDto {
  String? id;
  String? quiz;
  String? type;
  String? result;
  String answer = "";

  MbtiQuizDto({this.id, this.quiz, this.type, this.result});

  MbtiQuizDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quiz = json['quiz'];
    type = json['type'];
    result = json['results'];
    // answer = json["type"] == "4"? "1": "4";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quiz'] = this.quiz;
    data['type'] = this.type;
    data['results'] = this.result;
    return data;
  }
}