import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/food/api/models/food/meal_model.dart';
import 'package:fitness_app/features/food/api/models/food/meals_response_model.dart';
import 'package:fitness_app/features/food/api/models/food_details/meal_details_model.dart';
import 'package:fitness_app/features/food/api/models/food_details/meal_details_response_model.dart';
import 'package:fitness_app/features/food/data/data_sources_contract/food_remote_data_source_contract.dart';
import 'package:fitness_app/features/food/data/repository_impl/food_repository_impl.dart';
import 'package:fitness_app/features/food/domain/entities/food/meals_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food_details/meal_details_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_repository_impl_test.mocks.dart';

@GenerateMocks([FoodRemoteDataSourceContract])
void main() {
  provideDummy<BaseResponse<MealsResponseModel>>(
    ErrorBaseResponse(errorMessage: 'dummy'),
  );
  provideDummy<BaseResponse<MealDetailsResponseModel>>(
    ErrorBaseResponse(errorMessage: 'dummy'),
  );

  late MockFoodRemoteDataSourceContract dataSource;
  late FoodRepositoryImpl repository;

  setUp(() {
    dataSource = MockFoodRemoteDataSourceContract();
    repository = FoodRepositoryImpl(dataSource);
  });

  test('maps meal models to domain entities', () async {
    when(dataSource.getMealsByCategory('Seafood')).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: MealsResponseModel(
          meals: [
            MealModel(
              id: '7',
              name: 'Fish pie',
              thumbnail: 'image',
              country: 'United Kingdom',
            ),
          ],
        ),
      ),
    );

    final result = await repository.getMealsByCategory('Seafood');

    expect(result, isA<SuccessBaseResponse<MealsEntity>>());
    final meal = (result as SuccessBaseResponse<MealsEntity>).data.meals.single;
    expect(meal.id, '7');
    expect(meal.name, 'Fish pie');
    expect(meal.country, 'United Kingdom');
  });

  test('preserves the data-source error message', () async {
    when(
      dataSource.getMealsByCategory('Seafood'),
    ).thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'offline'));

    final result = await repository.getMealsByCategory('Seafood');

    expect(result, isA<ErrorBaseResponse<MealsEntity>>());
    expect((result as ErrorBaseResponse<MealsEntity>).errorMessage, 'offline');
    verify(dataSource.getMealsByCategory('Seafood')).called(1);
  });

  test('maps meal details models to domain entities', () async {
    when(dataSource.getMealDetails('52959')).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: const MealDetailsResponseModel(
          meals: [
            MealDetailsModel(
              id: '52959',
              name: 'Baked salmon',
              category: 'Seafood',
            ),
          ],
        ),
      ),
    );

    final result = await repository.getMealDetails('52959');

    expect(result, isA<SuccessBaseResponse<MealDetailsResponseEntity>>());
    final meal = (result as SuccessBaseResponse<MealDetailsResponseEntity>)
        .data
        .meals
        .single;
    expect(meal.id, '52959');
    expect(meal.name, 'Baked salmon');
    expect(meal.category, 'Seafood');
  });
}
