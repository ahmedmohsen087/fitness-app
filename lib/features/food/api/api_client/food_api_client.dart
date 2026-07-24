import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/api_parameters.dart';
import '../models/food/meals_response_model.dart';
import '../models/food/recommendation_food_response.dart';
import '../models/food_details/meal_details_response_model.dart';

part 'food_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class FoodApiClient {
  @factoryMethod
  factory FoodApiClient(Dio dio) = _FoodApiClient;

  @GET(ApiEndpoints.recommendationFood)
  @Extra({ApiParameters.requiresAuth: false})
  Future<RecommendationFoodResponse> getRecommendationFood();

  @GET(ApiEndpoints.mealsByCategory)
  @Extra({ApiParameters.requiresAuth: false})
  Future<MealsResponseModel> getMealsByCategory(
    @Query(ApiParameters.category) String category,
  );

  @GET(ApiEndpoints.mealDetails)
  @Extra({ApiParameters.requiresAuth: false})
  Future<MealDetailsResponseModel> getMealDetails(
    @Query(ApiParameters.mealId) String mealId,
  );
}
