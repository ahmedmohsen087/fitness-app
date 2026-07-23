import '../../../domain/entities/food_details/meal_details_response_entity.dart';
import 'meal_details_model.dart';

class MealDetailsResponseModel {
  final List<MealDetailsModel>? meals;

  const MealDetailsResponseModel({this.meals});

  factory MealDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as List<dynamic>?;
    return MealDetailsResponseModel(
      meals: mealsJson
          ?.whereType<Map<String, dynamic>>()
          .map(MealDetailsModel.fromJson)
          .toList(),
    );
  }

  MealDetailsResponseEntity toEntity() => MealDetailsResponseEntity(
    meals: meals?.map((meal) => meal.toEntity()).toList() ?? const [],
  );
}
