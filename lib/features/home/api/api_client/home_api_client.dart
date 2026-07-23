import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/api_parameters.dart';
import '../../data/models/food/meals_response_model.dart';
import '../../data/models/muscles_group/muscles_group_by_id_response.dart';
import '../../data/models/muscles_group/muscles_group_response.dart';
import '../../data/models/recommendation_food/recommendation_food_response.dart';
import '../../data/models/recommendation_to_day/recommendation_to_day_response.dart';
import '../models/food_details/meal_details_response_model.dart';

part 'home_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(ApiEndpoints.muscles)
  @Extra({ApiParameters.requiresAuth: true})
  Future<RecommendationToDayResponse> getRecommendationToDay();

  @GET(ApiEndpoints.musclesGroup)
  @Extra({ApiParameters.requiresAuth: true})
  Future<MusclesGroupResponse> getMusclesGroup();

  @GET(ApiEndpoints.musclesGroupId)
  @Extra({ApiParameters.requiresAuth: true})
  Future<MusclesGroupByIdResponse> getMusclesGroupById(@Path("id") String id);
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
