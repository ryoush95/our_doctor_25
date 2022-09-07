class HOmeSymptomGraphResModel {
  HOmeSymptomGraphDto? data;
  int? result;
  String? msg;
  String? reason;

  HOmeSymptomGraphResModel({this.data, this.result, this.msg, this.reason});

  HOmeSymptomGraphResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HOmeSymptomGraphDto.fromJson(json['data']) : null;
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

class HOmeSymptomGraphDto {
  List<SymptomList>? symptomList;
  String? symptomFirst;
  String? symptomStartDate;
  String? symptomNoDate;
  bool? isMedication;
  List<Graph>? graph;

  HOmeSymptomGraphDto({this.symptomList, this.symptomFirst, this.symptomStartDate, this.symptomNoDate, this.isMedication, this.graph});

  HOmeSymptomGraphDto.fromJson(Map<String, dynamic> json) {
    if (json['symptom_list'] != null) {
      symptomList = <SymptomList>[];
      json['symptom_list'].forEach((v) {
        symptomList!.add(new SymptomList.fromJson(v));
      });
    }
    symptomFirst = json['symptom_first'] ?? "";
    symptomStartDate = json['symptom_start_date'] ?? "";
    symptomNoDate = json['symptom_no_date'] ?? "";
    isMedication = json['is_medication'] ?? "";
    if (json['graph'] != null) {
      graph = <Graph>[];
      json['graph'].forEach((v) {
        graph!.add(new Graph.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.symptomList != null) {
      data['symptom_list'] = this.symptomList!.map((v) => v.toJson()).toList();
    }
    data['symptom_first'] = this.symptomFirst;
    data['symptom_first'] = this.symptomFirst;
    data['symptom_start_date'] = this.symptomStartDate;
    if (this.graph != null) {
      data['graph'] = this.graph!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SymptomList {
  String? id;
  String? monitoringId;
  String? category;
  String? symptom;
  String? recordTime;
  String? surgeryName;
  String? surgeryTime;
  String? medication;
  String? status;
  String? patientId;
  String? createdAt;
  String? updateAt;
  String? medicationUrl;

  SymptomList({this.id, this.monitoringId, this.category, this.symptom, this.recordTime, this.surgeryName, this.surgeryTime, this.medication, this.status, this.patientId, this.createdAt, this.updateAt, this.medicationUrl});

  SymptomList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    monitoringId = json['monitoring_id'] ?? "";
    category = json['category'] ?? "";
    symptom = json['symptom'] ?? "";
    recordTime = json['record_time'] ?? "";
    surgeryName = json['surgery_name'] ?? "";
    surgeryTime = json['surgery_time'] ?? "";
    medication = json['medication'] ?? "";
    status = json['status'] ?? "";
    patientId = json['patient_id'] ?? "";
    createdAt = json['created_at'] ?? "";
    updateAt = json['update_at'] ?? "";
    medicationUrl = json['medication_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['monitoring_id'] = this.monitoringId;
    data['category'] = this.category;
    data['symptom'] = this.symptom;
    data['record_time'] = this.recordTime;
    data['surgery_name'] = this.surgeryName;
    data['surgery_time'] = this.surgeryTime;
    data['medication'] = this.medication;
    data['status'] = this.status;
    data['patient_id'] = this.patientId;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['medication_url'] = this.medicationUrl;
    return data;
  }
}

class Graph {
  String? date;
  String? symptom;
  String? medicationUrl;
  String? symptomStatus;

  Graph({this.date, this.symptom, this.medicationUrl, this.symptomStatus});

  Graph.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    symptom = json['symptom'] ?? "";
    medicationUrl = json['medication_url'] ?? "";
    symptomStatus = json['symptom_status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['symptom'] = this.symptom;
    data['medication_url'] = this.medicationUrl;
    data['symptom_status'] = this.symptomStatus;
    return data;
  }
}
