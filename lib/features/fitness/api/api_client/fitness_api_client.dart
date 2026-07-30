import 'package:dio/dio.dart';
import 'package:fitness_app/core/values/api_endpoints.dart';
import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/difficulty_level_model.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/muscle_group_model.dart';
import '../../data/models/muscle_model.dart';

part 'fitness_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiEndpoints.fitnessBaseUrl)
abstract class FitnessApiClient {
  @factoryMethod
  factory FitnessApiClient(Dio dio) = _FitnessApiClient;

  @GET(ApiEndpoints.musclesGroup)
  Future<MusclesGroupResponseModel> getMuscleGroups();

  @GET(ApiEndpoints.musclesGroupById)
  Future<MusclesResponseModel> getMusclesByGroupId(
    @Path(ApiParameters.id) String groupId,
  );

  @GET(ApiEndpoints.musclesGroupByMuscleGroup)
  Future<MusclesResponseModel> getMusclesByMuscleGroupQuery(
    @Query(ApiParameters.muscleGroupId) String muscleGroupId,
  );

  @GET(ApiEndpoints.musclesRandom)
  Future<MusclesResponseModel> getRandomMuscles();

  @GET(ApiEndpoints.exercisesRandom)
  Future<ExercisesResponseModel> getRandomExercises(
    @Query(ApiParameters.targetMuscleGroupId) String? targetMuscleGroupId,
    @Query(ApiParameters.difficultyLevelId) String? difficultyLevelId,
    @Query(ApiParameters.limit) int? limit,
  );

  @GET(ApiEndpoints.difficultyLevelsByPrimeMover)
  Future<DifficultyLevelsResponseModel> getDifficultyLevelsByPrimeMover(
    @Query(ApiParameters.primeMoverMuscleId) String primeMoverMuscleId,
  );

  @GET(ApiEndpoints.exercisesByMuscleAndDifficulty)
  Future<ExercisesResponseModel> getExercisesByMuscleAndDifficulty(
    @Query(ApiParameters.primeMoverMuscleId) String primeMoverMuscleId,
    @Query(ApiParameters.difficultyLevelId) String difficultyLevelId,
  );
}
