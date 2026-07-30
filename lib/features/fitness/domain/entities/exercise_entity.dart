import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String exercise;
  final String difficultyLevel;
  final String targetMuscleGroup;
  final String primeMoverMuscle;
  final String primaryEquipment;
  final String videoUrl;

  const ExerciseEntity({
    required this.id,
    required this.exercise,
    required this.difficultyLevel,
    required this.targetMuscleGroup,
    required this.primeMoverMuscle,
    required this.primaryEquipment,
    required this.videoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        exercise,
        difficultyLevel,
        targetMuscleGroup,
        primeMoverMuscle,
        primaryEquipment,
        videoUrl,
      ];
}
