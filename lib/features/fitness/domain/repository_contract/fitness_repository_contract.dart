import 'package:fitness_app/config/base_response/base_response.dart';

import '../../api/request_models/exercises_request_model.dart';
import '../../api/request_models/random_exercises_request_model.dart';
import '../entities/difficulty_level_entity.dart';
import '../entities/exercise_entity.dart';
import '../entities/muscle_entity.dart';
import '../entities/muscle_group_entity.dart';

abstract class FitnessRepositoryContract {
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups();
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(String groupId);
  Future<BaseResponse<List<MuscleEntity>>> getRandomMuscles();
  Future<BaseResponse<List<ExerciseEntity>>> getRandomExercises({
    RandomExercisesRequestModel? requestModel,
  });
  Future<BaseResponse<List<DifficultyLevelEntity>>> getDifficultyLevelsByPrimeMover(
    String primeMoverMuscleId,
  );
  Future<BaseResponse<List<ExerciseEntity>>> getExercisesByMuscleAndDifficulty({
    required ExercisesRequestModel requestModel,
  });
}
