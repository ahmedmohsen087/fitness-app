import 'package:fitness_app/features/home/data/models/muscles_group/muscles_group_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import 'muscle_by_id_dto.dart';
part 'muscles_group_by_id_response.g.dart';
@JsonSerializable()
class MusclesGroupByIdResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "muscleGroup")
  MusclesGroupDto? musclesGroupDto;
  @JsonKey(name: "muscles")
  List<MuscleByIdDto>? muscles;

  MusclesGroupByIdResponse({
    this.message,
    this.musclesGroupDto,
    this.muscles,
  });

  factory MusclesGroupByIdResponse.fromJson(Map<String, dynamic> json) => _$MusclesGroupByIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesGroupByIdResponseToJson(this);

  MusclesGroupByIdEntity toEntity() {
    return MusclesGroupByIdEntity(
      message: message??'',
      musclesGroupDto: musclesGroupDto!.toEntity(),
      muscles: muscles?.map((e) => e.toEntity()).toList()??[],
    );
  }
}



