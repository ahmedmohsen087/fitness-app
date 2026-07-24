import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/food_details/meal_details_response_entity.dart';
import '../repository_contract/food_repository_contract.dart';

@injectable
class GetMealDetailsUseCase {
  final FoodRepositoryContract _repository;

  GetMealDetailsUseCase(this._repository);

  Future<BaseResponse<MealDetailsResponseEntity>> execute(String mealId) =>
      _repository.getMealDetails(mealId);
}
