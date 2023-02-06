import 'package:ourdoctor/helpers/bind_json.dart';

import 'monitoring/heath_result_model.dart';

class HomeGraphTallResModel {
  HomeGraphTallDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeGraphTallResModel({this.data, this.result, this.msg, this.reason});

  HomeGraphTallResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeGraphTallDto.fromJson(json['data']) : null;
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

class HomeGraphTallDto {
  int? total_cnt;
  double? height;
  double? diff;
  double? heightPrevDiff;
  double? heightPredict;
  Monitoring? monitoring;
  List<Graph>? graph;
  Map<String, RecommendList>? solutionList;

  HomeGraphTallDto({this.total_cnt, this.height, this.diff, this.heightPrevDiff, this.heightPredict, this.monitoring, this.graph,    this.solutionList,});

  HomeGraphTallDto.fromJson(Map<String, dynamic> json) {
    total_cnt = fromJsonInt(json['total_cnt']);
    if (json['height'] == null) {
      height = 0;
    } else {
      height = fromJsonDouble(json['height']);
    }
    if (json['height_prev_diff'] == null) {
      heightPrevDiff = 0;
    } else {
      heightPrevDiff = fromJsonDouble(json['height_prev_diff']);
    }
    if (json['diff'] == null) {
      diff = 0;
    } else {
      diff = fromJsonDouble(json['diff']);
    }
    if (json['height_predict'] == null) {
      heightPredict = 0;
    } else {
      heightPredict = fromJsonDouble(json['height_predict']);
    }
    monitoring = json['monitoring'] != null ? new Monitoring.fromJson(json['monitoring']) : null;
    if (json['graph'] != null) {
      graph = <Graph>[];
      json['graph'].forEach((v) {
        graph!.add(new Graph.fromJson(v));
      });
    }
    solutionList = Map.from(json["recommend_list"]!).map((k, v) => MapEntry<String, RecommendList>(k, RecommendList.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_cnt'] = this.total_cnt;
    data['height'] = this.height;
    data['diff'] = this.diff;
    data['height_prev_diff'] = this.heightPrevDiff;
    data['height_predict'] = this.heightPredict;
    if (this.monitoring != null) {
      data['monitoring'] = this.monitoring!.toJson();
    }
    if (this.graph != null) {
      data['graph'] = this.graph!.map((v) => v.toJson()).toList();
    }
    data['recommend_list'] = Map.from(solutionList!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson()));
    return data;
  }
}

class Monitoring {
  double? value;
  int? percent;
  double? diff;
  String? inputTime;
  Diagnose? diagnose;

  Monitoring({this.value, this.percent, this.diff, this.inputTime, this.diagnose});

  Monitoring.fromJson(Map<String, dynamic> json) {
    if (json['value'] == null) {
      value = 0;
    } else {
      value = ((json['value'] as num)).toDouble();
    }
    percent = json['percent'] ?? 0;
    if (json['diff'] == null) {
      diff = 0;
    } else {
      diff = fromJsonDouble(json['diff']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    return data;
  }
}

class Diagnose {
  String? id;
  String? diagnosis;
  String? result;
  String? color;
  String? comment;
  String? reserve1;
  String? min;
  String? max;
  String? minAge;
  String? maxAge;
  String? value;
  String? gender;
  String? enough;

  Diagnose({this.id, this.diagnosis, this.result, this.color, this.comment, this.reserve1, this.min, this.max, this.minAge, this.maxAge, this.value, this.gender, this.enough});

  Diagnose.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    diagnosis = json['diagnosis'] ?? "";
    result = json['result'] ?? "";
    color = json['color'] ?? "";
    comment = json['comment'] ?? "";
    reserve1 = json['reserve1'] ?? "";
    min = json['min'] ?? "";
    max = json['max'] ?? "";
    minAge = json['min_age'] ?? "";
    maxAge = json['max_age'] ?? "";
    value = json['value'] ?? "";
    gender = json['gender'] ?? "";
    enough = json['enough'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['diagnosis'] = this.diagnosis;
    data['result'] = this.result;
    data['color'] = this.color;
    data['comment'] = this.comment;
    data['reserve1'] = this.reserve1;
    data['min'] = this.min;
    data['max'] = this.max;
    data['min_age'] = this.minAge;
    data['max_age'] = this.maxAge;
    data['value'] = this.value;
    data['gender'] = this.gender;
    data['enough'] = this.enough;
    return data;
  }
}

class Graph {
  String? date;
  String? child;
  String? country;
  String? expect;

  Graph({this.date, this.child, this.country, this.expect});

  Graph.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    child = fromJsonString(json['child']);
    country = json['country'] ?? "";
    expect = json['expect'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['child'] = this.child;
    data['country'] = this.country;
    data['expect'] = this.expect;
    return data;
  }
}

class HomeGraphWeightResModel {
  HomeGraphWeightDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeGraphWeightResModel({this.data, this.result, this.msg, this.reason});

  HomeGraphWeightResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeGraphWeightDto.fromJson(json['data']) : null;
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

class HomeGraphWeightDto {
  int? total_cnt;
  double? weight;
  double? weightPrevDiff;
  Monitoring? monitoring;
  List<Graph>? graph;
  Map<String, RecommendList>? solutionList;

  HomeGraphWeightDto({this.total_cnt,
    this.weight,
    this.weightPrevDiff,
    this.monitoring,
    this.graph,
    this.solutionList,
  });

  HomeGraphWeightDto.fromJson(Map<String, dynamic> json) {
    total_cnt = fromJsonInt(json['total_cnt']);
    weight = fromJsonDouble(json['weight']);
    weightPrevDiff = fromJsonDouble(json['weight_prev_diff']);
    monitoring = json['monitoring'] != null ? new Monitoring.fromJson(json['monitoring']) : null;
    if (json['graph'] != null) {
      graph = <Graph>[];
      json['graph'].forEach((v) {
        graph!.add(new Graph.fromJson(v));
      });
    }
    solutionList = Map.from(json["recommend_list"]!).map((k, v) => MapEntry<String, RecommendList>(k, RecommendList.fromJson(v)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_cnt'] = this.total_cnt;
    data['weight'] = this.weight;
    data['weight_prev_diff'] = this.weightPrevDiff;
    if (this.monitoring != null) {
      data['monitoring'] = this.monitoring!.toJson();
    }
    if (this.graph != null) {
      data['graph'] = this.graph!.map((v) => v.toJson()).toList();
    }
    data['recommend_list'] = Map.from(solutionList!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson()));
    return data;
  }
}

class HomeGraphLifeStyleResModel {
  HomeGraphLifeStyleDto? data;
  int? result;
  String? msg;
  String? reason;

  HomeGraphLifeStyleResModel({this.data, this.result, this.msg, this.reason});

  HomeGraphLifeStyleResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeGraphLifeStyleDto.fromJson(json['data']) : null;
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

class HomeGraphLifeStyleDto {
  double? yesterdayKcal;
  double? avgKcal;
  MonitoringFood? monitoringFood;
  MonitoringSleep? monitoringSleep;
  List<GraphFood>? graphFood;
  double? yesterdaySleepNight;
  double? avgSleepNight;
  double? yesterdaySleepLaunch;
  double? avgSleepLaunch;
  List<GraphSleep>? graphSleep;

  HomeGraphLifeStyleDto({this.yesterdayKcal, this.avgKcal, this.monitoringFood, this.graphFood, this.yesterdaySleepNight, this.avgSleepNight, this.yesterdaySleepLaunch, this.avgSleepLaunch, this.graphSleep});

  HomeGraphLifeStyleDto.fromJson(Map<String, dynamic> json) {
    if (json['yesterday_kcal'] == null) {
      yesterdayKcal = 0;
    } else {
      yesterdayKcal = fromJsonDouble(json['yesterday_kcal']);
    }
    if (json['avg_kcal'] == null) {
      avgKcal = 0;
    } else {
      avgKcal = fromJsonDouble(json['avg_kcal']);
    }
    monitoringFood = json['monitoring_food'] != null ? new MonitoringFood.fromJson(json['monitoring_food']) : null;
    monitoringSleep = json['monitoring_sleep'] != null ? new MonitoringSleep.fromJson(json['monitoring_sleep']) : null;
    
    if (json['graph_food'] != null) {
      graphFood = <GraphFood>[];
      json['graph_food'].forEach((v) {
        graphFood!.add(new GraphFood.fromJson(v));
      });
    }
    
    if (json['yesterday_sleep_night'] == null) {
      yesterdaySleepNight = 0;
    } else {
      yesterdaySleepNight = fromJsonDouble(json['yesterday_sleep_night']);
    }

    if (json['avg_sleep_night'] == null) {
      avgSleepNight = 0;
    } else {
      avgSleepNight = fromJsonDouble(json['avg_sleep_night']);
    }
    if (json['yesterday_sleep_launch'] == null) {
      yesterdaySleepLaunch = 0;
    } else {
      yesterdaySleepLaunch = fromJsonDouble(json['yesterday_sleep_launch']);
    }

    if (json['avg_sleep_launch'] == null) {
      avgSleepLaunch = 0;
    } else {
      avgSleepLaunch = fromJsonDouble(json['avg_sleep_launch']);
    }

    if (json['graph_sleep'] != null) {
      graphSleep = <GraphSleep>[];
      json['graph_sleep'].forEach((v) {
        graphSleep!.add(new GraphSleep.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yesterday_kcal'] = this.yesterdayKcal;
    data['avg_kcal'] = this.avgKcal;
    if (this.monitoringFood != null) {
      data['monitoring_food'] = this.monitoringFood!.toJson();
    }
    if (this.monitoringSleep != null) {
      data['monitoring_sleep'] = this.monitoringSleep!.toJson();
    }
    if (this.graphFood != null) {
      data['graph_food'] = this.graphFood!.map((v) => v.toJson()).toList();
    }
    data['yesterday_sleep_night'] = this.yesterdaySleepNight;
    data['avg_sleep_night'] = this.avgSleepNight;
    data['yesterday_sleep_launch'] = this.yesterdaySleepLaunch;
    data['avg_sleep_launch'] = this.avgSleepLaunch;
    if (this.graphSleep != null) {
      data['graph_sleep'] = this.graphSleep!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MonitoringFood {
  String? value;
  double? percent;
  String? inputTime;
  Diagnose? diagnose;
  MonitoringFoodData? data;

  MonitoringFood({this.value, this.percent, this.inputTime, this.diagnose, this.data});

  MonitoringFood.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    if (json['percent'] == null) {
      percent = 0;
    } else {
      percent = fromJsonDouble(json['percent']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    data = json['data'] != null ? new MonitoringFoodData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MonitoringFoodData {
  String? id;
  String? patientId;
  String? height;
  String? weight;
  String? sleepAtNight;
  String? sleepAtLunch;
  String? language;
  String? languageJson;
  String? sociability;
  String? sociabilityJson;
  String? workOut;
  String? workOutJson;
  String? regDate;
  String? breakfastKcal;
  String? launchKcal;
  String? snackKcal;
  String? dinnerKcal;
  String? foodInputTime;
  String? languageInputTime;
  String? sociabilityInputTime;
  String? workoutInputTime;
  String? heightInputTime;
  String? weightInputTime;
  String? sleepInputTime;
  String? createdAt;
  String? updatedAt;
  String? monitoringTime;
  String? status;

  MonitoringFoodData(
      {this.id,
      this.patientId,
      this.height,
      this.weight,
      this.sleepAtNight,
      this.sleepAtLunch,
      this.language,
      this.languageJson,
      this.sociability,
      this.sociabilityJson,
      this.workOut,
      this.workOutJson,
      this.regDate,
      this.breakfastKcal,
      this.launchKcal,
      this.snackKcal,
      this.dinnerKcal,
      this.foodInputTime,
      this.languageInputTime,
      this.sociabilityInputTime,
      this.workoutInputTime,
      this.heightInputTime,
      this.weightInputTime,
      this.sleepInputTime,
      this.createdAt,
      this.updatedAt,
      this.monitoringTime,
      this.status});

  MonitoringFoodData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    patientId = json['patient_id'] ?? "";
    height = json['height'] ?? "";
    weight = json['weight'] ?? "";
    sleepAtNight = json['sleep_at_night'] ?? "";
    sleepAtLunch = json['sleep_at_lunch'] ?? "";
    language = json['language'] ?? "";
    languageJson = json['language_json'] ?? "";
    sociability = json['sociability'] ?? "";
    sociabilityJson = json['sociability_json'] ?? "";
    workOut = json['work_out'] ?? "";
    workOutJson = json['work_out_json'] ?? "";
    regDate = json['reg_date'] ?? "";
    breakfastKcal = json['breakfast_kcal'] ?? "";
    launchKcal = json['launch_kcal'] ?? "";
    snackKcal = json['snack_kcal'] ?? "";
    dinnerKcal = json['dinner_kcal'] ?? "";
    foodInputTime = json['food_input_time'] ?? "";
    languageInputTime = json['language_input_time'] ?? "";
    sociabilityInputTime = json['sociability_input_time'] ?? "";
    workoutInputTime = json['workout_input_time'] ?? "";
    heightInputTime = json['height_input_time'] ?? "";
    weightInputTime = json['weight_input_time'] ?? "";
    sleepInputTime = json['sleep_input_time'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    monitoringTime = json['monitoring_time'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['sleep_at_night'] = this.sleepAtNight;
    data['sleep_at_lunch'] = this.sleepAtLunch;
    data['language'] = this.language;
    data['language_json'] = this.languageJson;
    data['sociability'] = this.sociability;
    data['sociability_json'] = this.sociabilityJson;
    data['work_out'] = this.workOut;
    data['work_out_json'] = this.workOutJson;
    data['reg_date'] = this.regDate;
    data['breakfast_kcal'] = this.breakfastKcal;
    data['launch_kcal'] = this.launchKcal;
    data['snack_kcal'] = this.snackKcal;
    data['dinner_kcal'] = this.dinnerKcal;
    data['food_input_time'] = this.foodInputTime;
    data['language_input_time'] = this.languageInputTime;
    data['sociability_input_time'] = this.sociabilityInputTime;
    data['workout_input_time'] = this.workoutInputTime;
    data['height_input_time'] = this.heightInputTime;
    data['weight_input_time'] = this.weightInputTime;
    data['sleep_input_time'] = this.sleepInputTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['monitoring_time'] = this.monitoringTime;
    data['status'] = this.status;
    return data;
  }
}

class GraphFood {
  String? date;
  double? kcal;

  GraphFood({this.date, this.kcal});

  GraphFood.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    if (json['kcal'] == null) {
      kcal = 0;
    } else {
      kcal = fromJsonDouble(json['kcal']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['kcal'] = this.kcal;
    return data;
  }
}

class GraphSleep {
  String? date;
  int? sleepNight;
  int? sleepLaunch;

  GraphSleep({this.date, this.sleepNight, this.sleepLaunch});

  GraphSleep.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    sleepNight = fromJsonInt(json['sleep_night']);
    sleepLaunch = fromJsonInt(json['sleep_launch']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['sleep_night'] = this.sleepNight;
    data['sleep_launch'] = this.sleepLaunch;
    return data;
  }
}

class MonitoringSleep {
  String? value;
  double? percent;
  String? inputTime;
  Diagnose? diagnose;
  double? difference;

  MonitoringSleep({
    this.value, 
    this.percent, 
    this.inputTime, 
    this.diagnose, 
    this.difference
  });

  MonitoringSleep.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? "";
    if (json['percent'] == null) {
      percent = 0;
    } else {
      percent = fromJsonDouble(json['percent']);
    }
    inputTime = json['input_time'] ?? "";
    diagnose = json['diagnose'] != null ? new Diagnose.fromJson(json['diagnose']) : null;
    if (json['difference'] == null) {
      difference = 0;
    } else {
      difference = fromJsonDouble(json['difference']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['input_time'] = this.inputTime;
    if (this.diagnose != null) {
      data['diagnose'] = this.diagnose!.toJson();
    }
    data['difference'] = this.difference;
    return data;
  }
}