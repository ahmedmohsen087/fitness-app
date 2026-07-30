import 'package:json_annotation/json_annotation.dart';

part 'muscle_model.g.dart';

@JsonSerializable(createToJson: false)
class MuscleModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? image;

  const MuscleModel({
    this.id,
    this.name,
    this.image,
  });

  factory MuscleModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class MusclesResponseModel {
  final String? message;
  final int? totalMuscles;
  final List<MuscleModel>? muscles;

  const MusclesResponseModel({
    this.message,
    this.totalMuscles,
    this.muscles,
  });

  factory MusclesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MusclesResponseModelFromJson(json);
}
