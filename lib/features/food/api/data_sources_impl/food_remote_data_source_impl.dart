import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/utils/error/error_handler.dart';
import '../../data/data_sources_contract/food_remote_data_source_contract.dart';
import '../api_client/food_api_client.dart';
import '../models/food/meals_response_model.dart';
import '../models/food/recommendation_food_response.dart';
import '../models/food_details/meal_details_response_model.dart';

@Injectable(as: FoodRemoteDataSourceContract)
class FoodRemoteDataSourceImpl implements FoodRemoteDataSourceContract {
  final FoodApiClient _foodApiClient;

  FoodRemoteDataSourceImpl(this._foodApiClient);

  @override
  Future<BaseResponse<RecommendationFoodResponse>>
  getRecommendationFood() async {
    try {
      final response = await _foodApiClient.getRecommendationFood();
      return SuccessBaseResponse(data: response);
    } catch (error) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(error));
    }
  }

  @override
  Future<BaseResponse<MealsResponseModel>> getMealsByCategory(
    String category,
  ) async {
    try {
      final response = await _foodApiClient.getMealsByCategory(category);
      return SuccessBaseResponse(data: response);
    } catch (error) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(error));
    }
  }

  @override
  Future<BaseResponse<MealDetailsResponseModel>> getMealDetails(
    String mealId,
  ) async {
    try {
      final response = await _foodApiClient.getMealDetails(mealId);
      return SuccessBaseResponse(data: response);
    } catch (error) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(error));
    }
  }
}
