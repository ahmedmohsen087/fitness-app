import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/food/meals_entity.dart';
import 'meal_model.dart';

part 'meals_response_model.g.dart';

@JsonSerializable(createToJson: false)
class MealsResponseModel {
  final List<MealModel>? meals;

  const MealsResponseModel({this.meals});

  factory MealsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MealsResponseModelFromJson(json);

  MealsEntity toEntity() => MealsEntity(
    meals: meals?.map((meal) => meal.toEntity()).toList() ?? const [],
  );
}
