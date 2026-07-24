import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/food_details/meal_details_entity.dart';
import 'meal_ingredient_model.dart';

@JsonSerializable(createFactory: false, createToJson: false)
class MealDetailsModel {
  final String? id;
  final String? name;
  final String? category;
  final String? area;
  final String? country;
  final String? instructions;
  final String? thumbnail;
  final String? tags;
  final String? youtubeUrl;
  final List<MealIngredientModel> ingredients;

  const MealDetailsModel({
    this.id,
    this.name,
    this.category,
    this.area,
    this.country,
    this.instructions,
    this.thumbnail,
    this.tags,
    this.youtubeUrl,
    this.ingredients = const [],
  });

  factory MealDetailsModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <MealIngredientModel>[];
    for (var index = 1; index <= 20; index++) {
      final name = (json['strIngredient$index'] as String?)?.trim() ?? '';
      if (name.isEmpty) continue;
      final measure = (json['strMeasure$index'] as String?)?.trim() ?? '';
      ingredients.add(MealIngredientModel(name: name, measure: measure));
    }

    return MealDetailsModel(
      id: json['idMeal'] as String?,
      name: json['strMeal'] as String?,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      country: json['strCountry'] as String?,
      instructions: json['strInstructions'] as String?,
      thumbnail: json['strMealThumb'] as String?,
      tags: json['strTags'] as String?,
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }

  MealDetailsEntity toEntity() => MealDetailsEntity(
    id: id ?? '',
    name: name ?? '',
    category: category ?? '',
    area: area ?? '',
    country: country ?? '',
    instructions: instructions ?? '',
    thumbnail: thumbnail ?? '',
    tags:
        tags
            ?.split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList() ??
        const [],
    youtubeUrl: youtubeUrl ?? '',
    ingredients: ingredients
        .map((ingredient) => ingredient.toEntity())
        .toList(),
  );
}
