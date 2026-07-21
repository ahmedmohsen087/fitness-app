import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/category_food/recommendation_food_entity.dart';
import 'category_food_dto.dart';
part 'recommendation_food_response.g.dart';
@JsonSerializable()
class RecommendationFoodResponse {
  @JsonKey(name: "categories")
  List<CategoryFoodDto>? categories;

  RecommendationFoodResponse({
    this.categories,
  });

  factory RecommendationFoodResponse.fromJson(Map<String, dynamic> json) => _$RecommendationFoodResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationFoodResponseToJson(this);
  RecommendationFoodEntity toEntity() {
    return RecommendationFoodEntity(
      categories: categories?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}


