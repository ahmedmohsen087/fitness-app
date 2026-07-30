import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/api/api_client/fitness_api_client.dart';
import 'package:fitness_app/features/fitness/api/data_source_impl/fitness_remote_data_source_impl.dart';
import 'package:fitness_app/features/fitness/api/request_models/exercises_request_model.dart';
import 'package:fitness_app/features/fitness/api/request_models/random_exercises_request_model.dart';
import 'package:fitness_app/features/fitness/data/models/difficulty_level_model.dart';
import 'package:fitness_app/features/fitness/data/models/exercise_model.dart';
import 'package:fitness_app/features/fitness/data/models/muscle_group_model.dart';
import 'package:fitness_app/features/fitness/data/models/muscle_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fitness_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([FitnessApiClient])
void main() {
  late MockFitnessApiClient mockApiClient;
  late FitnessRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockFitnessApiClient();
    dataSource = FitnessRemoteDataSourceImpl(mockApiClient);
  });

  group('getMuscleGroups', () {
    test('returns SuccessBaseResponse when API succeeds', () async {
      final responseModel = MusclesGroupResponseModel(
        message: 'success',
        musclesGroup: [const MuscleGroupModel(id: 'g1', name: 'Chest')],
      );
      when(mockApiClient.getMuscleGroups())
          .thenAnswer((_) async => responseModel);

      final result = await dataSource.getMuscleGroups();

      expect(result, isA<SuccessBaseResponse<MusclesGroupResponseModel>>());
      expect((result as SuccessBaseResponse).data, equals(responseModel));
    });

    test('returns ErrorBaseResponse when API throws Exception', () async {
      when(mockApiClient.getMuscleGroups()).thenThrow(Exception('API error'));

      final result = await dataSource.getMuscleGroups();

      expect(result, isA<ErrorBaseResponse<MusclesGroupResponseModel>>());
    });
  });

  group('getMusclesByGroupId', () {
    test('returns SuccessBaseResponse when API succeeds', () async {
      final responseModel = MusclesResponseModel(
        message: 'success',
        muscles: [const MuscleModel(id: 'm1', name: 'Pecs', image: 'img')],
      );
      when(mockApiClient.getMusclesByMuscleGroupQuery('g1'))
          .thenAnswer((_) async => responseModel);

      final result = await dataSource.getMusclesByGroupId('g1');

      expect(result, isA<SuccessBaseResponse<MusclesResponseModel>>());
      expect((result as SuccessBaseResponse).data, equals(responseModel));
    });

    test('returns ErrorBaseResponse when API throws Exception', () async {
      when(mockApiClient.getMusclesByMuscleGroupQuery('g1'))
          .thenThrow(Exception('API error'));

      final result = await dataSource.getMusclesByGroupId('g1');

      expect(result, isA<ErrorBaseResponse<MusclesResponseModel>>());
    });
  });

  group('getRandomMuscles', () {
    test('returns SuccessBaseResponse when API succeeds', () async {
      final responseModel = MusclesResponseModel(
        message: 'success',
        muscles: [const MuscleModel(id: 'm2', name: 'Biceps', image: 'img')],
      );
      when(mockApiClient.getRandomMuscles())
          .thenAnswer((_) async => responseModel);

      final result = await dataSource.getRandomMuscles();

      expect(result, isA<SuccessBaseResponse<MusclesResponseModel>>());
      expect((result as SuccessBaseResponse).data, equals(responseModel));
    });
  });

  group('getRandomExercises', () {
    test('returns SuccessBaseResponse with parameters', () async {
      final responseModel = ExercisesResponseModel(
        message: 'success',
        exercises: [],
      );
      const request = RandomExercisesRequestModel(
        targetMuscleGroupId: 'g1',
        difficultyLevelId: 'd1',
        limit: 5,
      );
      when(mockApiClient.getRandomExercises('g1', 'd1', 5))
          .thenAnswer((_) async => responseModel);

      final result =
          await dataSource.getRandomExercises(requestModel: request);

      expect(result, isA<SuccessBaseResponse<ExercisesResponseModel>>());
      expect((result as SuccessBaseResponse).data, equals(responseModel));
    });
  });

  group('getDifficultyLevelsByPrimeMover', () {
    test('returns SuccessBaseResponse when API succeeds', () async {
      final responseModel = DifficultyLevelsResponseModel(
        message: 'success',
        difficultyLevels: [
          const DifficultyLevelModel(id: 'd1', name: 'Beginner')
        ],
      );
      when(mockApiClient.getDifficultyLevelsByPrimeMover('m1'))
          .thenAnswer((_) async => responseModel);

      final result =
          await dataSource.getDifficultyLevelsByPrimeMover('m1');

      expect(
          result, isA<SuccessBaseResponse<DifficultyLevelsResponseModel>>());
    });
  });

  group('getExercisesByMuscleAndDifficulty', () {
    test('returns SuccessBaseResponse when API succeeds', () async {
      final responseModel = ExercisesResponseModel(
        message: 'success',
        exercises: [],
      );
      const request = ExercisesRequestModel(
        primeMoverMuscleId: 'm1',
        difficultyLevelId: 'd1',
      );
      when(mockApiClient.getExercisesByMuscleAndDifficulty('m1', 'd1'))
          .thenAnswer((_) async => responseModel);

      final result = await dataSource.getExercisesByMuscleAndDifficulty(
        requestModel: request,
      );

      expect(result, isA<SuccessBaseResponse<ExercisesResponseModel>>());
    });
  });
}
