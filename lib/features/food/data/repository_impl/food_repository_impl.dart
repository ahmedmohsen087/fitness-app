import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/models/food/meals_response_model.dart';
import '../../api/models/food/recommendation_food_response.dart';
import '../../api/models/food_details/meal_details_response_model.dart';
import '../../domain/entities/category_food/recommendation_food_entity.dart';
import '../../domain/entities/food/meals_entity.dart';
import '../../domain/entities/food_details/meal_details_response_entity.dart';
import '../../domain/repository_contract/food_repository_contract.dart';
import '../data_sources_contract/food_remote_data_source_contract.dart';

@Injectable(as: FoodRepositoryContract)
class FoodRepositoryImpl implements FoodRepositoryContract {
  final FoodRemoteDataSourceContract _foodRemoteDataSource;

  FoodRepositoryImpl(this._foodRemoteDataSource);

  @override
  Future<BaseResponse<RecommendationFoodEntity>> getRecommendationFood() async {
    final response = await _foodRemoteDataSource.getRecommendationFood();
    return switch (response) {
      SuccessBaseResponse<RecommendationFoodResponse>(data: final data) =>
        SuccessBaseResponse(data: data.toEntity()),
      ErrorBaseResponse<RecommendationFoodResponse>(
        errorMessage: final message,
      ) =>
        ErrorBaseResponse(errorMessage: message),
    };
  }

  @override
  Future<BaseResponse<MealsEntity>> getMealsByCategory(String category) async {
    final response = await _foodRemoteDataSource.getMealsByCategory(category);
    return switch (response) {
      SuccessBaseResponse<MealsResponseModel>(data: final data) =>
        SuccessBaseResponse(data: data.toEntity()),
      ErrorBaseResponse<MealsResponseModel>(errorMessage: final message) =>
        ErrorBaseResponse(errorMessage: message),
    };
  }

  @override
  Future<BaseResponse<MealDetailsResponseEntity>> getMealDetails(
    String mealId,
  ) async {
    final response = await _foodRemoteDataSource.getMealDetails(mealId);
    return switch (response) {
      SuccessBaseResponse<MealDetailsResponseModel>(data: final data) =>
        SuccessBaseResponse(data: data.toEntity()),
      ErrorBaseResponse<MealDetailsResponseModel>(
        errorMessage: final message,
      ) =>
        ErrorBaseResponse(errorMessage: message),
    };
  }
}
