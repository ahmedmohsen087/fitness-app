import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_state/base_state.dart';
import '../../domain/use_cases/get_meal_details_use_case.dart';
import '../../domain/use_cases/get_meals_by_category_use_case.dart';
import '../../domain/use_cases/get_recommendation_food_use_case.dart';
import 'food_events.dart';
import 'food_state.dart';

@injectable
class FoodViewModel extends Cubit<FoodState> {
  final GetRecommendationFoodUseCase _getRecommendationFoodUseCase;
  final GetMealsByCategoryUseCase _getMealsByCategoryUseCase;
  final GetMealDetailsUseCase _getMealDetailsUseCase;

  String? _requestedCategory;
  String? _selectedMealId;
  int _mealsRequestId = 0;

  FoodViewModel(
    this._getRecommendationFoodUseCase,
    this._getMealsByCategoryUseCase,
    this._getMealDetailsUseCase,
  ) : super(const FoodState());

  void doEvent(FoodEvent event) {
    switch (event) {
      case LoadFoodDataEvent():
        _loadFoodData(event.initialCategory);
      case SelectFoodCategoryEvent():
        _selectCategory(event.category);
      case RetryFoodDataEvent():
        _retryFoodData();
      case LoadMealDetailsEvent():
        _loadMealDetails(event.mealId);
      case RetryMealDetailsEvent():
        _retryMealDetails();
    }
  }

  Future<void> _loadFoodData(String? initialCategory) async {
    _requestedCategory = initialCategory;
    emit(state.copyWith(categoriesState: BaseState.loading()));
    final response = await _getRecommendationFoodUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(state.copyWith(categoriesState: BaseState.success(response.data)));
        final category = _resolveCategory(
          response.data.categories.map((item) => item.strCategory),
          initialCategory,
        );
        if (category != null) await _selectCategory(category);
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            categoriesState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  String? _resolveCategory(Iterable<String> categories, String? requested) {
    if (categories.isEmpty) return null;
    final normalized = requested?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return categories.first;
    return categories.firstWhere(
      (category) => category.toLowerCase() == normalized,
      orElse: () => categories.first,
    );
  }

  Future<void> _selectCategory(String category) async {
    emit(state.copyWith(selectedCategory: category));
    await _getMeals(category);
  }

  Future<void> _getMeals(String category) async {
    final requestId = ++_mealsRequestId;
    emit(state.copyWith(mealsState: BaseState.loading()));
    final response = await _getMealsByCategoryUseCase.execute(category);
    if (isClosed || requestId != _mealsRequestId) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(state.copyWith(mealsState: BaseState.success(response.data)));
      case ErrorBaseResponse():
        emit(
          state.copyWith(mealsState: BaseState.error(response.errorMessage)),
        );
    }
  }

  Future<void> _retryFoodData() async {
    if (state.categoriesState.msg != null) {
      await _loadFoodData(_requestedCategory);
      return;
    }
    final category = state.selectedCategory;
    if (category != null) await _getMeals(category);
  }

  Future<void> _loadMealDetails(String mealId) async {
    _selectedMealId = mealId;
    emit(state.copyWith(mealDetailsState: BaseState.loading()));
    final response = await _getMealDetailsUseCase.execute(mealId);
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(mealDetailsState: BaseState.success(response.data)),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            mealDetailsState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _retryMealDetails() async {
    final mealId = _selectedMealId;
    if (mealId != null) await _loadMealDetails(mealId);
  }
}
