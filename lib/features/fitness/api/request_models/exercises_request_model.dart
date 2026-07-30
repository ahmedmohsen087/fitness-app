import '../../../../core/values/api_parameters.dart';

class ExercisesRequestModel {
  final String primeMoverMuscleId;
  final String difficultyLevelId;

  const ExercisesRequestModel({
    required this.primeMoverMuscleId,
    required this.difficultyLevelId,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiParameters.primeMoverMuscleId: primeMoverMuscleId,
      ApiParameters.difficultyLevelId: difficultyLevelId,
    };
  }
}
