import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/muscle_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetRandomMusclesUseCase {
  final FitnessRepositoryContract _repository;

  GetRandomMusclesUseCase(this._repository);

  Future<BaseResponse<List<MuscleEntity>>> execute() =>
      _repository.getRandomMuscles();
}
