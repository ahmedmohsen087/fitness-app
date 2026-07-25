import 'package:fitness_app/config/base_response/base_response.dart';

import '../models/difficulty_level_model.dart';
import '../models/exercise_model.dart';
import '../models/muscle_group_model.dart';
import '../models/muscle_model.dart';

abstract class FitnessRemoteDataSourceContract {
  Future<BaseResponse<MusclesGroupResponseModel>> getMuscleGroups();
  Future<BaseResponse<MusclesResponseModel>> getMusclesByGroupId(String groupId);
  Future<BaseResponse<MusclesResponseModel>> getRandomMuscles();
  Future<BaseResponse<ExercisesResponseModel>> getRandomExercises({
    String? targetMuscleGroupId,
    String? difficultyLevelId,
    int? limit,
  });
  Future<BaseResponse<DifficultyLevelsResponseModel>> getDifficultyLevelsByPrimeMover(
    String primeMoverMuscleId,
  );
  Future<BaseResponse<ExercisesResponseModel>> getExercisesByMuscleAndDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  });
}
