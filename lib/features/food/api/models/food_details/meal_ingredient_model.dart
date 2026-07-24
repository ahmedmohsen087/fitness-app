import '../../../domain/entities/food_details/meal_ingredient_entity.dart';

class MealIngredientModel {
  final String name;
  final String measure;

  const MealIngredientModel({required this.name, required this.measure});

  MealIngredientEntity toEntity() =>
      MealIngredientEntity(name: name, measure: measure);
}
