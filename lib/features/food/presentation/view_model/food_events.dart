sealed class FoodEvent {}

class LoadFoodDataEvent extends FoodEvent {
  final String? initialCategory;

  LoadFoodDataEvent({this.initialCategory});
}

class SelectFoodCategoryEvent extends FoodEvent {
  final String category;

  SelectFoodCategoryEvent(this.category);
}

class RetryFoodDataEvent extends FoodEvent {}

class LoadMealDetailsEvent extends FoodEvent {
  final String mealId;

  LoadMealDetailsEvent(this.mealId);
}

class RetryMealDetailsEvent extends FoodEvent {}
