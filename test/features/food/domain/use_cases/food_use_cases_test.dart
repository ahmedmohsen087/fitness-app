import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meals_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food_details/meal_details_response_entity.dart';
import 'package:fitness_app/features/food/domain/repository_contract/food_repository_contract.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_recommendation_food_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_use_cases_test.mocks.dart';

@GenerateMocks([FoodRepositoryContract])
void main() {
  late MockFoodRepositoryContract repository;

  setUpAll(() {
    provideDummy<BaseResponse<RecommendationFoodEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<MealsEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<MealDetailsResponseEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
  });

  setUp(() => repository = MockFoodRepositoryContract());

  test('GetRecommendationFoodUseCase delegates unchanged', () async {
    final expected = ErrorBaseResponse<RecommendationFoodEntity>(
      errorMessage: 'failed',
    );
    when(repository.getRecommendationFood()).thenAnswer((_) async => expected);

    final result = await GetRecommendationFoodUseCase(repository).execute();

    expect(result, same(expected));
    verify(repository.getRecommendationFood()).called(1);
  });

  test('GetMealsByCategoryUseCase delegates the category', () async {
    final expected = ErrorBaseResponse<MealsEntity>(errorMessage: 'failed');
    when(
      repository.getMealsByCategory('Seafood'),
    ).thenAnswer((_) async => expected);

    final result = await GetMealsByCategoryUseCase(
      repository,
    ).execute('Seafood');

    expect(result, same(expected));
    verify(repository.getMealsByCategory('Seafood')).called(1);
  });

  test('GetMealDetailsUseCase delegates the meal ID', () async {
    final expected = ErrorBaseResponse<MealDetailsResponseEntity>(
      errorMessage: 'failed',
    );
    when(repository.getMealDetails('52959')).thenAnswer((_) async => expected);

    final result = await GetMealDetailsUseCase(repository).execute('52959');

    expect(result, same(expected));
    verify(repository.getMealDetails('52959')).called(1);
  });
}
