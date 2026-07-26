import 'package:fitness_app/config/base_cubit/base_cubit.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/exercises_request_model.dart';
import '../../domain/entities/muscle_entity.dart';
import '../../domain/entities/popular_training_entity.dart';
import '../../domain/use_cases/get_difficulty_levels_use_case.dart';
import '../../domain/use_cases/get_exercises_by_muscle_and_difficulty_use_case.dart';
import '../../domain/use_cases/get_muscles_by_group_use_case.dart';
import '../../domain/use_cases/get_muscles_use_case.dart';
import '../../domain/use_cases/get_random_muscles_use_case.dart';
import 'fitness_events.dart';
import 'fitness_state.dart';

@injectable
class FitnessViewModel extends BaseCubit<FitnessState> {
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
    await Future.wait([
      _loadMuscleGroups(),
      _loadRecommendationToDay(),
    ]);
  }

  Future<void> _loadMuscleGroups() async {
    final response = await _getMusclesUseCase.execute();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            muscleGroupsState: BaseState.success(response.data),
          ),
        );
        if (response.data.isNotEmpty) {
          await _loadPopularTraining(response.data.first.id);
        }
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            muscleGroupsState: BaseState.error(response.errorMessage),
            popularTrainingState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _loadRecommendationToDay() async {
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
  }

  Future<void> _loadPopularTraining(String targetGroupId) async {
    final response = await _getMusclesByGroupUseCase.execute(targetGroupId);
    switch (response) {
      case SuccessBaseResponse():
        final popular = _mapMusclesToPopularTrainings(response.data);
        emit(
          state.copyWith(
            popularTrainingState: BaseState.success(popular),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            popularTrainingState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  List<PopularTrainingEntity> _mapMusclesToPopularTrainings(
    List<MuscleEntity> muscles,
  ) {
    return muscles.map((m) {
      return PopularTrainingEntity(
        id: m.id,
        muscleName: m.name,
        image: m.image,
        totalExercises: 10,
        difficultyLevel: 'Medium',
        primeMoverMuscleId: m.id,
        difficultyLevelId: '1',
      );
    }).toList();
  }

  Future<void> _selectMuscleGroup(String? groupId) async {
    emit(state.copyWith(selectedGroupId: groupId));
    if (groupId == null) return;
    emit(state.copyWith(musclesByGroupState: BaseState.loading()));

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
  }

  Future<void> _loadExerciseDetails(
    String primeMoverMuscleId, [
    String? initialDifficultyLevelId,
  ]) async {
    emit(
      state.copyWith(
        difficultyLevelsState: BaseState.loading(),
        exercisesByDifficultyState: BaseState.loading(),
        selectedLevelId: null,
      ),
    );

    final response =
        await _getDifficultyLevelsUseCase.execute(primeMoverMuscleId);
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            difficultyLevelsState: BaseState.success(response.data),
          ),
        );
        if (response.data.isNotEmpty) {
          final targetLevelId = (initialDifficultyLevelId != null &&
                  response.data.any((l) => l.id == initialDifficultyLevelId))
              ? initialDifficultyLevelId
              : response.data.first.id;
          await _selectDifficultyLevel(
            primeMoverMuscleId,
            targetLevelId,
          );
        }
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            difficultyLevelsState: BaseState.error(response.errorMessage),
            exercisesByDifficultyState:
                BaseState.error(response.errorMessage),
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

    final request = ExercisesRequestModel(
      primeMoverMuscleId: primeMoverMuscleId,
      difficultyLevelId: difficultyLevelId,
    );

    final response = await _getExercisesByMuscleAndDifficultyUseCase.execute(
      requestModel: request,
    );

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            exercisesByDifficultyState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            exercisesByDifficultyState:
                BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}
