import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/food/meals_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetMealsByCategoryUseCase {
  final HomeRepositoryContract _homeRepository;

  GetMealsByCategoryUseCase(this._homeRepository);

  Future<BaseResponse<MealsEntity>> execute(String category) {
    return _homeRepository.getMealsByCategory(category);
  }
}
