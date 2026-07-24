import 'package:equatable/equatable.dart';

import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/category_food/recommendation_food_entity.dart';
import '../../domain/entities/food/meals_entity.dart';
import '../../domain/entities/food_details/meal_details_response_entity.dart';

class FoodState extends Equatable {
  final BaseState<RecommendationFoodEntity> categoriesState;
  final BaseState<MealsEntity> mealsState;
  final BaseState<MealDetailsResponseEntity> mealDetailsState;
  final String? selectedCategory;

  const FoodState({
    this.categoriesState = const BaseState(),
    this.mealsState = const BaseState(),
    this.mealDetailsState = const BaseState(),
    this.selectedCategory,
  });

  FoodState copyWith({
    BaseState<RecommendationFoodEntity>? categoriesState,
    BaseState<MealsEntity>? mealsState,
    BaseState<MealDetailsResponseEntity>? mealDetailsState,
    String? selectedCategory,
  }) {
    return FoodState(
      categoriesState: categoriesState ?? this.categoriesState,
      mealsState: mealsState ?? this.mealsState,
      mealDetailsState: mealDetailsState ?? this.mealDetailsState,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    categoriesState,
    mealsState,
    mealDetailsState,
    selectedCategory,
  ];
}
