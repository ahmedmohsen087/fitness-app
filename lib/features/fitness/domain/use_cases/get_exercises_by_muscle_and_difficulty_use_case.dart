import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/exercises_request_model.dart';
import '../entities/exercise_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetExercisesByMuscleAndDifficultyUseCase {
  final FitnessRepositoryContract _repository;

  GetExercisesByMuscleAndDifficultyUseCase(this._repository);

  Future<BaseResponse<List<ExerciseEntity>>> execute({
    required ExercisesRequestModel requestModel,
  }) =>
      _repository.getExercisesByMuscleAndDifficulty(
        requestModel: requestModel,
      );
}
