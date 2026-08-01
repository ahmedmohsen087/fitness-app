import 'package:equatable/equatable.dart';

class PopularTrainingEntity extends Equatable {
  final String id;
  final String muscleName;
  final String image;
  final int totalExercises;
  final String difficultyLevel;
  final String primeMoverMuscleId;
  final String difficultyLevelId;

  const PopularTrainingEntity({
    required this.id,
    required this.muscleName,
    required this.image,
    required this.totalExercises,
    required this.difficultyLevel,
    required this.primeMoverMuscleId,
    required this.difficultyLevelId,
  });

  @override
  List<Object?> get props => [
    id,
    muscleName,
    image,
    totalExercises,
    difficultyLevel,
    primeMoverMuscleId,
    difficultyLevelId,
  ];
}
