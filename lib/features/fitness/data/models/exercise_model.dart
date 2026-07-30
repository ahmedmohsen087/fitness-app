import 'package:json_annotation/json_annotation.dart';

part 'exercise_model.g.dart';

@JsonSerializable(createToJson: false)
class ExerciseModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? exercise;
  @JsonKey(name: 'short_youtube_demonstration')
  final String? shortYoutubeDemonstration;
  @JsonKey(name: 'in_depth_youtube_explanation')
  final String? inDepthYoutubeExplanation;
  @JsonKey(name: 'difficulty_level')
  final String? difficultyLevel;
  @JsonKey(name: 'target_muscle_group')
  final String? targetMuscleGroup;
  @JsonKey(name: 'prime_mover_muscle')
  final String? primeMoverMuscle;
  @JsonKey(name: 'primary_equipment')
  final String? primaryEquipment;
  @JsonKey(name: 'short_youtube_demonstration_link')
  final String? shortYoutubeDemonstrationLink;
  @JsonKey(name: 'in_depth_youtube_explanation_link')
  final String? inDepthYoutubeExplanationLink;

  const ExerciseModel({
    this.id,
    this.exercise,
    this.shortYoutubeDemonstration,
    this.inDepthYoutubeExplanation,
    this.difficultyLevel,
    this.targetMuscleGroup,
    this.primeMoverMuscle,
    this.primaryEquipment,
    this.shortYoutubeDemonstrationLink,
    this.inDepthYoutubeExplanationLink,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class ExercisesResponseModel {
  final String? message;
  final List<ExerciseModel>? exercises;

  const ExercisesResponseModel({
    this.message,
    this.exercises,
  });

  factory ExercisesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExercisesResponseModelFromJson(json);
}
