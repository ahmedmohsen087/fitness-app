import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/exercises_request_model.dart';
import '../../api/request_models/random_exercises_request_model.dart';
import '../../domain/entities/difficulty_level_entity.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/muscle_entity.dart';
import '../../domain/entities/muscle_group_entity.dart';
import '../../domain/mappers/fitness_mappers.dart';
import '../../domain/repository_contract/fitness_repository_contract.dart';
import '../data_source_contract/fitness_remote_data_source_contract.dart';

@Injectable(as: FitnessRepositoryContract)
class FitnessRepositoryImpl implements FitnessRepositoryContract {
  final FitnessRemoteDataSourceContract _dataSource;

  FitnessRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups() async {
    final response = await _dataSource.getMuscleGroups();
    switch (response) {
      case SuccessBaseResponse():
        final entities = response.data.musclesGroup
                ?.map((model) => model.toEntity())
                .toList() ??
            [];
        return SuccessBaseResponse(data: entities);
      case ErrorBaseResponse():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(
    String groupId,
  ) async {
    final response = await _dataSource.getMusclesByGroupId(groupId);
    switch (response) {
      case SuccessBaseResponse():
        final entities = response.data.muscles
                ?.map((model) => model.toEntity())
                .toList() ??
            [];
        return SuccessBaseResponse(data: entities);
      case ErrorBaseResponse():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<MuscleEntity>>> getRandomMuscles() async {
    final response = await _dataSource.getRandomMuscles();
    switch (response) {
      case SuccessBaseResponse():
        final entities = response.data.muscles
                ?.map((model) => model.toEntity())
                .toList() ??
            [];
        return SuccessBaseResponse(data: entities);
      case ErrorBaseResponse():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<ExerciseEntity>>> getRandomExercises({
    RandomExercisesRequestModel? requestModel,
  }) async {
    final response = await _dataSource.getRandomExercises(
      requestModel: requestModel,
    );
    switch (response) {
      case SuccessBaseResponse():
        final entities = response.data.exercises
                ?.map((model) => model.toEntity())
                .toList() ??
            [];
        return SuccessBaseResponse(data: entities);
      case ErrorBaseResponse():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<DifficultyLevelEntity>>>
      getDifficultyLevelsByPrimeMover(String primeMoverMuscleId) async {
    final response = await _dataSource.getDifficultyLevelsByPrimeMover(
      primeMoverMuscleId,
    );
    switch (response) {
      case SuccessBaseResponse():
        final entities = response.data.difficultyLevels
                ?.map((model) => model.toEntity())
                .toList() ??
            [];
        return SuccessBaseResponse(data: entities);
      case ErrorBaseResponse():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<List<ExerciseEntity>>>
      getExercisesByMuscleAndDifficulty({
    required ExercisesRequestModel requestModel,
  }) async {
    final response = await _dataSource.getExercisesByMuscleAndDifficulty(
      requestModel: requestModel,
    );
    switch (response) {
      case SuccessBaseResponse():
        final entities = response.data.exercises
                ?.map((model) => model.toEntity())
                .toList() ??
            [];
        return SuccessBaseResponse(data: entities);
      case ErrorBaseResponse():
        return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
  }
}
