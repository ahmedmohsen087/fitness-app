import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/food/domain/use_cases/get_recommendation_food_use_case.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_entity.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_muscles_group_by_id_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_muscles_group_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_recommendation_to_day_use_case.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_events.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_states.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([
  GetRecommendationToDayUseCase,
  GetMusclesGroupUseCase,
  GetMusclesGroupByIdUseCase,
  GetRecommendationFoodUseCase,
])
void main() {
  late MockGetRecommendationToDayUseCase recommendationToDayUseCase;
  late MockGetMusclesGroupUseCase musclesGroupUseCase;
  late MockGetMusclesGroupByIdUseCase musclesGroupByIdUseCase;
  late MockGetRecommendationFoodUseCase recommendationFoodUseCase;

  const recommendation = RecommendationToDayEntity(
    message: 'success',
    totalMuscles: 0,
    muscles: [],
  );
  const muscleGroups = MusclesGroupEntity(message: 'success', musclesGroup: []);
  const foodCategories = RecommendationFoodEntity(categories: []);

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
  });

  setUp(() {
    recommendationToDayUseCase = MockGetRecommendationToDayUseCase();
    musclesGroupUseCase = MockGetMusclesGroupUseCase();
    musclesGroupByIdUseCase = MockGetMusclesGroupByIdUseCase();
    recommendationFoodUseCase = MockGetRecommendationFoodUseCase();
  });

  blocTest<HomeViewModel, HomeState>(
    'loads Home data and Food recommendation categories',
    setUp: () {
      when(
        recommendationToDayUseCase.execute(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: recommendation));
      when(
        musclesGroupUseCase.execute(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: muscleGroups));
      when(
        recommendationFoodUseCase.execute(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: foodCategories));
    },
    build: () => HomeViewModel(
      recommendationToDayUseCase,
      musclesGroupUseCase,
      musclesGroupByIdUseCase,
      recommendationFoodUseCase,
    ),
    act: (viewModel) => viewModel.doEvent(LoadHomeDataEvent()),
    wait: const Duration(milliseconds: 10),
    verify: (viewModel) {
      expect(viewModel.state.recommendationToDayState.data, recommendation);
      expect(viewModel.state.musclesGroupState.data, muscleGroups);
      expect(viewModel.state.recommendationFoodState.data, foodCategories);
      verify(recommendationFoodUseCase.execute()).called(1);
      verifyNever(musclesGroupByIdUseCase.execute(any));
    },
  );
}
