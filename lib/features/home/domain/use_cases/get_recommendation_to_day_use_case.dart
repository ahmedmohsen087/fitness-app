import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/recommendation_to_day/recommendation_to_day_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetRecommendationToDayUseCase {
  final HomeRepositoryContract _homeRepository;

  GetRecommendationToDayUseCase(this._homeRepository);

  Future<BaseResponse<RecommendationToDayEntity>> execute() {
    return _homeRepository.getRecommendationToDay();
  }
}
