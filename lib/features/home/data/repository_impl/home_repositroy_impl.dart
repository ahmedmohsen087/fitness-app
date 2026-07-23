import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../api/models/food_details/meal_details_response_model.dart';
import '../../domain/entities/category_food/recommendation_food_entity.dart';
import '../../domain/entities/food/meals_entity.dart';
import '../../domain/entities/food_details/meal_details_response_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_entity.dart';
import '../../domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import '../../domain/repository_contract/home_repository_contract.dart';
import '../data_sources_contract/home_remote_data_source_contract.dart';
import '../models/food/meals_response_model.dart';
import '../models/muscles_group/muscles_group_by_id_response.dart';
import '../models/muscles_group/muscles_group_response.dart';
import '../models/recommendation_food/recommendation_food_response.dart';
import '../models/recommendation_to_day/recommendation_to_day_response.dart';

@Injectable(as: HomeRepositoryContract)
class HomeRepositoryImpl implements HomeRepositoryContract {
  final HomeRemoteDataSourceContract homeRemoteDataSource;

  HomeRepositoryImpl(this.homeRemoteDataSource);

  @override
  Future<BaseResponse<RecommendationToDayEntity>>
  getRecommendationToDay() async {
    final response = await homeRemoteDataSource.getRecommendationToDay();
    switch (response) {
      case SuccessBaseResponse<RecommendationToDayResponse>(data: final data):
        final entity = data.toEntity();
        return SuccessBaseResponse<RecommendationToDayEntity>(data: entity);
      case ErrorBaseResponse<RecommendationToDayResponse>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<RecommendationToDayEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<MusclesGroupEntity>> getMusclesGroup() async {
    final response = await homeRemoteDataSource.getMusclesGroup();
    switch (response) {
      case SuccessBaseResponse<MusclesGroupResponse>(data: final data):
        final entity = data.toEntity();
        return SuccessBaseResponse<MusclesGroupEntity>(data: entity);
      case ErrorBaseResponse<MusclesGroupResponse>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<MusclesGroupEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<MusclesGroupByIdEntity>> getMusclesGroupId(
    String id,
  ) async {
    final response = await homeRemoteDataSource.getMusclesGroupId(id);
    switch (response) {
      case SuccessBaseResponse<MusclesGroupByIdResponse>(data: final data):
        return SuccessBaseResponse(data: data.toEntity());
      case ErrorBaseResponse<MusclesGroupByIdResponse>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<MusclesGroupByIdEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<RecommendationFoodEntity>> getRecommendationFood() async {
    final response = await homeRemoteDataSource.getRecommendationFood();
    switch (response) {
      case SuccessBaseResponse<RecommendationFoodResponse>(data: final data):
        return SuccessBaseResponse(data: data.toEntity());
      case ErrorBaseResponse<RecommendationFoodResponse>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<RecommendationFoodEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<MealsEntity>> getMealsByCategory(String category) async {
    final response = await homeRemoteDataSource.getMealsByCategory(category);
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
    final response = await homeRemoteDataSource.getMealDetails(mealId);
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
