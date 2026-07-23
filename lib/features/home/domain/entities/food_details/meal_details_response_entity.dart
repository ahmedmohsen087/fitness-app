import 'package:equatable/equatable.dart';

import 'meal_details_entity.dart';

class MealDetailsResponseEntity extends Equatable {
  final List<MealDetailsEntity> meals;

  const MealDetailsResponseEntity({required this.meals});

  @override
  List<Object?> get props => [meals];
}
