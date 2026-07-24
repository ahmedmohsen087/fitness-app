import '../../../../config/base_response/base_response.dart';
import '../entities/category_food/recommendation_food_entity.dart';
import '../entities/food/meals_entity.dart';
import '../entities/food_details/meal_details_response_entity.dart';

abstract interface class FoodRepositoryContract {
  Future<BaseResponse<RecommendationFoodEntity>> getRecommendationFood();

  Future<BaseResponse<MealsEntity>> getMealsByCategory(String category);

  Future<BaseResponse<MealDetailsResponseEntity>> getMealDetails(String mealId);
}
