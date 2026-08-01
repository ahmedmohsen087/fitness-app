import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/fitness/api/request_models/exercises_request_model.dart';
import 'package:fitness_app/features/fitness/domain/entities/difficulty_level_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/exercise_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/popular_training_entity.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_difficulty_levels_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_exercises_by_muscle_and_difficulty_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_use_case.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

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
        musclesByGroupState: BaseState.loading(),
      ),
    );
    await Future.wait([
      _loadMuscleGroups(),
      _loadRecommendationToDay(),
      _fetchPopularTrainingsFlow(),
    ]);
  }

  Future<void> _loadMuscleGroups() async {
    try {
      final response = await _getMusclesUseCase.execute();
      switch (response) {
        case SuccessBaseResponse():
          emit(
            state.copyWith(
              muscleGroupsState: BaseState.success(response.data),
            ),
          );
          if (response.data.isNotEmpty) {
            await _selectMuscleGroup(response.data.first.id);
          }
        case ErrorBaseResponse():
          emit(
            state.copyWith(
              muscleGroupsState: BaseState.error(response.errorMessage),
              musclesByGroupState: BaseState.error(response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          muscleGroupsState: BaseState.error(e.toString()),
          musclesByGroupState: BaseState.error(e.toString()),
        ),
      );
    }
  }

  Future<void> _loadRecommendationToDay() async {
    try {
      final response = await _getRandomMusclesUseCase.execute();
      switch (response) {
        case SuccessBaseResponse():
          emit(
            state.copyWith(
              recommendationToDayState: BaseState.success(response.data),
            ),
          );
        case ErrorBaseResponse():
          emit(
            state.copyWith(
              recommendationToDayState:
                  BaseState.error(response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          recommendationToDayState: BaseState.error(e.toString()),
        ),
      );
    }
  }

  Future<void> _fetchPopularTrainingsFlow() async {
    try {
      final randomMusclesRes = await _getRandomMusclesUseCase.execute();
      if (randomMusclesRes is! SuccessBaseResponse<List<MuscleEntity>>) {
        final errMsg = randomMusclesRes is ErrorBaseResponse<List<MuscleEntity>>
            ? randomMusclesRes.errorMessage
            : 'Failed to load random muscles';
        emit(state.copyWith(
          popularTrainingState: BaseState.error(errMsg),
        ));
        return;
      }

      final muscles = randomMusclesRes.data.take(4).toList();
      final futures = muscles.asMap().entries.map(
            (entry) => _buildPopularItemForMuscle(entry.value, entry.key),
          );

      final items = await Future.wait(futures);
      final result = items.whereType<PopularTrainingEntity>().toList();

      emit(state.copyWith(popularTrainingState: BaseState.success(result)));
    } catch (e) {
      emit(state.copyWith(
        popularTrainingState: BaseState.error(e.toString()),
      ));
    }
  }

  Future<PopularTrainingEntity?> _buildPopularItemForMuscle(
    MuscleEntity muscle,
    int index,
  ) async {
    try {
      final levelsRes = await _getDifficultyLevelsUseCase.execute(muscle.id);
      if (levelsRes is! SuccessBaseResponse<List<DifficultyLevelEntity>> ||
          levelsRes.data.isEmpty) {
        return null;
      }

      final levels = levelsRes.data;
      final selectedLevel = levels[index % levels.length];
      final count = await _fetchExercisesCount(muscle.id, selectedLevel.id);

      return PopularTrainingEntity(
        id: muscle.id,
        muscleName: 'Exercises That Strengthen Your ${muscle.name}',
        image: muscle.image,
        totalExercises: count,
        difficultyLevel: selectedLevel.name,
        primeMoverMuscleId: muscle.id,
        difficultyLevelId: selectedLevel.id,
      );
    } catch (_) {
      return null;
    }
  }

  Future<int> _fetchExercisesCount(
    String muscleId,
    String levelId,
  ) async {
    try {
      final req = ExercisesRequestModel(
        primeMoverMuscleId: muscleId,
        difficultyLevelId: levelId,
      );
      final res = await _getExercisesByMuscleAndDifficultyUseCase.execute(
        requestModel: req,
      );
      if (res is SuccessBaseResponse<List<ExerciseEntity>>) {
        return res.data.length;
      }
    } catch (_) {}
    return 0;
  }

  Future<void> _selectMuscleGroup(String? groupId) async {
    if (groupId == null || groupId.isEmpty) return;
    emit(state.copyWith(
      selectedGroupId: groupId,
      musclesByGroupState: BaseState.loading(),
    ));
    try {
      final response = await _getMusclesByGroupUseCase.execute(groupId);
      switch (response) {
        case SuccessBaseResponse():
          emit(
            state.copyWith(
              musclesByGroupState: BaseState.success(response.data),
            ),
          );
        case ErrorBaseResponse():
          emit(
            state.copyWith(
              musclesByGroupState: BaseState.error(response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          musclesByGroupState: BaseState.error(e.toString()),
        ),
      );
    }
  }

  Future<void> _loadExerciseDetails(
    String primeMoverMuscleId, [
    String? initialDifficultyLevelId,
  ]) async {
    emit(
      state.copyWith(
        difficultyLevelsState: BaseState.loading(),
        exercisesByDifficultyState: BaseState.loading(),
      ),
    );

    try {
      final levelsRes =
          await _getDifficultyLevelsUseCase.execute(primeMoverMuscleId);

      if (levelsRes is! SuccessBaseResponse<List<DifficultyLevelEntity>>) {
        final errorMsg = levelsRes is ErrorBaseResponse
            ? (levelsRes as ErrorBaseResponse).errorMessage
            : 'Failed to load difficulty levels';

        emit(
          state.copyWith(
            difficultyLevelsState: BaseState.error(errorMsg),
            exercisesByDifficultyState: BaseState.error(errorMsg),
          ),
        );
        return;
      }

      final levels = levelsRes.data;

      if (levels.isEmpty) {
        emit(
          state.copyWith(
            difficultyLevelsState: BaseState.success([]),
            exercisesByDifficultyState: BaseState.success([]),
          ),
        );
        return;
      }

      emit(state.copyWith(difficultyLevelsState: BaseState.success(levels)));

      final selectedLevelId = initialDifficultyLevelId ?? levels.first.id;

      await _fetchExercisesForLevel(primeMoverMuscleId, selectedLevelId);
    } catch (e) {
      emit(
        state.copyWith(
          difficultyLevelsState: BaseState.error(e.toString()),
          exercisesByDifficultyState: BaseState.error(e.toString()),
        ),
      );
    }
  }

  Future<void> _selectDifficultyLevel(
    String primeMoverMuscleId,
    String difficultyLevelId,
  ) async {
    emit(state.copyWith(
      selectedLevelId: difficultyLevelId,
      exercisesByDifficultyState: BaseState.loading(),
    ));
    await _fetchExercisesForLevel(primeMoverMuscleId, difficultyLevelId);
  }

  Future<void> _fetchExercisesForLevel(
    String primeMoverMuscleId,
    String difficultyLevelId,
  ) async {
    try {
      final requestModel = ExercisesRequestModel(
        primeMoverMuscleId: primeMoverMuscleId,
        difficultyLevelId: difficultyLevelId,
      );

      final response = await _getExercisesByMuscleAndDifficultyUseCase.execute(
        requestModel: requestModel,
      );

      switch (response) {
        case SuccessBaseResponse():
          emit(state.copyWith(
            exercisesByDifficultyState: BaseState.success(response.data),
          ));
        case ErrorBaseResponse():
          emit(
            state.copyWith(
              exercisesByDifficultyState:
                  BaseState.error(response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          exercisesByDifficultyState: BaseState.error(e.toString()),
        ),
      );
    }
  }
}
