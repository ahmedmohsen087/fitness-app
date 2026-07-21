import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/category_food/recommendation_food_entity.dart';
import '../entities/muscles_group/muscles_group_by_id_entity.dart';
import '../entities/muscles_group/muscles_group_entity.dart';
import '../entities/recommendation_to_day/recommendation_to_day_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class HomeUseCase {
  final HomeRepositoryContract homeRepository;

  HomeUseCase(this.homeRepository);

  Future<BaseResponse<RecommendationToDayEntity>> getRecommendationToDay()  {
    return homeRepository.getRecommendationToDay();
  }
  Future<BaseResponse<MusclesGroupEntity>> getMusclesGroup()  {
    return homeRepository.getMusclesGroup();
  }
  Future<BaseResponse<MusclesGroupByIdEntity>> getMusclesGroupId(String id)  {
    return homeRepository.getMusclesGroupId(id);
  }
  Future<BaseResponse<RecommendationFoodEntity>> getRecommendationFood()  {
    return homeRepository.getRecommendationFood();
  }
}

