import 'package:ourdoctor/helpers/bind_json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  @JsonKey(fromJson: fromJsonInt, toJson: toJsonInt)
  int category_uid;
  String category;

  CategoryDto({
    this.category_uid = 0,
    this.category = '',
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map toJson() => _$CategoryDtoToJson(this);
}

@JsonSerializable()
class CategoryListDto {
  List<CategoryDto> list;

  CategoryListDto({required this.list}) : super();

  factory CategoryListDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryListDtoFromJson(json);
}
