sealed class FitnessEvent {}

class LoadHomeFitnessDataEvent extends FitnessEvent {}

class SelectMuscleGroupEvent extends FitnessEvent {
  final String? groupId;
  SelectMuscleGroupEvent(this.groupId);
}

class LoadExerciseDetailsEvent extends FitnessEvent {
  final String primeMoverMuscleId;
  final String? initialDifficultyLevelId;
  LoadExerciseDetailsEvent(
    this.primeMoverMuscleId, [
    this.initialDifficultyLevelId,
  ]);
}

class SelectDifficultyLevelEvent extends FitnessEvent {
  final String primeMoverMuscleId;
  final String difficultyLevelId;
  SelectDifficultyLevelEvent({
    required this.primeMoverMuscleId,
    required this.difficultyLevelId,
  });
}
