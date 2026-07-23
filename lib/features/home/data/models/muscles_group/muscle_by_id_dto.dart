import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/muscles_group/muscle_by_id_entity.dart';

part 'muscle_by_id_dto.g.dart';

@JsonSerializable()
class MuscleByIdDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "image")
  String? image;

  MuscleByIdDto({this.id, this.name, this.image});

  factory MuscleByIdDto.fromJson(Map<String, dynamic> json) =>
      _$MuscleByIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleByIdDtoToJson(this);
  MuscleByIdEntity toEntity() {
    return MuscleByIdEntity(id: id ?? '', name: name ?? '', image: image ?? '');
  }
}
