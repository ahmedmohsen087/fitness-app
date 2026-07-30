import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source_contract/fitness_remote_data_source_contract.dart';
import '../../data/models/difficulty_level_model.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/muscle_group_model.dart';
import '../../data/models/muscle_model.dart';
import '../api_client/fitness_api_client.dart';

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
      return ErrorBaseResponse(errorMessage: _handleError(e));
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
      return ErrorBaseResponse(errorMessage: _handleError(e));
    }
  }

  @override
  Future<BaseResponse<MusclesResponseModel>> getRandomMuscles() async {
    try {
      final result = await _apiClient.getRandomMuscles();
      return SuccessBaseResponse(data: result);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: _handleError(e));
    }
  }

  @override
  Future<BaseResponse<ExercisesResponseModel>> getRandomExercises({
    String? targetMuscleGroupId,
    String? difficultyLevelId,
    int? limit,
  }) async {
    try {
      final result = await _apiClient.getRandomExercises(
        targetMuscleGroupId,
        difficultyLevelId,
        limit,
      );
      return SuccessBaseResponse(data: result);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: _handleError(e));
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
      return ErrorBaseResponse(errorMessage: _handleError(e));
    }
  }

  @override
  Future<BaseResponse<ExercisesResponseModel>>
  getExercisesByMuscleAndDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  }) async {
    try {
      final result = await _apiClient.getExercisesByMuscleAndDifficulty(
        primeMoverMuscleId,
        difficultyLevelId,
      );
      return SuccessBaseResponse(data: result);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: _handleError(e));
    }
  }

  String _handleError(Object error) {
    if (error is DioException) {
      if (error.response?.data is Map &&
          (error.response?.data as Map).containsKey('message')) {
        return error.response?.data['message'].toString() ?? 'Network Error';
      }
      return error.message ?? 'Connection Failure';
    }
    return error.toString();
  }
}
