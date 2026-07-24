import '../../../../config/base_response/base_response.dart';
import '../../api/models/food/meals_response_model.dart';
import '../../api/models/food/recommendation_food_response.dart';
import '../../api/models/food_details/meal_details_response_model.dart';

abstract interface class FoodRemoteDataSourceContract {
  Future<BaseResponse<RecommendationFoodResponse>> getRecommendationFood();

  Future<BaseResponse<MealsResponseModel>> getMealsByCategory(String category);

  Future<BaseResponse<MealDetailsResponseModel>> getMealDetails(String mealId);
}
