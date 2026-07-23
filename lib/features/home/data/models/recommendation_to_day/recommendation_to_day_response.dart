import 'package:fitness_app/features/home/data/models/recommendation_to_day/recommendation_to_day_muscle_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';

part 'recommendation_to_day_response.g.dart';

@JsonSerializable()
class RecommendationToDayResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "totalMuscles")
  int? totalMuscles;
  @JsonKey(name: "muscles")
  List<RecommendationToDayMuscleDto>? muscles;

  RecommendationToDayResponse({this.message, this.totalMuscles, this.muscles});

  factory RecommendationToDayResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationToDayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationToDayResponseToJson(this);

  RecommendationToDayEntity toEntity() {
    return RecommendationToDayEntity(
      message: message ?? '',
      totalMuscles: totalMuscles ?? 0,
      muscles: muscles?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
