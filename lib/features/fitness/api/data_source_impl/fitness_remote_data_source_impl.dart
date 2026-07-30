import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source_contract/fitness_remote_data_source_contract.dart';
import '../../data/models/difficulty_level_model.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/muscle_group_model.dart';
import '../../data/models/muscle_model.dart';
import '../api_client/fitness_api_client.dart';
import '../request_models/exercises_request_model.dart';
import '../request_models/random_exercises_request_model.dart';

@Injectable(as: FitnessRemoteDataSourceContract)
class FitnessRemoteDataSourceImpl implements FitnessRemoteDataSourceContract {
  final FitnessApiClient _apiClient;

  FitnessRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<MusclesGroupResponseModel>> getMuscleGroups() async {
    try {
      final result = await _apiClient.getMuscleGroups();
      return SuccessBaseResponse(data: result);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<MusclesResponseModel>> getMusclesByGroupId(
    String groupId,
  ) async {
    try {
      final result = await _apiClient.getMusclesByMuscleGroupQuery(groupId);
      return SuccessBaseResponse(data: result);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<MusclesResponseModel>> getRandomMuscles() async {
    try {
      final result = await _apiClient.getRandomMuscles();
      return SuccessBaseResponse(data: result);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<ExercisesResponseModel>> getRandomExercises({
    RandomExercisesRequestModel? requestModel,
  }) async {
    try {
      final result = await _apiClient.getRandomExercises(
        requestModel?.targetMuscleGroupId,
        requestModel?.difficultyLevelId,
        requestModel?.limit,
      );
      return SuccessBaseResponse(data: result);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<DifficultyLevelsResponseModel>>
      getDifficultyLevelsByPrimeMover(String primeMoverMuscleId) async {
    try {
      final result = await _apiClient.getDifficultyLevelsByPrimeMover(
        primeMoverMuscleId,
      );
      return SuccessBaseResponse(data: result);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<ExercisesResponseModel>>
      getExercisesByMuscleAndDifficulty({
    required ExercisesRequestModel requestModel,
  }) async {
    try {
      final result = await _apiClient.getExercisesByMuscleAndDifficulty(
        requestModel.primeMoverMuscleId,
        requestModel.difficultyLevelId,
      );
      return SuccessBaseResponse(data: result);
    } catch (e) {
      final String message = ErrorHandler.handle(e);
      return ErrorBaseResponse(errorMessage: message);
    }
  }
}
