import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/home/api/api_client/food_api_client.dart';
import 'package:fitness_app/features/home/api/data_source_impl/food_remote_data_source_impl.dart';
import 'package:fitness_app/features/home/api/models/food/meal_model.dart';
import 'package:fitness_app/features/home/api/models/food/meals_response_model.dart';
import 'package:fitness_app/features/home/api/models/food_details/meal_details_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([FoodApiClient])
void main() {
  late MockFoodApiClient apiClient;
  late FoodRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockFoodApiClient();
    dataSource = FoodRemoteDataSourceImpl(apiClient);
  });

  test('returns meals response when category request succeeds', () async {
    const model = MealsResponseModel(
      meals: [MealModel(id: '1', name: 'Salmon', thumbnail: 'image')],
    );
    when(
      apiClient.getMealsByCategory('Seafood'),
    ).thenAnswer((_) async => model);

    final result = await dataSource.getMealsByCategory('Seafood');

    expect(result, isA<SuccessBaseResponse<MealsResponseModel>>());
    expect(
      (result as SuccessBaseResponse<MealsResponseModel>).data,
      same(model),
    );
    verify(apiClient.getMealsByCategory('Seafood')).called(1);
    verifyNoMoreInteractions(apiClient);
  });

  test('converts Dio failures to an error response', () async {
    when(apiClient.getMealsByCategory('Seafood')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/filter.php'),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await dataSource.getMealsByCategory('Seafood');

    expect(result, isA<ErrorBaseResponse<MealsResponseModel>>());
    expect(
      (result as ErrorBaseResponse<MealsResponseModel>).errorMessage,
      isNotEmpty,
    );
  });

  test('converts generic failures to an error response', () async {
    when(apiClient.getMealsByCategory('Seafood')).thenThrow(StateError('bad'));

    final result = await dataSource.getMealsByCategory('Seafood');

    expect(result, isA<ErrorBaseResponse<MealsResponseModel>>());
    expect(
      (result as ErrorBaseResponse<MealsResponseModel>).errorMessage,
      isNotEmpty,
    );
  });

  test('returns meal details response for the supplied meal ID', () async {
    const model = MealDetailsResponseModel(meals: []);
    when(apiClient.getMealDetails('52959')).thenAnswer((_) async => model);

    final result = await dataSource.getMealDetails('52959');

    expect(result, isA<SuccessBaseResponse<MealDetailsResponseModel>>());
    expect(
      (result as SuccessBaseResponse<MealDetailsResponseModel>).data,
      same(model),
    );
    verify(apiClient.getMealDetails('52959')).called(1);
  });
}
