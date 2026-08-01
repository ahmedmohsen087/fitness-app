import 'package:json_annotation/json_annotation.dart';

part 'muscle_group_model.g.dart';

@JsonSerializable(createToJson: false)
class MuscleGroupModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;

  const MuscleGroupModel({this.id, this.name});

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class MusclesGroupResponseModel {
  final String? message;
  final List<MuscleGroupModel>? musclesGroup;

  const MusclesGroupResponseModel({this.message, this.musclesGroup});

  factory MusclesGroupResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MusclesGroupResponseModelFromJson(json);
}
