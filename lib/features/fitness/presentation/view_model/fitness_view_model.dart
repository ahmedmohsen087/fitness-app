import 'dart:math';

import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/difficulty_level_entity.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/muscle_entity.dart';
import '../../domain/entities/muscle_group_entity.dart';
import '../../domain/entities/popular_training_entity.dart';
import '../../domain/use_cases/get_difficulty_levels_use_case.dart';
import '../../domain/use_cases/get_exercises_by_muscle_and_difficulty_use_case.dart';
import '../../domain/use_cases/get_muscles_by_group_use_case.dart';
import '../../domain/use_cases/get_muscles_use_case.dart';
import '../../domain/use_cases/get_random_muscles_use_case.dart';
import 'fitness_events.dart';
import 'fitness_state.dart';

@injectable
class FitnessViewModel extends Cubit<FitnessState> {
  final GetMusclesUseCase _getMusclesUseCase;
  final GetMusclesByGroupUseCase _getMusclesByGroupUseCase;
  final GetRandomMusclesUseCase _getRandomMusclesUseCase;
  final GetDifficultyLevelsUseCase _getDifficultyLevelsUseCase;
  final GetExercisesByMuscleAndDifficultyUseCase
  _getExercisesByMuscleAndDifficultyUseCase;

  FitnessViewModel(
    this._getMusclesUseCase,
    this._getMusclesByGroupUseCase,
    this._getRandomMusclesUseCase,
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
        _loadExerciseDetails(
          event.primeMoverMuscleId,
          event.initialDifficultyLevelId,
        );
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

    final initialResults = await Future.wait([
      _getMusclesUseCase.execute(),
      _getRandomMusclesUseCase.execute(),
    ]);

    if (isClosed) return;

    final groupsRes =
        initialResults[0] as BaseResponse<List<MuscleGroupEntity>>;
    final randomMusclesRes =
        initialResults[1] as BaseResponse<List<MuscleEntity>>;

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

    emit(
      state.copyWith(
        muscleGroupsState: currentGroupsState,
        recommendationToDayState: currentRecState,
      ),
    );

    if (randomMusclesRes is SuccessBaseResponse<List<MuscleEntity>> &&
        randomMusclesRes.data.isNotEmpty) {
      final musclesList = List<MuscleEntity>.from(randomMusclesRes.data)
        ..shuffle();
      final selectedMuscles = musclesList.take(3).toList();
      final random = Random();

      final futures = selectedMuscles.map((muscle) async {
        final levelsRes = await _getDifficultyLevelsUseCase.execute(muscle.id);
        if (levelsRes is SuccessBaseResponse<List<DifficultyLevelEntity>> &&
            levelsRes.data.isNotEmpty) {
          final levelsList = levelsRes.data;
          final level = levelsList[random.nextInt(levelsList.length)];
          final exercisesRes = await _getExercisesByMuscleAndDifficultyUseCase
              .execute(
                primeMoverMuscleId: muscle.id,
                difficultyLevelId: level.id,
              );
          if (exercisesRes is SuccessBaseResponse<List<ExerciseEntity>>) {
            final count = exercisesRes.data.length;
            return PopularTrainingEntity(
              id: muscle.id,
              muscleName: muscle.name,
              image: muscle.image,
              totalExercises: count > 0 ? count : 24,
              difficultyLevel: level.name,
              primeMoverMuscleId: muscle.id,
              difficultyLevelId: level.id,
            );
          }
        }
        return null;
      });

      final results = await Future.wait(futures);
      final popularList = results.whereType<PopularTrainingEntity>().toList();

      if (popularList.isNotEmpty) {
        emit(
          state.copyWith(popularTrainingState: BaseState.success(popularList)),
        );
        if (firstGroupId != null) {
          await _selectMuscleGroup(firstGroupId);
        }
        return;
      }
    }

    emit(
      state.copyWith(
        popularTrainingState: BaseState.error(
          "Failed to load popular training",
        ),
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
      emit(state.copyWith(musclesByGroupState: BaseState.success(res.data)));
    } else if (res is ErrorBaseResponse<List<MuscleEntity>>) {
      emit(
        state.copyWith(musclesByGroupState: BaseState.error(res.errorMessage)),
      );
    }
  }

  Future<void> _loadExerciseDetails(
    String primeMoverMuscleId, [
    String? initialDifficultyLevelId,
  ]) async {
    emit(state.copyWith(difficultyLevelsState: BaseState.loading()));

    final levelsRes = await _getDifficultyLevelsUseCase.execute(
      primeMoverMuscleId,
    );
    if (isClosed) return;

    if (levelsRes is SuccessBaseResponse<List<DifficultyLevelEntity>>) {
      emit(
        state.copyWith(
          difficultyLevelsState: BaseState.success(levelsRes.data),
        ),
      );
      if (levelsRes.data.isNotEmpty) {
        final targetLevelId =
            (initialDifficultyLevelId != null &&
                levelsRes.data.any((l) => l.id == initialDifficultyLevelId))
            ? initialDifficultyLevelId
            : levelsRes.data.first.id;

        await _selectDifficultyLevel(primeMoverMuscleId, targetLevelId);
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
        state.copyWith(exercisesByDifficultyState: BaseState.success(res.data)),
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
