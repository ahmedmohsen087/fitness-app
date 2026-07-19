import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/login_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/login_user_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:fitness_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepositoryContract])
void main() {
  late MockAuthRepositoryContract repository;
  late LoginUseCase useCase;

  final request = LoginRequestModel(
    email: 'test@example.com',
    password: 'password123',
  );
  final user = LoginUserEntity(
    id: '1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    gender: 'male',
    age: 25,
    weight: 75,
    height: 175,
    activityLevel: 'level1',
    goal: 'Get fitter',
    photo: '',
    createdAt: DateTime(2026),
  );

  setUp(() {
    repository = MockAuthRepositoryContract();
    useCase = LoginUseCase(repository);
    provideDummy<BaseResponse<LoginUserEntity>>(
      ErrorBaseResponse(errorMessage: ''),
    );
  });

  test('delegates login to the repository and returns success', () async {
    when(
      repository.login(loginRequestModel: request),
    ).thenAnswer((_) async => SuccessBaseResponse(data: user));

    final result = await useCase.execute(loginRequestModel: request);

    expect(result, isA<SuccessBaseResponse<LoginUserEntity>>());
    expect((result as SuccessBaseResponse<LoginUserEntity>).data, user);
    verify(repository.login(loginRequestModel: request)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('returns the repository login error unchanged', () async {
    when(repository.login(loginRequestModel: request)).thenAnswer(
      (_) async => ErrorBaseResponse(errorMessage: 'Invalid credentials'),
    );

    final result = await useCase.execute(loginRequestModel: request);

    expect(result, isA<ErrorBaseResponse<LoginUserEntity>>());
    expect(
      (result as ErrorBaseResponse<LoginUserEntity>).errorMessage,
      'Invalid credentials',
    );
    verify(repository.login(loginRequestModel: request)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
