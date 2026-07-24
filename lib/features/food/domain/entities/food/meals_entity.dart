import 'package:equatable/equatable.dart';

import 'meal_entity.dart';

class MealsEntity extends Equatable {
  final List<MealEntity> meals;

  const MealsEntity({required this.meals});

  @override
  List<Object?> get props => [meals];
}
