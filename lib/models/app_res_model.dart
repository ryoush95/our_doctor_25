class AppInfoResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  AppInfoResModel({this.data, this.result, this.msg, this.reason});

  AppInfoResModel.fromJson(Map<String, dynamic> json) {
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
  int? apiVer;
  bool? review;
  AreaList? areaList;
  List<SymptomList>? symptomList;
  List<RelationInfo>? relationshipList;
  HistoryDiseaseInfo? historyDiseaseList;
  List<ReviewPoint>? setting;

  Data({this.apiVer, this.review, this.areaList, this.symptomList, this.relationshipList, this.historyDiseaseList, this.setting});

  Data.fromJson(Map<String, dynamic> json) {
    apiVer = json['api_ver'];
    review = json['review'];
    areaList = json['area_list'] != null ? new AreaList.fromJson(json['area_list']) : null;
    if (json['symptom_list'] != null) {
      symptomList = <SymptomList>[];
      json['symptom_list'].forEach((v) {
        symptomList!.add(new SymptomList.fromJson(v));
      });
    }
    if (json['relationship_list'] != null) {
      relationshipList = <RelationInfo>[];
      json['relationship_list'].forEach((v) {
        relationshipList!.add(new RelationInfo.fromJson(v));
      });
    }
    historyDiseaseList = json['history_disease_list'] != null ? new HistoryDiseaseInfo.fromJson(json['history_disease_list']) : null;
    if (json['setting'] != null) {
      setting = <ReviewPoint>[];
      json['setting'].forEach((v) {
        setting!.add(new ReviewPoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_ver'] = this.apiVer;
    data['review'] = this.review;
    if (this.areaList != null) {
      data['area_list'] = this.areaList!.toJson();
    }
    if (this.symptomList != null) {
      data['symptom_list'] = this.symptomList!.map((v) => v.toJson()).toList();
    }
    if (this.relationshipList != null) {
      data['relationship_list'] = this.relationshipList!.map((v) => v.toJson()).toList();
    }
    if (this.historyDiseaseList != null) {
      data['history_disease_list'] = this.historyDiseaseList!.toJson();
    }
    if (this.setting != null) {
      data['setting'] = this.setting!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AreaList {
  List<String>? cityList;
  List<DistrictList>? districtList;

  AreaList({this.cityList, this.districtList});

  AreaList.fromJson(Map<String, dynamic> json) {
    cityList = json['city_list'].cast<String>();
    if (json['district_list'] != null) {
      districtList = <DistrictList>[];
      json['district_list'].forEach((v) {
        districtList!.add(new DistrictList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_list'] = this.cityList;
    if (this.districtList != null) {
      data['district_list'] = this.districtList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DistrictList {
  String? city;
  List<String>? list;

  DistrictList({this.city, this.list});

  DistrictList.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    list = json['list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['list'] = this.list;
    return data;
  }
}

class SymptomList {
  String? category;
  List<String>? list;

  SymptomList({this.category, this.list});

  SymptomList.fromJson(Map<String, dynamic> json) {
    category = json['category'] ?? "";
    list = json['list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['list'] = this.list;
    return data;
  }
}

class RelationInfo {
  String? id;
  String? relationship;
  String? inputable;

  RelationInfo({this.id, this.relationship, this.inputable});

  RelationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    relationship = json['relationship'] ?? "";
    inputable = json['inputable'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['relationship'] = this.relationship;
    data['inputable'] = this.inputable;
    return data;
  }
}

class HistoryDiseaseInfo {
  List<Parent>? parent;
  List<Parent>? child;

  HistoryDiseaseInfo({this.parent, this.child});

  HistoryDiseaseInfo.fromJson(Map<String, dynamic> json) {
    if (json['parent'] != null) {
      parent = <Parent>[];
      json['parent'].forEach((v) {
        parent!.add(new Parent.fromJson(v));
      });
    }
    if (json['child'] != null) {
      child = <Parent>[];
      json['child'].forEach((v) {
        child!.add(new Parent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parent != null) {
      data['parent'] = this.parent!.map((v) => v.toJson()).toList();
    }
    if (this.child != null) {
      data['child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parent {
  String? id;
  String? name;
  String? inputable;

  Parent({this.id, this.name, this.inputable});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    inputable = json['inputable'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['inputable'] = this.inputable;
    return data;
  }
}

class ReviewPoint {
  String? id;
  String? TYPE;
  String? value;

  ReviewPoint({this.id, this.TYPE, this.value});

  ReviewPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    TYPE = json['setting_type'] ?? "";
    value = json['value'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['setting_type'] = this.TYPE;
    data['value'] = this.value;
    return data;
  }
}
