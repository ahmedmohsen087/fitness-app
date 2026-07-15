// test/features/auth/data/repository_impl/auth_repository_impl_test.dart
import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:fitness_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<AuthRemoteDataSourceContract>(),
  MockSpec<AuthManager>(),
])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late MockAuthRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthManager mockAuthManager;
  late AuthRepositoryImpl repository;

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
    mockRemoteDataSource = MockAuthRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    repository = AuthRepositoryImpl(mockRemoteDataSource, mockAuthManager);
  });

  group('forgetPassword', () {
    test(
      'maps a success response to a ForgetPasswordEntity with forget step',
      () async {
        when(
          mockRemoteDataSource.forgetPassword(
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
        mockRemoteDataSource.forgetPassword(
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
          mockRemoteDataSource.verifyOtp(
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
        mockRemoteDataSource.verifyOtp(
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
          mockRemoteDataSource.resetPassword(
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
        mockRemoteDataSource.resetPassword(
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
