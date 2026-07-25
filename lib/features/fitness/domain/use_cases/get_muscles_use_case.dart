import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/muscle_group_entity.dart';
import '../repository_contract/fitness_repository_contract.dart';

@injectable
class GetMusclesUseCase {
  final FitnessRepositoryContract _repository;

  GetMusclesUseCase(this._repository);

  Future<BaseResponse<List<MuscleGroupEntity>>> execute() =>
      _repository.getMuscleGroups();
}
