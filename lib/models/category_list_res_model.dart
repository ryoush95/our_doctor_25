class CategoryListResModel {
  Data? data;
  int? result;
  String? msg;
  String? reason;

  CategoryListResModel({this.data, this.result, this.msg, this.reason});

  CategoryListResModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? categoryList;
  List<SubCategoryList>? subCategoryList;

  Data({this.categoryList, this.subCategoryList});

  Data.fromJson(Map<String, dynamic> json) {
    categoryList = json['category_list'].cast<String>();
    if (json['sub_category_list'] != null) {
      subCategoryList = <SubCategoryList>[];
      json['sub_category_list'].forEach((v) {
        subCategoryList!.add(new SubCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_list'] = this.categoryList;
    if (this.subCategoryList != null) {
      data['sub_category_list'] = this.subCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryList {
  String? category;
  List<String>? list;

  SubCategoryList({this.category, this.list});

  SubCategoryList.fromJson(Map<String, dynamic> json) {
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
