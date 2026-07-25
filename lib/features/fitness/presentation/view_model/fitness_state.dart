import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base_state/base_state.dart';

import '../../domain/entities/difficulty_level_entity.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/muscle_entity.dart';
import '../../domain/entities/muscle_group_entity.dart';

class FitnessState extends Equatable {
  final BaseState<List<MuscleGroupEntity>> muscleGroupsState;
  final BaseState<List<MuscleEntity>> musclesByGroupState;
  final BaseState<List<MuscleEntity>> recommendationToDayState;
  final BaseState<List<ExerciseEntity>> popularTrainingState;
  final BaseState<List<DifficultyLevelEntity>> difficultyLevelsState;
  final BaseState<List<ExerciseEntity>> exercisesByDifficultyState;
  final String? selectedGroupId;
  final String? selectedLevelId;

  const FitnessState({
    this.muscleGroupsState = const BaseState(),
    this.musclesByGroupState = const BaseState(),
    this.recommendationToDayState = const BaseState(),
    this.popularTrainingState = const BaseState(),
    this.difficultyLevelsState = const BaseState(),
    this.exercisesByDifficultyState = const BaseState(),
    this.selectedGroupId,
    this.selectedLevelId,
  });

  FitnessState copyWith({
    BaseState<List<MuscleGroupEntity>>? muscleGroupsState,
    BaseState<List<MuscleEntity>>? musclesByGroupState,
    BaseState<List<MuscleEntity>>? recommendationToDayState,
    BaseState<List<ExerciseEntity>>? popularTrainingState,
    BaseState<List<DifficultyLevelEntity>>? difficultyLevelsState,
    BaseState<List<ExerciseEntity>>? exercisesByDifficultyState,
    String? selectedGroupId,
    String? selectedLevelId,
  }) {
    return FitnessState(
      muscleGroupsState: muscleGroupsState ?? this.muscleGroupsState,
      musclesByGroupState: musclesByGroupState ?? this.musclesByGroupState,
      recommendationToDayState:
          recommendationToDayState ?? this.recommendationToDayState,
      popularTrainingState: popularTrainingState ?? this.popularTrainingState,
      difficultyLevelsState:
          difficultyLevelsState ?? this.difficultyLevelsState,
      exercisesByDifficultyState:
          exercisesByDifficultyState ?? this.exercisesByDifficultyState,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedLevelId: selectedLevelId ?? this.selectedLevelId,
    );
  }

  @override
  List<Object?> get props => [
        muscleGroupsState,
        musclesByGroupState,
        recommendationToDayState,
        popularTrainingState,
        difficultyLevelsState,
        exercisesByDifficultyState,
        selectedGroupId,
        selectedLevelId,
      ];
}
