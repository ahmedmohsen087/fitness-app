import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/food/meals_entity.dart';
import '../repository_contract/food_repository_contract.dart';

@injectable
class GetMealsByCategoryUseCase {
  final FoodRepositoryContract _foodRepository;

  GetMealsByCategoryUseCase(this._foodRepository);

  Future<BaseResponse<MealsEntity>> execute(String category) {
    return _foodRepository.getMealsByCategory(category);
  }
}
