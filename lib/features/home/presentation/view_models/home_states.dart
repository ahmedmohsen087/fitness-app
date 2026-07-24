import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';

import '../../../../config/base_state/base_state.dart';
import '../../../food/domain/entities/category_food/recommendation_food_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_entity.dart';

class HomeState extends Equatable {
  final BaseState<RecommendationToDayEntity> recommendationToDayState;
  final BaseState<MusclesGroupEntity> musclesGroupState;
  final BaseState<MusclesGroupByIdEntity> musclesGroupByIdState;
  final BaseState<RecommendationFoodEntity> recommendationFoodState;

  const HomeState({
    this.recommendationToDayState = const BaseState(),
    this.musclesGroupState = const BaseState(),
    this.musclesGroupByIdState = const BaseState(),
    this.recommendationFoodState = const BaseState(),
  });

  HomeState copyWith({
    BaseState<RecommendationToDayEntity>? recommendationToDayState,
    BaseState<MusclesGroupEntity>? musclesGroupState,
    BaseState<MusclesGroupByIdEntity>? musclesGroupByIdState,
    BaseState<RecommendationFoodEntity>? recommendationFoodState,
  }) {
    return HomeState(
      recommendationToDayState:
          recommendationToDayState ?? this.recommendationToDayState,
      musclesGroupState: musclesGroupState ?? this.musclesGroupState,
      musclesGroupByIdState:
          musclesGroupByIdState ?? this.musclesGroupByIdState,
      recommendationFoodState:
          recommendationFoodState ?? this.recommendationFoodState,
    );
  }

  @override
  List<Object?> get props => [
    recommendationToDayState,
    musclesGroupState,
    musclesGroupByIdState,
    recommendationFoodState,
  ];
}
