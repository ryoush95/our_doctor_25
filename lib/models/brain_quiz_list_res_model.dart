class BrainQuizListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  BrainQuizListResModel({this.data, this.result, this.msg, this.reason});

  BrainQuizListResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    result = json['result'];
    msg = json['msg'];
    reason = json['reason'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.data != null) {
  //     data['data'] = this.data!.toJson();
  //   }
  //   data['result'] = this.result;
  //   data['msg'] = this.msg;
  //   data['reason'] = this.reason;
  //   return data;
  // }
}

class Data {
  Language? language;
  WorkOut? workOut;
  Social? social;

  Data({this.language, this.workOut, this.social});

  Data.fromJson(Map<String, dynamic> json) {
    language = json['language'] != null ? new Language.fromJson(json['language']) : null;
    workOut = json['work_out'] != null ? new WorkOut.fromJson(json['work_out']) : null;
    social = json['social'] != null ? new Social.fromJson(json['social']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.language != null) {
  //     data['language'] = this.language!.toJson();
  //   }
  //   if (this.workOut != null) {
  //     data['work_out'] = this.workOut!.toJson();
  //   }
  //   if (this.social != null) {
  //     data['social'] = this.social!.toJson();
  //   }
  //   return data;
  // }
}

class Language {
  List<String>? understand1;
  List<String>? understand2;
  List<String>? describe1;
  List<String>? describe2;

  Language({this.understand1, this.understand2, this.describe1, this.describe2});

  Language.fromJson(Map<String, dynamic> json) {
    if (json['understand'] != null) {
      understand1 = <String>[];
      understand2 = <String>[];
      var data = json['understand'];
      var data1 = data[0];
      var data2 = data[1];
      data1.forEach((v) {
        understand1!.add(v.toString());
      });
      data2.forEach((v) {
        understand2!.add(v.toString());
      });
    }
    if (json['describe'] != null) {
      describe1 = <String>[];
      describe2 = <String>[];
      var data = json['describe'];
      var data1 = data[0];
      var data2 = data[1];
      data1.forEach((v) {
        describe1!.add(v.toString());
      });
      data2.forEach((v) {
        describe2!.add(v.toString());
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.understand != null) {
  //     data['understand'] = this.understand!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.describe != null) {
  //     data['describe'] = this.describe!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class WorkOut {
  List<String>? bigMuscle1;
  List<String>? bigMuscle2;
  List<String>? smallMuscle1;
  List<String>? smallMuscle2;

  WorkOut({this.bigMuscle1, this.bigMuscle2, this.smallMuscle1, this.smallMuscle2});

  WorkOut.fromJson(Map<String, dynamic> json) {
    if (json['big_muscle'] != null) {
      bigMuscle1 = <String>[];
      bigMuscle2 = <String>[];
      var data = json['big_muscle'];
      var data1 = data[0];
      var data2 = data[1];
      data1.forEach((v) {
        bigMuscle1!.add(v.toString());
      });
      data2.forEach((v) {
        bigMuscle2!.add(v.toString());
      });
    }
    if (json['small_muscle'] != null) {
      smallMuscle1 = <String>[];
      smallMuscle2 = <String>[];
      var data = json['small_muscle'];
      var data1 = data[0];
      var data2 = data[1];
      data1.forEach((v) {
        smallMuscle1!.add(v.toString());
      });
      data2.forEach((v) {
        smallMuscle2!.add(v.toString());
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.bigMuscle != null) {
  //     data['big_muscle'] = this.bigMuscle!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.smallMuscle != null) {
  //     data['small_muscle'] = this.smallMuscle!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class Social {
  List<String>? action1;
  List<String>? action2;

  Social({this.action1, this.action2});

  Social.fromJson(Map<String, dynamic> json) {
    if (json['action'] != null) {
      action1 = <String>[];
      action2 = <String>[];
      var data = json['action'];
      var data1 = data[0];
      var data2 = data[1];
      data1.forEach((v) {
        action1!.add(v.toString());
      });
      data2.forEach((v) {
        action2!.add(v.toString());
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.action != null) {
  //     data['action'] = this.action!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}
