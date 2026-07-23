import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/auth/api/models/register_response_model.dart';
import 'package:fitness_app/features/auth/api/models/user_model.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/register_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:fitness_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
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

  const forgetPasswordRequest = ForgetPasswordEmailRequestModel(
    email: 'test@test.com',
  );
  const verifyOtpRequest = VerifyResetCodeRequestModel(resetCode: '1234');
  const resetPasswordRequest = ResetPasswordRequestModel(
    password: 'old',
    newPassword: 'new',
  );

  const responseModel = ForgetPasswordResponseModel(
    message: 'ok',
    token: 'tok',
    info: 'info',
    status: 'success',
  );

  setUp(() {
    mockDataSource = MockAuthRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    repository = AuthRepositoryImpl(mockDataSource, mockAuthManager);
    provideDummy<BaseResponse<RegisterResponseModel>>(
      ErrorBaseResponse(errorMessage: ''),
    );
    provideDummy<BaseResponse<ForgetPasswordResponseModel>>(
      ErrorBaseResponse(errorMessage: ''),
    );
  });

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

  group('forgetPassword', () {
    test(
      'maps a success response to a ForgetPasswordEntity with forget step',
      () async {
        when(
          mockDataSource.forgetPassword(
            forgetPasswordEmailRequestModel: forgetPasswordRequest,
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordResponseModel>(
            data: responseModel,
          ),
        );

        final result = await repository.forgetPassword(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        );

        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        final data = (result as SuccessBaseResponse<ForgetPasswordEntity>).data;
        expect(
          data.forgetPasswordRecoveryStep,
          ForgetPasswordRecoveryStep.forget,
        );
        expect(data.message, 'ok');
        expect(data.status, 'success');
      },
    );

    test('propagates the error message on failure', () async {
      when(
        mockDataSource.forgetPassword(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse<ForgetPasswordResponseModel>(
          errorMessage: 'failed',
        ),
      );

      final result = await repository.forgetPassword(
        forgetPasswordEmailRequestModel: forgetPasswordRequest,
      );

      expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
      expect(
        (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
        'failed',
      );
    });
  });

  group('verifyOtp', () {
    test(
      'maps a success response to a ForgetPasswordEntity with verify step',
      () async {
        when(
          mockDataSource.verifyOtp(
            verifyResetCodeRequestModel: verifyOtpRequest,
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordResponseModel>(
            data: responseModel,
          ),
        );

        final result = await repository.verifyOtp(
          verifyResetCodeRequestModel: verifyOtpRequest,
        );

        final data = (result as SuccessBaseResponse<ForgetPasswordEntity>).data;
        expect(
          data.forgetPasswordRecoveryStep,
          ForgetPasswordRecoveryStep.verify,
        );
      },
    );

    test('propagates the error message on failure', () async {
      when(
        mockDataSource.verifyOtp(
          verifyResetCodeRequestModel: verifyOtpRequest,
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse<ForgetPasswordResponseModel>(
          errorMessage: 'bad otp',
        ),
      );

      final result = await repository.verifyOtp(
        verifyResetCodeRequestModel: verifyOtpRequest,
      );

      expect(
        (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
        'bad otp',
      );
    });
  });

  group('resetPassword', () {
    test(
      'maps a success response to a ForgetPasswordEntity with reset step',
      () async {
        when(
          mockDataSource.resetPassword(
            resetPasswordRequestModel: resetPasswordRequest,
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordResponseModel>(
            data: responseModel,
          ),
        );

        final result = await repository.resetPassword(
          resetPasswordRequestModel: resetPasswordRequest,
        );

        final data = (result as SuccessBaseResponse<ForgetPasswordEntity>).data;
        expect(
          data.forgetPasswordRecoveryStep,
          ForgetPasswordRecoveryStep.reset,
        );
      },
    );

    test('propagates the error message on failure', () async {
      when(
        mockDataSource.resetPassword(
          resetPasswordRequestModel: resetPasswordRequest,
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse<ForgetPasswordResponseModel>(
          errorMessage: 'reset failed',
        ),
      );

      final result = await repository.resetPassword(
        resetPasswordRequestModel: resetPasswordRequest,
      );

      expect(
        (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
        'reset failed',
      );
    });
  });
}
