import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_entity.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/category_food/recommendation_food_entity.dart';
import '../entities/recommendation_to_day/recommendation_to_day_entity.dart';



abstract interface class HomeRepositoryContract {
  Future<BaseResponse<RecommendationToDayEntity>> getRecommendationToDay();
  Future<BaseResponse<MusclesGroupEntity>> getMusclesGroup();
  Future<BaseResponse<MusclesGroupByIdEntity>> getMusclesGroupId(String id);
  Future<BaseResponse<RecommendationFoodEntity>> getRecommendationFood();
}
