import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/exercise_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetExercisesByMuscleAndDifficultyUseCase {
  final FitnessRepositoryContract _repository;

  GetExercisesByMuscleAndDifficultyUseCase(this._repository);

  Future<BaseResponse<List<ExerciseEntity>>> execute({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  }) => _repository.getExercisesByMuscleAndDifficulty(
    primeMoverMuscleId: primeMoverMuscleId,
    difficultyLevelId: difficultyLevelId,
  );
}
