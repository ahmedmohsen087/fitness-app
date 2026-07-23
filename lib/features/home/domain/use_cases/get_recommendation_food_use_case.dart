import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/category_food/recommendation_food_entity.dart';
import '../repository_contract/food_repository_contract.dart';

@injectable
class GetRecommendationFoodUseCase {
  final FoodRepositoryContract _foodRepository;

  GetRecommendationFoodUseCase(this._foodRepository);

  Future<BaseResponse<RecommendationFoodEntity>> execute() {
    return _foodRepository.getRecommendationFood();
  }
}
