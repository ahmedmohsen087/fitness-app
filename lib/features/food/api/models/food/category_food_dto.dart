import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/category_food/category_food_entity.dart';

part 'category_food_dto.g.dart';

@JsonSerializable()
class CategoryFoodDto {
  @JsonKey(name: "idCategory")
  String? idCategory;
  @JsonKey(name: "strCategory")
  String? strCategory;
  @JsonKey(name: "strCategoryThumb")
  String? strCategoryThumb;
  @JsonKey(name: "strCategoryDescription")
  String? strCategoryDescription;

  CategoryFoodDto({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  factory CategoryFoodDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryFoodDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryFoodDtoToJson(this);

  CategoryFoodEntity toEntity() {
    return CategoryFoodEntity(
      idCategory: idCategory ?? '',
      strCategory: strCategory ?? '',
      strCategoryThumb: strCategoryThumb ?? '',
      strCategoryDescription: strCategoryDescription ?? '',
    );
  }
}
