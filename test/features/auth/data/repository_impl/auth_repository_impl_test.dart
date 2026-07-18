import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/auth/api/models/register_response_model.dart';
import 'package:fitness_app/features/auth/api/models/user_model.dart';
import 'package:fitness_app/features/auth/api/request_models/register_request_model.dart';
import 'package:fitness_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:fitness_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:fitness_app/features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthManager])
void main() {
  late MockAuthRemoteDataSourceContract mockDataSource;
  late MockAuthManager mockAuthManager;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    repository = AuthRepositoryImpl(mockDataSource, mockAuthManager);
    provideDummy<BaseResponse<RegisterResponseModel>>(
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

  final tUserModel = UserModel(
    id: '123',
    firstName: 'Elevate',
    lastName: 'Tech',
    email: 'test@test.com',
    gender: 'male',
    age: 25,
    weight: 70,
    height: 170,
    activityLevel: 'level1',
    goal: 'Gain weight',
    photo: 'default-profile.png',
    createdAt: '2026-07-11T12:38:57.798Z',
  );

  final tRegisterResponseModel = RegisterResponseModel(
    message: 'success',
    user: tUserModel,
    token: 'test_token',
  );

  group('signUp', () {
    test(
      'returns SuccessBaseResponse with entity on success and saves token',
      () async {
        when(mockDataSource.signUp(any)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tRegisterResponseModel),
        );
        when(
          mockAuthManager.setAuthData(token: anyNamed('token')),
        ).thenAnswer((_) async {});

        final result = await repository.signUp(tRegisterParams);

        expect(result, isA<SuccessBaseResponse<RegisterResponseEntity>>());
        final success = result as SuccessBaseResponse<RegisterResponseEntity>;
        expect(success.data.token, 'test_token');
        expect(success.data.user?.firstName, 'Elevate');
        verify(mockAuthManager.setAuthData(token: 'test_token')).called(1);
        final body =
            verify(mockDataSource.signUp(captureAny)).captured.single
                as RegisterRequestModel;
        expect(
          body.toJson(),
          RegisterRequestModel.fromParams(tRegisterParams).toJson(),
        );
        expect(body.gender, Gender.male.apiValue);
        expect(body.goal, FitnessGoal.gainWeight.apiValue);
        expect(body.activityLevel, ActivityLevel.level1.apiValue);
      },
    );

    test('does not save token when token is null', () async {
      final modelWithoutToken = RegisterResponseModel(
        message: 'success',
        user: tUserModel,
        token: null,
      );
      when(
        mockDataSource.signUp(any),
      ).thenAnswer((_) async => SuccessBaseResponse(data: modelWithoutToken));

      await repository.signUp(tRegisterParams);

      verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
    });

    test(
      'returns ErrorBaseResponse and propagates error message on failure',
      () async {
        when(mockDataSource.signUp(any)).thenAnswer(
          (_) async =>
              ErrorBaseResponse(errorMessage: 'No internet connection'),
        );

        final result = await repository.signUp(tRegisterParams);

        expect(result, isA<ErrorBaseResponse<RegisterResponseEntity>>());
        final error = result as ErrorBaseResponse<RegisterResponseEntity>;
        expect(error.errorMessage, 'No internet connection');
        verifyNever(mockAuthManager.setAuthData(token: anyNamed('token')));
      },
    );
  });
}
