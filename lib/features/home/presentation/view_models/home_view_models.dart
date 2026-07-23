import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_state/base_state.dart';
import '../../domain/use_cases/get_meal_details_use_case.dart';
import '../../domain/use_cases/get_meals_by_category_use_case.dart';
import '../../domain/use_cases/get_muscles_group_by_id_use_case.dart';
import '../../domain/use_cases/get_muscles_group_use_case.dart';
import '../../domain/use_cases/get_recommendation_food_use_case.dart';
import '../../domain/use_cases/get_recommendation_to_day_use_case.dart';
import 'home_events.dart';
import 'home_states.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetRecommendationToDayUseCase _getRecommendationToDayUseCase;
  final GetMusclesGroupUseCase _getMusclesGroupUseCase;
  final GetMusclesGroupByIdUseCase _getMusclesGroupByIdUseCase;
  final GetRecommendationFoodUseCase _getRecommendationFoodUseCase;
  final GetMealsByCategoryUseCase _getMealsByCategoryUseCase;
  final GetMealDetailsUseCase _getMealDetailsUseCase;

  HomeViewModel(
    this._getRecommendationToDayUseCase,
    this._getMusclesGroupUseCase,
    this._getMusclesGroupByIdUseCase,
    this._getRecommendationFoodUseCase,
    this._getMealsByCategoryUseCase,
    this._getMealDetailsUseCase,
  ) : super(const HomeState());

  String? selectedMuscleGroupId;
  String? _requestedFoodCategory;
  String? _selectedMealId;
  int _mealsRequestId = 0;

  void doEvent(HomeEvent event) {
    switch (event) {
      case LoadHomeDataEvent():
        _loadHomeData();
      case GetMusclesGroupByIdEvent():
        onMuscleGroupSelected(event.id);
      case RetryHomeDataEvent():
        _retryLoadHomeData();
      case LoadFoodDataEvent():
        _loadFoodData(event.initialCategory);
      case SelectFoodCategoryEvent():
        _selectFoodCategory(event.category);
      case RetryFoodDataEvent():
        _retryFoodData();
      case LoadMealDetailsEvent():
        _loadMealDetails(event.mealId);
      case RetryMealDetailsEvent():
        _retryMealDetails();
    }
  }

  void _loadHomeData() {
    _getRecommendationToDay();
    _getMusclesGroup();
    _getRecommendationFood();
  }

  void _retryLoadHomeData() {
    if (state.recommendationToDayState.msg != null) {
      _getRecommendationToDay();
    }

    if (state.musclesGroupState.msg != null) {
      _getMusclesGroup();
    }

    if (state.musclesGroupByIdState.msg != null &&
        selectedMuscleGroupId != null) {
      _getMusclesGroupById(selectedMuscleGroupId!);
    }
    if (state.recommendationFoodState.msg != null) {
      _getRecommendationFood();
    }
  }

  Future<void> _loadFoodData(String? initialCategory) async {
    _requestedFoodCategory = initialCategory;
    await _getRecommendationFood(
      loadFirstCategory: true,
      initialCategory: initialCategory,
    );
  }

  Future<void> _retryFoodData() async {
    if (state.recommendationFoodState.msg != null) {
      await _getRecommendationFood(
        loadFirstCategory: true,
        initialCategory: _requestedFoodCategory,
      );
      return;
    }

    final category = state.selectedFoodCategory;
    if (category != null) {
      await _getMealsByCategory(category);
    }
  }

  Future<void> _getRecommendationToDay() async {
    emit(state.copyWith(recommendationToDayState: BaseState.loading()));

    final response = await _getRecommendationToDayUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            recommendationToDayState: BaseState.success(response.data),
          ),
        );

      case ErrorBaseResponse():
        emit(
          state.copyWith(
            recommendationToDayState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _getMusclesGroup() async {
    emit(state.copyWith(musclesGroupState: BaseState.loading()));

    final response = await _getMusclesGroupUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        final data = response.data;

        emit(state.copyWith(musclesGroupState: BaseState.success(data)));

        if (data.musclesGroup.isNotEmpty) {
          selectedMuscleGroupId = data.musclesGroup.first.id;
          await _getMusclesGroupById(selectedMuscleGroupId!);
        }

      case ErrorBaseResponse():
        emit(
          state.copyWith(
            musclesGroupState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> onMuscleGroupSelected(String id) async {
    selectedMuscleGroupId = id;
    await _getMusclesGroupById(id);
  }

  Future<void> _getMusclesGroupById(String id) async {
    emit(state.copyWith(musclesGroupByIdState: BaseState.loading()));

    final response = await _getMusclesGroupByIdUseCase.execute(id);
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            musclesGroupByIdState: BaseState.success(response.data),
          ),
        );

      case ErrorBaseResponse():
        emit(
          state.copyWith(
            musclesGroupByIdState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _getRecommendationFood({
    bool loadFirstCategory = false,
    String? initialCategory,
  }) async {
    emit(state.copyWith(recommendationFoodState: BaseState.loading()));
    final response = await _getRecommendationFoodUseCase.execute();
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse():
        final categories = response.data.categories;
        emit(
          state.copyWith(
            recommendationFoodState: BaseState.success(response.data),
          ),
        );
        if (loadFirstCategory && categories.isNotEmpty) {
          final requestedCategory = initialCategory?.trim().toLowerCase();
          var categoryToSelect = categories.first.strCategory;

          if (requestedCategory != null && requestedCategory.isNotEmpty) {
            for (final category in categories) {
              if (category.strCategory.toLowerCase() == requestedCategory) {
                categoryToSelect = category.strCategory;
                break;
              }
            }
          }

          await _selectFoodCategory(categoryToSelect);
        }
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            recommendationFoodState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _selectFoodCategory(String category) async {
    emit(state.copyWith(selectedFoodCategory: category));
    await _getMealsByCategory(category);
  }

  Future<void> _getMealsByCategory(String category) async {
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
