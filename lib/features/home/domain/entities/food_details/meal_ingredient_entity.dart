import 'package:equatable/equatable.dart';

class MealIngredientEntity extends Equatable {
  final String name;
  final String measure;

  const MealIngredientEntity({required this.name, required this.measure});

  @override
  List<Object?> get props => [name, measure];
}
