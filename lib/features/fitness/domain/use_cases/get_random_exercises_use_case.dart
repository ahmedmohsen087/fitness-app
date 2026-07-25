import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/exercise_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetRandomExercisesUseCase {
  final FitnessRepositoryContract _repository;

  GetRandomExercisesUseCase(this._repository);

  Future<BaseResponse<List<ExerciseEntity>>> execute({
    String? targetMuscleGroupId,
    String? difficultyLevelId,
    int? limit,
  }) =>
      _repository.getRandomExercises(
        targetMuscleGroupId: targetMuscleGroupId,
        difficultyLevelId: difficultyLevelId,
        limit: limit,
      );
}
