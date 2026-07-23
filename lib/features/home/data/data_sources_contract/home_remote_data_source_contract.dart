import '../../../../config/base_response/base_response.dart';
import '../../api/models/food_details/meal_details_response_model.dart';
import '../models/food/meals_response_model.dart';
import '../models/muscles_group/muscles_group_by_id_response.dart';
import '../models/muscles_group/muscles_group_response.dart';
import '../models/recommendation_food/recommendation_food_response.dart';
import '../models/recommendation_to_day/recommendation_to_day_response.dart';

abstract interface class HomeRemoteDataSourceContract {
  Future<BaseResponse<RecommendationToDayResponse>> getRecommendationToDay();
  Future<BaseResponse<MusclesGroupResponse>> getMusclesGroup();
  Future<BaseResponse<MusclesGroupByIdResponse>> getMusclesGroupId(String id);
  Future<BaseResponse<RecommendationFoodResponse>> getRecommendationFood();

  Future<BaseResponse<MealsResponseModel>> getMealsByCategory(String category);

  Future<BaseResponse<MealDetailsResponseModel>> getMealDetails(String mealId);
}
