import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/random_exercises_request_model.dart';
import '../entities/exercise_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetRandomExercisesUseCase {
  final FitnessRepositoryContract _repository;

  GetRandomExercisesUseCase(this._repository);

  Future<BaseResponse<List<ExerciseEntity>>> execute({
    RandomExercisesRequestModel? requestModel,
  }) =>
      _repository.getRandomExercises(
        requestModel: requestModel,
      );
}
