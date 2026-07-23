import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/home/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/home/domain/entities/food/meals_entity.dart';
import 'package:fitness_app/features/home/domain/entities/food_details/meal_details_response_entity.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_entity.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import 'package:fitness_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_meal_details_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_muscles_group_by_id_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_muscles_group_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_recommendation_food_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_recommendation_to_day_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_use_cases_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  late MockHomeRepositoryContract repository;

  setUpAll(() {
    provideDummy<BaseResponse<RecommendationToDayEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<MusclesGroupEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<MusclesGroupByIdEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
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

  setUp(() => repository = MockHomeRepositoryContract());

  test('GetRecommendationToDayUseCase delegates to repository', () async {
    final expected = ErrorBaseResponse<RecommendationToDayEntity>(
      errorMessage: 'failed',
    );
    when(repository.getRecommendationToDay()).thenAnswer((_) async => expected);

    final result = await GetRecommendationToDayUseCase(repository).execute();

    expect(result, same(expected));
    verify(repository.getRecommendationToDay()).called(1);
  });

  test('GetMusclesGroupUseCase delegates to repository', () async {
    final expected = ErrorBaseResponse<MusclesGroupEntity>(
      errorMessage: 'failed',
    );
    when(repository.getMusclesGroup()).thenAnswer((_) async => expected);

    final result = await GetMusclesGroupUseCase(repository).execute();

    expect(result, same(expected));
    verify(repository.getMusclesGroup()).called(1);
  });

  test('GetMusclesGroupByIdUseCase delegates the ID', () async {
    final expected = ErrorBaseResponse<MusclesGroupByIdEntity>(
      errorMessage: 'failed',
    );
    when(repository.getMusclesGroupId('id')).thenAnswer((_) async => expected);

    final result = await GetMusclesGroupByIdUseCase(repository).execute('id');

    expect(result, same(expected));
    verify(repository.getMusclesGroupId('id')).called(1);
  });

  test('GetRecommendationFoodUseCase delegates to repository', () async {
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
