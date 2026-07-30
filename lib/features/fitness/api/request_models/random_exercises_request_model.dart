import '../../../../core/values/api_parameters.dart';

class RandomExercisesRequestModel {
  final String? targetMuscleGroupId;
  final String? difficultyLevelId;
  final int? limit;

  const RandomExercisesRequestModel({
    this.targetMuscleGroupId,
    this.difficultyLevelId,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (targetMuscleGroupId != null) ApiParameters.targetMuscleGroupId: targetMuscleGroupId,
      if (difficultyLevelId != null) ApiParameters.difficultyLevelId: difficultyLevelId,
      if (limit != null) ApiParameters.limit: limit,
    };
  }
}
