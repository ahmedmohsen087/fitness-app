import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import 'package:fitness_app/features/home/domain/entities/muscles_group/muscles_group_entity.dart';
import 'package:fitness_app/features/home/domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import 'package:fitness_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_muscles_group_by_id_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_muscles_group_use_case.dart';
import 'package:fitness_app/features/home/domain/use_cases/get_recommendation_to_day_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_use_cases_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  late MockHomeRepositoryContract homeRepository;

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
  });

  setUp(() {
    homeRepository = MockHomeRepositoryContract();
  });

  test('GetRecommendationToDayUseCase delegates to repository', () async {
    final expected = ErrorBaseResponse<RecommendationToDayEntity>(
      errorMessage: 'failed',
    );
    when(
      homeRepository.getRecommendationToDay(),
    ).thenAnswer((_) async => expected);

    final result = await GetRecommendationToDayUseCase(
      homeRepository,
    ).execute();

    expect(result, same(expected));
    verify(homeRepository.getRecommendationToDay()).called(1);
  });

  test('GetMusclesGroupUseCase delegates to repository', () async {
    final expected = ErrorBaseResponse<MusclesGroupEntity>(
      errorMessage: 'failed',
    );
    when(homeRepository.getMusclesGroup()).thenAnswer((_) async => expected);

    final result = await GetMusclesGroupUseCase(homeRepository).execute();

    expect(result, same(expected));
    verify(homeRepository.getMusclesGroup()).called(1);
  });

  test('GetMusclesGroupByIdUseCase delegates the ID', () async {
    final expected = ErrorBaseResponse<MusclesGroupByIdEntity>(
      errorMessage: 'failed',
    );
    when(
      homeRepository.getMusclesGroupId('id'),
    ).thenAnswer((_) async => expected);

    final result = await GetMusclesGroupByIdUseCase(
      homeRepository,
    ).execute('id');

    expect(result, same(expected));
    verify(homeRepository.getMusclesGroupId('id')).called(1);
  });
}
