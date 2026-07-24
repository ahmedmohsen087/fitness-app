import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_muscle_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommendation_to_day_muscle_dto.g.dart';

@JsonSerializable()
class RecommendationToDayMuscleDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "image")
  String? image;

  RecommendationToDayMuscleDto({this.id, this.name, this.image});

  factory RecommendationToDayMuscleDto.fromJson(Map<String, dynamic> json) =>
      _$RecommendationToDayMuscleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationToDayMuscleDtoToJson(this);

  RecommendationToDayMuscleEntity toEntity() {
    return RecommendationToDayMuscleEntity(
      id: id ?? '',
      name: name ?? '',
      image: image ?? '',
    );
  }
}
