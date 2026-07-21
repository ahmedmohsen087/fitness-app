import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/muscles_group/muscles_group_entity.dart';
import 'muscles_group_dto.dart';
part 'muscles_group_response.g.dart';

@JsonSerializable()
class MusclesGroupResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "musclesGroup")
  List<MusclesGroupDto>? musclesGroup;

  MusclesGroupResponse({
    this.message,
    this.musclesGroup,
  });

  factory MusclesGroupResponse.fromJson(Map<String, dynamic> json) => _$MusclesGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesGroupResponseToJson(this);

  MusclesGroupEntity toEntity() {
    return MusclesGroupEntity(
      message: message??'',
      musclesGroup: musclesGroup?.map((e) => e.toEntity()).toList()??[],
    );
  }
}


