import 'package:json_annotation/json_annotation.dart';

part 'difficulty_level_model.g.dart';

@JsonSerializable()
class DifficultyLevelModel {
  final String? id;
  final String? name;

  const DifficultyLevelModel({
    this.id,
    this.name,
  });

  factory DifficultyLevelModel.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelModelToJson(this);
}

@JsonSerializable()
class DifficultyLevelsResponseModel {
  final String? message;
  final int? totalLevels;
  @JsonKey(name: 'difficulty_levels')
  final List<DifficultyLevelModel>? difficultyLevels;

  const DifficultyLevelsResponseModel({
    this.message,
    this.totalLevels,
    this.difficultyLevels,
  });

  factory DifficultyLevelsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelsResponseModelToJson(this);
}
