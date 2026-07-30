import 'package:fitness_app/config/base_response/base_response.dart';

import '../entities/difficulty_level_entity.dart';
import '../entities/exercise_entity.dart';
import '../entities/muscle_entity.dart';
import '../entities/muscle_group_entity.dart';

abstract class FitnessRepositoryContract {
  Future<BaseResponse<List<MuscleGroupEntity>>> getMuscleGroups();
  Future<BaseResponse<List<MuscleEntity>>> getMusclesByGroupId(String groupId);
  Future<BaseResponse<List<MuscleEntity>>> getRandomMuscles();
  Future<BaseResponse<List<ExerciseEntity>>> getRandomExercises({
    String? targetMuscleGroupId,
    String? difficultyLevelId,
    int? limit,
  });

  Future<BaseResponse<List<DifficultyLevelEntity>>>
  getDifficultyLevelsByPrimeMover(String primeMoverMuscleId);
  Future<BaseResponse<List<ExerciseEntity>>> getExercisesByMuscleAndDifficulty({
    required String primeMoverMuscleId,
    required String difficultyLevelId,
  });
}
