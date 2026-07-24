import 'package:equatable/equatable.dart';

import 'meal_ingredient_entity.dart';

class MealDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final String country;
  final String instructions;
  final String thumbnail;
  final List<String> tags;
  final String youtubeUrl;
  final List<MealIngredientEntity> ingredients;

  const MealDetailsEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.country,
    required this.instructions,
    required this.thumbnail,
    required this.tags,
    required this.youtubeUrl,
    required this.ingredients,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    area,
    country,
    instructions,
    thumbnail,
    tags,
    youtubeUrl,
    ingredients,
  ];
}
