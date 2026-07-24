import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/food/meal_entity.dart';

part 'meal_model.g.dart';

@JsonSerializable(createToJson: false)
class MealModel {
  @JsonKey(name: 'idMeal')
  final String? id;
  @JsonKey(name: 'strMeal')
  final String? name;
  @JsonKey(name: 'strMealThumb')
  final String? thumbnail;
  @JsonKey(name: 'strArea')
  final String? area;
  @JsonKey(name: 'strCountry')
  final String? country;

  const MealModel({
    this.id,
    this.name,
    this.thumbnail,
    this.area,
    this.country,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);

  MealEntity toEntity() => MealEntity(
    id: id ?? '',
    name: name ?? '',
    thumbnail: thumbnail ?? '',
    area: area,
    country: country,
  );
}
