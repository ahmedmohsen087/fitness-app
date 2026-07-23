import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/category_food/recommendation_food_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetRecommendationFoodUseCase {
  final HomeRepositoryContract _homeRepository;

  GetRecommendationFoodUseCase(this._homeRepository);

  Future<BaseResponse<RecommendationFoodEntity>> execute() {
    return _homeRepository.getRecommendationFood();
  }
}
