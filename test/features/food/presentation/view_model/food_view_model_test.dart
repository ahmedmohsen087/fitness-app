import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/category_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meal_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meals_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food_details/meal_details_response_entity.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_recommendation_food_use_case.dart';
import 'package:fitness_app/features/food/presentation/view_model/food_events.dart';
import 'package:fitness_app/features/food/presentation/view_model/food_state.dart';
import 'package:fitness_app/features/food/presentation/view_model/food_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_view_model_test.mocks.dart';

@GenerateMocks([
  GetRecommendationFoodUseCase,
  GetMealsByCategoryUseCase,
  GetMealDetailsUseCase,
])
void main() {
  provideDummy<BaseResponse<RecommendationFoodEntity>>(
    ErrorBaseResponse(errorMessage: 'dummy'),
  );
  provideDummy<BaseResponse<MealsEntity>>(
    ErrorBaseResponse(errorMessage: 'dummy'),
  );
  provideDummy<BaseResponse<MealDetailsResponseEntity>>(
    ErrorBaseResponse(errorMessage: 'dummy'),
  );

  late MockGetRecommendationFoodUseCase recommendationFoodUseCase;
  late MockGetMealsByCategoryUseCase mealsByCategoryUseCase;
  late MockGetMealDetailsUseCase mealDetailsUseCase;

  const categories = RecommendationFoodEntity(
    categories: [
      CategoryFoodEntity(
        idCategory: '1',
        strCategory: 'Beef',
        strCategoryThumb: 'beef.png',
        strCategoryDescription: '',
      ),
      CategoryFoodEntity(
        idCategory: '2',
        strCategory: 'Seafood',
        strCategoryThumb: 'seafood.png',
        strCategoryDescription: '',
      ),
    ],
  );
  const beefMeals = MealsEntity(
    meals: [MealEntity(id: '1', name: 'Beef meal', thumbnail: 'beef.jpg')],
  );
  const seafoodMeals = MealsEntity(
    meals: [
      MealEntity(id: '2', name: 'Seafood meal', thumbnail: 'seafood.jpg'),
    ],
  );

  setUp(() {
    recommendationFoodUseCase = MockGetRecommendationFoodUseCase();
    mealsByCategoryUseCase = MockGetMealsByCategoryUseCase();
    mealDetailsUseCase = MockGetMealDetailsUseCase();
  });

  blocTest<FoodViewModel, FoodState>(
    'loads categories then meals for the first category',
    build: () {
      when(
        recommendationFoodUseCase.execute(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: categories));
      when(
        mealsByCategoryUseCase.execute('Beef'),
      ).thenAnswer((_) async => SuccessBaseResponse(data: beefMeals));
      return _buildViewModel(
        recommendationFoodUseCase,
        mealsByCategoryUseCase,
        mealDetailsUseCase,
      );
    },
    act: (viewModel) => viewModel.doEvent(LoadFoodDataEvent()),
    wait: const Duration(milliseconds: 10),
    verify: (viewModel) {
      expect(viewModel.state.selectedCategory, 'Beef');
      expect(viewModel.state.mealsState.data, beefMeals);
      verify(recommendationFoodUseCase.execute()).called(1);
      verify(mealsByCategoryUseCase.execute('Beef')).called(1);
    },
  );

  blocTest<FoodViewModel, FoodState>(
    'selects the category supplied by the Home recommendation route',
    build: () {
      when(
        recommendationFoodUseCase.execute(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: categories));
      when(
        mealsByCategoryUseCase.execute('Seafood'),
      ).thenAnswer((_) async => SuccessBaseResponse(data: seafoodMeals));
      return _buildViewModel(
        recommendationFoodUseCase,
        mealsByCategoryUseCase,
        mealDetailsUseCase,
      );
    },
    act: (viewModel) =>
        viewModel.doEvent(LoadFoodDataEvent(initialCategory: 'Seafood')),
    wait: const Duration(milliseconds: 10),
    verify: (viewModel) {
      expect(viewModel.state.selectedCategory, 'Seafood');
      expect(viewModel.state.mealsState.data, seafoodMeals);
      verify(mealsByCategoryUseCase.execute('Seafood')).called(1);
      verifyNever(mealsByCategoryUseCase.execute('Beef'));
    },
  );

  blocTest<FoodViewModel, FoodState>(
    'loads meals when a different category is selected',
    build: () {
      when(mealsByCategoryUseCase.execute('Seafood')).thenAnswer(
        (_) async => SuccessBaseResponse(data: const MealsEntity(meals: [])),
      );
      return _buildViewModel(
        recommendationFoodUseCase,
        mealsByCategoryUseCase,
        mealDetailsUseCase,
      );
    },
    act: (viewModel) => viewModel.doEvent(SelectFoodCategoryEvent('Seafood')),
    wait: const Duration(milliseconds: 10),
    verify: (viewModel) {
      expect(viewModel.state.selectedCategory, 'Seafood');
      expect(viewModel.state.mealsState.data, const MealsEntity(meals: []));
      verify(mealsByCategoryUseCase.execute('Seafood')).called(1);
    },
  );

  blocTest<FoodViewModel, FoodState>(
    'exposes meal request errors for retry UI',
    build: () {
      when(
        mealsByCategoryUseCase.execute('Seafood'),
      ).thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'offline'));
      return _buildViewModel(
        recommendationFoodUseCase,
        mealsByCategoryUseCase,
        mealDetailsUseCase,
      );
    },
    act: (viewModel) => viewModel.doEvent(SelectFoodCategoryEvent('Seafood')),
    wait: const Duration(milliseconds: 10),
    verify: (viewModel) {
      expect(viewModel.state.mealsState.msg, 'offline');
    },
  );

  blocTest<FoodViewModel, FoodState>(
    'loads meal details using the selected meal ID',
    build: () {
      const details = MealDetailsResponseEntity(meals: []);
      when(
        mealDetailsUseCase.execute('52959'),
      ).thenAnswer((_) async => SuccessBaseResponse(data: details));
      return _buildViewModel(
        recommendationFoodUseCase,
        mealsByCategoryUseCase,
        mealDetailsUseCase,
      );
    },
    act: (viewModel) => viewModel.doEvent(LoadMealDetailsEvent('52959')),
    wait: const Duration(milliseconds: 10),
    verify: (viewModel) {
      expect(
        viewModel.state.mealDetailsState.data,
        const MealDetailsResponseEntity(meals: []),
      );
      verify(mealDetailsUseCase.execute('52959')).called(1);
    },
  );

  test('ignores an older category response that finishes last', () async {
    final beefCompleter = Completer<BaseResponse<MealsEntity>>();
    final seafoodCompleter = Completer<BaseResponse<MealsEntity>>();
    when(
      mealsByCategoryUseCase.execute('Beef'),
    ).thenAnswer((_) => beefCompleter.future);
    when(
      mealsByCategoryUseCase.execute('Seafood'),
    ).thenAnswer((_) => seafoodCompleter.future);
    final viewModel = _buildViewModel(
      recommendationFoodUseCase,
      mealsByCategoryUseCase,
      mealDetailsUseCase,
    );

    viewModel.doEvent(SelectFoodCategoryEvent('Beef'));
    viewModel.doEvent(SelectFoodCategoryEvent('Seafood'));
    seafoodCompleter.complete(SuccessBaseResponse(data: seafoodMeals));
    await Future<void>.delayed(Duration.zero);
    beefCompleter.complete(SuccessBaseResponse(data: beefMeals));
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.selectedCategory, 'Seafood');
    expect(viewModel.state.mealsState.data, seafoodMeals);
    await viewModel.close();
  });
}

FoodViewModel _buildViewModel(
  GetRecommendationFoodUseCase recommendationFoodUseCase,
  GetMealsByCategoryUseCase mealsByCategoryUseCase,
  GetMealDetailsUseCase mealDetailsUseCase,
) {
  return FoodViewModel(
    recommendationFoodUseCase,
    mealsByCategoryUseCase,
    mealDetailsUseCase,
  );
}
