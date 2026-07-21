import 'package:equatable/equatable.dart';

import 'category_food_entity.dart';

class RecommendationFoodEntity extends Equatable {
  final List<CategoryFoodEntity> categories;

  const RecommendationFoodEntity({
    required this.categories,
  });

  @override
  List<Object?> get props => [
    categories,
  ];

}