import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/difficulty_level_entity.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/muscle_entity.dart';
import '../../domain/entities/muscle_group_entity.dart';
import '../../domain/use_cases/get_difficulty_levels_use_case.dart';
import '../../domain/use_cases/get_exercises_by_muscle_and_difficulty_use_case.dart';
import '../../domain/use_cases/get_muscles_by_group_use_case.dart';
import '../../domain/use_cases/get_muscles_use_case.dart';
import '../../domain/use_cases/get_random_exercises_use_case.dart';
import '../../domain/use_cases/get_random_muscles_use_case.dart';
import 'fitness_events.dart';
import 'fitness_state.dart';

@injectable
class FitnessViewModel extends Cubit<FitnessState> {
  final GetMusclesUseCase _getMusclesUseCase;
  final GetMusclesByGroupUseCase _getMusclesByGroupUseCase;
  final GetRandomMusclesUseCase _getRandomMusclesUseCase;
  final GetRandomExercisesUseCase _getRandomExercisesUseCase;
  final GetDifficultyLevelsUseCase _getDifficultyLevelsUseCase;
  final GetExercisesByMuscleAndDifficultyUseCase
      _getExercisesByMuscleAndDifficultyUseCase;

  FitnessViewModel(
    this._getMusclesUseCase,
    this._getMusclesByGroupUseCase,
    this._getRandomMusclesUseCase,
    this._getRandomExercisesUseCase,
    this._getDifficultyLevelsUseCase,
    this._getExercisesByMuscleAndDifficultyUseCase,
  ) : super(const FitnessState());

  void doEvent(FitnessEvent event) {
    switch (event) {
      case LoadHomeFitnessDataEvent():
        _loadHomeFitnessData();
      case SelectMuscleGroupEvent():
        _selectMuscleGroup(event.groupId);
      case LoadExerciseDetailsEvent():
        _loadExerciseDetails(event.primeMoverMuscleId);
      case SelectDifficultyLevelEvent():
        _selectDifficultyLevel(
          event.primeMoverMuscleId,
          event.difficultyLevelId,
        );
    }
  }

  Future<void> _loadHomeFitnessData() async {
    emit(
      state.copyWith(
        muscleGroupsState: BaseState.loading(),
        recommendationToDayState: BaseState.loading(),
        popularTrainingState: BaseState.loading(),
      ),
    );

    final groupsRes = await _getMusclesUseCase.execute();
    final randomMusclesRes = await _getRandomMusclesUseCase.execute();
    final randomExRes = await _getRandomExercisesUseCase.execute(limit: 5);

    if (isClosed) return;

    String? firstGroupId;
    var currentGroupsState = state.muscleGroupsState;
    if (groupsRes is SuccessBaseResponse<List<MuscleGroupEntity>>) {
      currentGroupsState = BaseState.success(groupsRes.data);
      if (groupsRes.data.isNotEmpty) {
        firstGroupId = groupsRes.data.first.id;
      }
    } else if (groupsRes is ErrorBaseResponse<List<MuscleGroupEntity>>) {
      currentGroupsState = BaseState.error(groupsRes.errorMessage);
    }

    var currentRecState = state.recommendationToDayState;
    if (randomMusclesRes is SuccessBaseResponse<List<MuscleEntity>>) {
      currentRecState = BaseState.success(randomMusclesRes.data);
    } else if (randomMusclesRes is ErrorBaseResponse<List<MuscleEntity>>) {
      currentRecState = BaseState.error(randomMusclesRes.errorMessage);
    }

    var currentPopState = state.popularTrainingState;
    if (randomExRes is SuccessBaseResponse<List<ExerciseEntity>>) {
      currentPopState = BaseState.success(randomExRes.data);
    } else if (randomExRes is ErrorBaseResponse<List<ExerciseEntity>>) {
      currentPopState = BaseState.error(randomExRes.errorMessage);
    }

    emit(
      state.copyWith(
        muscleGroupsState: currentGroupsState,
        recommendationToDayState: currentRecState,
        popularTrainingState: currentPopState,
      ),
    );

    if (firstGroupId != null) {
      await _selectMuscleGroup(firstGroupId);
    }
  }

  Future<void> _selectMuscleGroup(String? groupId) async {
    emit(
      state.copyWith(
        selectedGroupId: groupId,
        musclesByGroupState: BaseState.loading(),
      ),
    );

    if (groupId == null || groupId.isEmpty) return;

    final res = await _getMusclesByGroupUseCase.execute(groupId);
    if (isClosed) return;

    if (res is SuccessBaseResponse<List<MuscleEntity>>) {
      emit(
        state.copyWith(
          musclesByGroupState: BaseState.success(res.data),
        ),
      );
    } else if (res is ErrorBaseResponse<List<MuscleEntity>>) {
      emit(
        state.copyWith(
          musclesByGroupState: BaseState.error(res.errorMessage),
        ),
      );
    }
  }

  Future<void> _loadExerciseDetails(String primeMoverMuscleId) async {
    emit(state.copyWith(difficultyLevelsState: BaseState.loading()));

    final levelsRes =
        await _getDifficultyLevelsUseCase.execute(primeMoverMuscleId);
    if (isClosed) return;

    if (levelsRes is SuccessBaseResponse<List<DifficultyLevelEntity>>) {
      emit(
        state.copyWith(
          difficultyLevelsState: BaseState.success(levelsRes.data),
        ),
      );
      if (levelsRes.data.isNotEmpty) {
        await _selectDifficultyLevel(
          primeMoverMuscleId,
          levelsRes.data.first.id,
        );
      }
    } else if (levelsRes is ErrorBaseResponse<List<DifficultyLevelEntity>>) {
      emit(
        state.copyWith(
          difficultyLevelsState: BaseState.error(levelsRes.errorMessage),
        ),
      );
    }
  }

  Future<void> _selectDifficultyLevel(
    String primeMoverMuscleId,
    String difficultyLevelId,
  ) async {
    emit(
      state.copyWith(
        selectedLevelId: difficultyLevelId,
        exercisesByDifficultyState: BaseState.loading(),
      ),
    );

    final res = await _getExercisesByMuscleAndDifficultyUseCase.execute(
      primeMoverMuscleId: primeMoverMuscleId,
      difficultyLevelId: difficultyLevelId,
    );

    if (isClosed) return;

    if (res is SuccessBaseResponse<List<ExerciseEntity>>) {
      emit(
        state.copyWith(
          exercisesByDifficultyState: BaseState.success(res.data),
        ),
      );
    } else if (res is ErrorBaseResponse<List<ExerciseEntity>>) {
      emit(
        state.copyWith(
          exercisesByDifficultyState: BaseState.error(res.errorMessage),
        ),
      );
    }
  }
}
