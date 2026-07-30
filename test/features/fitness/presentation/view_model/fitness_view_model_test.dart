import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/api/request_models/exercises_request_model.dart';
import 'package:fitness_app/features/fitness/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_exercises_by_muscle_and_difficulty_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fitness_view_model_test.mocks.dart';

@GenerateMocks([
  GetMusclesUseCase,
  GetMusclesByGroupUseCase,
  GetRandomMusclesUseCase,
  GetDifficultyLevelsUseCase,
  GetExercisesByMuscleAndDifficultyUseCase,
])
void main() {
  late FitnessViewModel viewModel;
  late MockGetMusclesUseCase mockGetMusclesUseCase;
  late MockGetMusclesByGroupUseCase mockGetMusclesByGroupUseCase;
  late MockGetRandomMusclesUseCase mockGetRandomMusclesUseCase;
  late MockGetDifficultyLevelsUseCase mockGetDifficultyLevelsUseCase;
  late MockGetExercisesByMuscleAndDifficultyUseCase
      mockGetExercisesByMuscleAndDifficultyUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<MuscleGroupEntity>>>(
      SuccessBaseResponse(data: const []),
    );
    provideDummy<BaseResponse<List<MuscleEntity>>>(
      SuccessBaseResponse(data: const []),
    );
    provideDummy<BaseResponse<List<DifficultyLevelEntity>>>(
      SuccessBaseResponse(data: const []),
    );
    provideDummy<BaseResponse<List<ExerciseEntity>>>(
      SuccessBaseResponse(data: const []),
    );
  });

  setUp(() {
    mockGetMusclesUseCase = MockGetMusclesUseCase();
    mockGetMusclesByGroupUseCase = MockGetMusclesByGroupUseCase();
    mockGetRandomMusclesUseCase = MockGetRandomMusclesUseCase();
    mockGetDifficultyLevelsUseCase = MockGetDifficultyLevelsUseCase();
    mockGetExercisesByMuscleAndDifficultyUseCase =
        MockGetExercisesByMuscleAndDifficultyUseCase();

    viewModel = FitnessViewModel(
      mockGetMusclesUseCase,
      mockGetMusclesByGroupUseCase,
      mockGetRandomMusclesUseCase,
      mockGetDifficultyLevelsUseCase,
      mockGetExercisesByMuscleAndDifficultyUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  test('initial state should be empty FitnessState', () {
    expect(viewModel.state, equals(const FitnessState()));
  });

  blocTest<FitnessViewModel, FitnessState>(
    'emits loading and success states when LoadHomeFitnessDataEvent is added',
    build: () {
      when(mockGetMusclesUseCase.execute()).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [MuscleGroupEntity(id: 'g1', name: 'Chest')],
        ),
      );
      when(mockGetMusclesByGroupUseCase.execute('g1')).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [MuscleEntity(id: 'm1', name: 'Pecs', image: 'img')],
        ),
      );
      when(mockGetRandomMusclesUseCase.execute()).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [MuscleEntity(id: 'm2', name: 'Biceps', image: 'img')],
        ),
      );
      when(mockGetDifficultyLevelsUseCase.execute('m2')).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [DifficultyLevelEntity(id: 'l1', name: 'Beginner')],
        ),
      );
      when(
        mockGetExercisesByMuscleAndDifficultyUseCase.execute(
          requestModel: const ExercisesRequestModel(
            primeMoverMuscleId: 'm2',
            difficultyLevelId: 'l1',
          ),
        ),
      ).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [
            ExerciseEntity(
              id: 'e1',
              exercise: 'Curl',
              difficultyLevel: 'Beginner',
              targetMuscleGroup: 'Arms',
              primeMoverMuscle: 'Biceps',
              primaryEquipment: 'Dumbbell',
              videoUrl: 'http',
            ),
          ],
        ),
      );
      return viewModel;
    },
    act: (bloc) => bloc.doEvent(LoadHomeFitnessDataEvent()),
    expect: () => [
      isA<FitnessState>().having(
        (s) => s.muscleGroupsState.isLoading,
        'muscleGroupsState.isLoading',
        isTrue,
      ),
      isA<FitnessState>().having(
        (s) => s.muscleGroupsState.data,
        'muscleGroupsState.data',
        const [MuscleGroupEntity(id: 'g1', name: 'Chest')],
      ),
      isA<FitnessState>().having(
        (s) => s.recommendationToDayState.data,
        'recommendationToDayState.data',
        const [MuscleEntity(id: 'm2', name: 'Biceps', image: 'img')],
      ),
      isA<FitnessState>().having(
        (s) => s.popularTrainingState.data?.length,
        'popularTrainingState.data.length',
        1,
      ),
    ],
  );
}
