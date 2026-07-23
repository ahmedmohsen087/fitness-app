sealed class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

class RetryHomeDataEvent extends HomeEvent {}

class GetMusclesGroupByIdEvent extends HomeEvent {
  final String id;

  GetMusclesGroupByIdEvent(this.id);
}

class LoadFoodDataEvent extends HomeEvent {
  final String? initialCategory;

  LoadFoodDataEvent({this.initialCategory});
}

class SelectFoodCategoryEvent extends HomeEvent {
  final String category;

  SelectFoodCategoryEvent(this.category);
}

class RetryFoodDataEvent extends HomeEvent {}

class LoadMealDetailsEvent extends HomeEvent {
  final String mealId;

  LoadMealDetailsEvent(this.mealId);
}

class RetryMealDetailsEvent extends HomeEvent {}
