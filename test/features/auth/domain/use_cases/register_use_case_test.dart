import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:fitness_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_use_case_test.mocks.dart';

@GenerateMocks([AuthRepositoryContract])
void main() {
  late MockAuthRepositoryContract mockRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepositoryContract();
    useCase = RegisterUseCase(mockRepository);
    provideDummy<BaseResponse<RegisterResponseEntity>>(
      ErrorBaseResponse(errorMessage: ''),
    );
  });

  final tRegisterParams = RegisterParams(
    firstName: 'Elevate',
    lastName: 'Tech',
    email: 'test@test.com',
    password: 'Test@123',
    rePassword: 'Test@123',
    gender: Gender.male,
    height: 170,
    weight: 70,
    age: 25,
    goal: FitnessGoal.gainWeight,
    activityLevel: ActivityLevel.level1,
  );

  final tRegisterResponseEntity = RegisterResponseEntity(
    message: 'success',
    user: null,
    token: 'test_token',
  );

  group('execute', () {
    test(
      'delegates to repository signUp and returns result unchanged',
      () async {
        when(mockRepository.signUp(tRegisterParams)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tRegisterResponseEntity),
        );

        final result = await useCase.execute(tRegisterParams);

        expect(result, isA<SuccessBaseResponse<RegisterResponseEntity>>());
        verify(mockRepository.signUp(tRegisterParams)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('returns ErrorBaseResponse unchanged from repository', () async {
      when(mockRepository.signUp(tRegisterParams)).thenAnswer(
        (_) async => ErrorBaseResponse(errorMessage: 'Something went wrong'),
      );

      final result = await useCase.execute(tRegisterParams);

      expect(result, isA<ErrorBaseResponse<RegisterResponseEntity>>());
      final error = result as ErrorBaseResponse<RegisterResponseEntity>;
      expect(error.errorMessage, 'Something went wrong');
      verify(mockRepository.signUp(tRegisterParams)).called(1);
    });
  });
}
