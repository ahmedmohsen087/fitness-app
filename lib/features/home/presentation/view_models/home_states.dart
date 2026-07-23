import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';

import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/category_food/recommendation_food_entity.dart';
import '../../domain/entities/food/meals_entity.dart';
import '../../domain/entities/food_details/meal_details_response_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_entity.dart';

class HomeState extends Equatable {
  final BaseState<RecommendationToDayEntity> recommendationToDayState;
  final BaseState<MusclesGroupEntity> musclesGroupState;
  final BaseState<MusclesGroupByIdEntity> musclesGroupByIdState;
  final BaseState<RecommendationFoodEntity> recommendationFoodState;
  final BaseState<MealsEntity> mealsState;
  final BaseState<MealDetailsResponseEntity> mealDetailsState;
  final String? selectedFoodCategory;

  const HomeState({
    this.recommendationToDayState = const BaseState(),
    this.musclesGroupState = const BaseState(),
    this.musclesGroupByIdState = const BaseState(),
    this.recommendationFoodState = const BaseState(),
    this.mealsState = const BaseState(),
    this.mealDetailsState = const BaseState(),
    this.selectedFoodCategory,
  });

  HomeState copyWith({
    BaseState<RecommendationToDayEntity>? recommendationToDayState,
    BaseState<MusclesGroupEntity>? musclesGroupState,
    BaseState<MusclesGroupByIdEntity>? musclesGroupByIdState,
    BaseState<RecommendationFoodEntity>? recommendationFoodState,
    BaseState<MealsEntity>? mealsState,
    BaseState<MealDetailsResponseEntity>? mealDetailsState,
    String? selectedFoodCategory,
  }) {
    return HomeState(
      recommendationToDayState:
          recommendationToDayState ?? this.recommendationToDayState,
      musclesGroupState: musclesGroupState ?? this.musclesGroupState,
      musclesGroupByIdState:
          musclesGroupByIdState ?? this.musclesGroupByIdState,
      recommendationFoodState:
          recommendationFoodState ?? this.recommendationFoodState,
      mealsState: mealsState ?? this.mealsState,
      mealDetailsState: mealDetailsState ?? this.mealDetailsState,
      selectedFoodCategory: selectedFoodCategory ?? this.selectedFoodCategory,
    );
  }

  @override
  List<Object?> get props => [
    recommendationToDayState,
    musclesGroupState,
    musclesGroupByIdState,
    recommendationFoodState,
    mealsState,
    mealDetailsState,
    selectedFoodCategory,
  ];
}
