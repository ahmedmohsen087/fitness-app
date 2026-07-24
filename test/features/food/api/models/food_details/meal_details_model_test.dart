import 'package:fitness_app/features/food/api/models/food_details/meal_details_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps populated ingredient pairs and ignores blank ingredients', () {
    final model = MealDetailsResponseModel.fromJson({
      'meals': [
        {
          'idMeal': '52959',
          'strMeal': 'Baked salmon',
          'strCategory': 'Seafood',
          'strTags': 'Paleo, Keto',
          'strIngredient1': 'Fennel',
          'strMeasure1': '2 medium',
          'strIngredient2': '',
          'strMeasure2': 'unused',
          'strIngredient3': 'Lemon',
          'strMeasure3': 'Juice of 1',
        },
      ],
    });

    final entity = model.toEntity().meals.single;
    expect(entity.id, '52959');
    expect(entity.tags, ['Paleo', 'Keto']);
    expect(entity.ingredients.length, 2);
    expect(entity.ingredients.first.name, 'Fennel');
    expect(entity.ingredients.first.measure, '2 medium');
    expect(entity.ingredients.last.name, 'Lemon');
  });
}
