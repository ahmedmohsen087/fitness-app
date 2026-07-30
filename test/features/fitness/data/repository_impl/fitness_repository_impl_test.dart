import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/api/request_models/exercises_request_model.dart';
import 'package:fitness_app/features/fitness/api/request_models/random_exercises_request_model.dart';
import 'package:fitness_app/features/fitness/data/data_source_contract/fitness_remote_data_source_contract.dart';
import 'package:fitness_app/features/fitness/data/models/difficulty_level_model.dart';
import 'package:fitness_app/features/fitness/data/models/exercise_model.dart';
import 'package:fitness_app/features/fitness/data/models/muscle_group_model.dart';
import 'package:fitness_app/features/fitness/data/models/muscle_model.dart';
import 'package:fitness_app/features/fitness/data/repository_impl/fitness_repository_impl.dart';
import 'package:fitness_app/features/fitness/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fitness_repository_impl_test.mocks.dart';

@GenerateMocks([FitnessRemoteDataSourceContract])
void main() {
  late MockFitnessRemoteDataSourceContract mockDataSource;
  late FitnessRepositoryImpl repository;

  setUpAll(() {
    provideDummy<BaseResponse<MusclesGroupResponseModel>>(
      SuccessBaseResponse(data: MusclesGroupResponseModel()),
    );
    provideDummy<BaseResponse<MusclesResponseModel>>(
      SuccessBaseResponse(data: MusclesResponseModel()),
    );
    provideDummy<BaseResponse<ExercisesResponseModel>>(
      SuccessBaseResponse(data: ExercisesResponseModel()),
    );
    provideDummy<BaseResponse<DifficultyLevelsResponseModel>>(
      SuccessBaseResponse(data: DifficultyLevelsResponseModel()),
    );
  });

  setUp(() {
    mockDataSource = MockFitnessRemoteDataSourceContract();
    repository = FitnessRepositoryImpl(mockDataSource);
  });

  group('getMuscleGroups', () {
    test('maps response model to list of MuscleGroupEntity on success',
        () async {
      final responseModel = MusclesGroupResponseModel(
        message: 'success',
        musclesGroup: [const MuscleGroupModel(id: 'g1', name: 'Chest')],
      );
      when(mockDataSource.getMuscleGroups()).thenAnswer(
        (_) async => SuccessBaseResponse(data: responseModel),
      );

      final result = await repository.getMuscleGroups();

      expect(result, isA<SuccessBaseResponse<List<MuscleGroupEntity>>>());
      final list = (result as SuccessBaseResponse<List<MuscleGroupEntity>>).data;
      expect(list.length, equals(1));
      expect(list.first.id, equals('g1'));
    });

    test('returns ErrorBaseResponse on failure', () async {
      when(mockDataSource.getMuscleGroups()).thenAnswer(
        (_) async => ErrorBaseResponse(errorMessage: 'Error'),
      );

      final result = await repository.getMuscleGroups();

      expect(result, isA<ErrorBaseResponse<List<MuscleGroupEntity>>>());
    });
  });

  group('getMusclesByGroupId', () {
    test('maps response model to list of MuscleEntity on success', () async {
      final responseModel = MusclesResponseModel(
        message: 'success',
        muscles: [const MuscleModel(id: 'm1', name: 'Pecs', image: 'img')],
      );
      when(mockDataSource.getMusclesByGroupId('g1')).thenAnswer(
        (_) async => SuccessBaseResponse(data: responseModel),
      );

      final result = await repository.getMusclesByGroupId('g1');

      expect(result, isA<SuccessBaseResponse<List<MuscleEntity>>>());
      final list = (result as SuccessBaseResponse<List<MuscleEntity>>).data;
      expect(list.length, equals(1));
      expect(list.first.id, equals('m1'));
    });
  });

  group('getRandomMuscles', () {
    test('maps response model to list of MuscleEntity on success', () async {
      final responseModel = MusclesResponseModel(
        message: 'success',
        muscles: [const MuscleModel(id: 'm2', name: 'Biceps', image: 'img')],
      );
      when(mockDataSource.getRandomMuscles()).thenAnswer(
        (_) async => SuccessBaseResponse(data: responseModel),
      );

      final result = await repository.getRandomMuscles();

      expect(result, isA<SuccessBaseResponse<List<MuscleEntity>>>());
    });
  });

  group('getRandomExercises', () {
    test('maps response model to list of ExerciseEntity on success', () async {
      final responseModel = ExercisesResponseModel(
        message: 'success',
        exercises: [],
      );
      const request = RandomExercisesRequestModel(limit: 5);
      when(mockDataSource.getRandomExercises(requestModel: request)).thenAnswer(
        (_) async => SuccessBaseResponse(data: responseModel),
      );

      final result = await repository.getRandomExercises(requestModel: request);

      expect(result, isA<SuccessBaseResponse<List<ExerciseEntity>>>());
    });
  });

  group('getDifficultyLevelsByPrimeMover', () {
    test('maps response model to list of DifficultyLevelEntity on success',
        () async {
      final responseModel = DifficultyLevelsResponseModel(
        message: 'success',
        difficultyLevels: [
          const DifficultyLevelModel(id: 'd1', name: 'Easy')
        ],
      );
      when(mockDataSource.getDifficultyLevelsByPrimeMover('m1')).thenAnswer(
        (_) async => SuccessBaseResponse(data: responseModel),
      );

      final result = await repository.getDifficultyLevelsByPrimeMover('m1');

      expect(result, isA<SuccessBaseResponse<List<DifficultyLevelEntity>>>());
    });
  });

  group('getExercisesByMuscleAndDifficulty', () {
    test('maps response model to list of ExerciseEntity on success', () async {
      final responseModel = ExercisesResponseModel(
        message: 'success',
        exercises: [],
      );
      const request = ExercisesRequestModel(
        primeMoverMuscleId: 'm1',
        difficultyLevelId: 'd1',
      );
      when(mockDataSource.getExercisesByMuscleAndDifficulty(
        requestModel: request,
      )).thenAnswer(
        (_) async => SuccessBaseResponse(data: responseModel),
      );

      final result = await repository.getExercisesByMuscleAndDifficulty(
        requestModel: request,
      );

      expect(result, isA<SuccessBaseResponse<List<ExerciseEntity>>>());
    });
  });
}
