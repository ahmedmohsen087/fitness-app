import 'package:fitness_app/config/base_response/base_response.dart';

import '../../api/request_models/exercises_request_model.dart';
import '../../api/request_models/random_exercises_request_model.dart';
import '../models/difficulty_level_model.dart';
import '../models/exercise_model.dart';
import '../models/muscle_group_model.dart';
import '../models/muscle_model.dart';

abstract class FitnessRemoteDataSourceContract {
  Future<BaseResponse<MusclesGroupResponseModel>> getMuscleGroups();
  Future<BaseResponse<MusclesResponseModel>> getMusclesByGroupId(String groupId);
  Future<BaseResponse<MusclesResponseModel>> getRandomMuscles();
  Future<BaseResponse<ExercisesResponseModel>> getRandomExercises({
    RandomExercisesRequestModel? requestModel,
  });
  Future<BaseResponse<DifficultyLevelsResponseModel>> getDifficultyLevelsByPrimeMover(
    String primeMoverMuscleId,
  );
  Future<BaseResponse<ExercisesResponseModel>> getExercisesByMuscleAndDifficulty({
    required ExercisesRequestModel requestModel,
  });
}
