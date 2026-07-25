import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/fitness/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_exercises_by_muscle_and_difficulty_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_random_exercises_use_case.dart';
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
  GetRandomExercisesUseCase,
  GetDifficultyLevelsUseCase,
  GetExercisesByMuscleAndDifficultyUseCase,
])
void main() {
  late FitnessViewModel viewModel;
  late MockGetMusclesUseCase mockGetMusclesUseCase;
  late MockGetMusclesByGroupUseCase mockGetMusclesByGroupUseCase;
  late MockGetRandomMusclesUseCase mockGetRandomMusclesUseCase;
  late MockGetRandomExercisesUseCase mockGetRandomExercisesUseCase;
  late MockGetDifficultyLevelsUseCase mockGetDifficultyLevelsUseCase;
  late MockGetExercisesByMuscleAndDifficultyUseCase
      mockGetExercisesByMuscleAndDifficultyUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<MuscleGroupEntity>>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<List<MuscleEntity>>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<List<ExerciseEntity>>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<List<DifficultyLevelEntity>>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
  });

  setUp(() {
    mockGetMusclesUseCase = MockGetMusclesUseCase();
    mockGetMusclesByGroupUseCase = MockGetMusclesByGroupUseCase();
    mockGetRandomMusclesUseCase = MockGetRandomMusclesUseCase();
    mockGetRandomExercisesUseCase = MockGetRandomExercisesUseCase();
    mockGetDifficultyLevelsUseCase = MockGetDifficultyLevelsUseCase();
    mockGetExercisesByMuscleAndDifficultyUseCase =
        MockGetExercisesByMuscleAndDifficultyUseCase();

    viewModel = FitnessViewModel(
      mockGetMusclesUseCase,
      mockGetMusclesByGroupUseCase,
      mockGetRandomMusclesUseCase,
      mockGetRandomExercisesUseCase,
      mockGetDifficultyLevelsUseCase,
      mockGetExercisesByMuscleAndDifficultyUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  test('initial state should be empty FitnessState', () {
    expect(viewModel.state, const FitnessState());
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
      when(mockGetRandomExercisesUseCase.execute(limit: 5)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [
            ExerciseEntity(
              id: 'e1',
              exercise: 'Pushup',
              difficultyLevel: 'Easy',
              targetMuscleGroup: 'Chest',
              primeMoverMuscle: 'Pecs',
              primaryEquipment: 'Body',
              videoUrl: 'http',
            ),
          ],
        ),
      );
      return viewModel;
    },
    act: (cubit) => cubit.doEvent(LoadHomeFitnessDataEvent()),
    expect: () => [
      const FitnessState(
        muscleGroupsState: BaseState(isLoading: true),
        recommendationToDayState: BaseState(isLoading: true),
        popularTrainingState: BaseState(isLoading: true),
      ),
      const FitnessState(
        muscleGroupsState: BaseState(
          data: [MuscleGroupEntity(id: 'g1', name: 'Chest')],
        ),
        recommendationToDayState: BaseState(
          data: [MuscleEntity(id: 'm2', name: 'Biceps', image: 'img')],
        ),
        popularTrainingState: BaseState(
          data: [
            ExerciseEntity(
              id: 'e1',
              exercise: 'Pushup',
              difficultyLevel: 'Easy',
              targetMuscleGroup: 'Chest',
              primeMoverMuscle: 'Pecs',
              primaryEquipment: 'Body',
              videoUrl: 'http',
            ),
          ],
        ),
      ),
      const FitnessState(
        muscleGroupsState: BaseState(
          data: [MuscleGroupEntity(id: 'g1', name: 'Chest')],
        ),
        recommendationToDayState: BaseState(
          data: [MuscleEntity(id: 'm2', name: 'Biceps', image: 'img')],
        ),
        popularTrainingState: BaseState(
          data: [
            ExerciseEntity(
              id: 'e1',
              exercise: 'Pushup',
              difficultyLevel: 'Easy',
              targetMuscleGroup: 'Chest',
              primeMoverMuscle: 'Pecs',
              primaryEquipment: 'Body',
              videoUrl: 'http',
            ),
          ],
        ),
        selectedGroupId: 'g1',
        musclesByGroupState: BaseState(isLoading: true),
      ),
      const FitnessState(
        muscleGroupsState: BaseState(
          data: [MuscleGroupEntity(id: 'g1', name: 'Chest')],
        ),
        recommendationToDayState: BaseState(
          data: [MuscleEntity(id: 'm2', name: 'Biceps', image: 'img')],
        ),
        popularTrainingState: BaseState(
          data: [
            ExerciseEntity(
              id: 'e1',
              exercise: 'Pushup',
              difficultyLevel: 'Easy',
              targetMuscleGroup: 'Chest',
              primeMoverMuscle: 'Pecs',
              primaryEquipment: 'Body',
              videoUrl: 'http',
            ),
          ],
        ),
        selectedGroupId: 'g1',
        musclesByGroupState: BaseState(
          data: [MuscleEntity(id: 'm1', name: 'Pecs', image: 'img')],
        ),
      ),
    ],
  );
}
