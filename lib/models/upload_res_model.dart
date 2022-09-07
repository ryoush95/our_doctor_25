class FileUploadResModel {
  FileUploadDto? data;
  int? result;
  String? msg;
  String? reason;

  FileUploadResModel({this.data, this.result, this.msg, this.reason});

  FileUploadResModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new FileUploadDto.fromJson(json['data']) : null;
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

class FileUploadDto {
  String? fileName;
  String? fileUrl;

  FileUploadDto({this.fileName, this.fileUrl});

  FileUploadDto.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'] ?? "";
    fileUrl = json['file_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['file_url'] = this.fileUrl;
    return data;
  }
}
