import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_muscle_entity.dart';

class RecommendationToDayEntity extends Equatable {
  final String message;
  final int totalMuscles;
  final List<RecommendationToDayMuscleEntity> muscles;

  const RecommendationToDayEntity({
    required this.message,
    required this.totalMuscles,
    required this.muscles,
  });

  @override
  List<Object?> get props => [message, totalMuscles, muscles];
}
