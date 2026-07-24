import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/muscles_group/muscles_entity.dart';

part 'muscles_group_dto.g.dart';

@JsonSerializable()
class MusclesGroupDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "name")
  String? name;

  MusclesGroupDto({this.id, this.name});

  factory MusclesGroupDto.fromJson(Map<String, dynamic> json) =>
      _$MusclesGroupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesGroupDtoToJson(this);
  MusclesEntity toEntity() {
    return MusclesEntity(id: id ?? '', name: name ?? '');
  }
}
