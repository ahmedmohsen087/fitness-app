import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/difficulty_level_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetDifficultyLevelsUseCase {
  final FitnessRepositoryContract _repository;

  GetDifficultyLevelsUseCase(this._repository);

  Future<BaseResponse<List<DifficultyLevelEntity>>> execute(
    String primeMoverMuscleId,
  ) =>
      _repository.getDifficultyLevelsByPrimeMover(primeMoverMuscleId);
}
