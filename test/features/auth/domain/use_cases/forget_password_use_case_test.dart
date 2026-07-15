// test/features/auth/domain/use_cases/forget_password_use_case_test.dart
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthRepositoryContract>()])
import 'forget_password_use_case_test.mocks.dart';

void main() {
  late MockAuthRepositoryContract mockRepository;
  late ForgetPasswordUseCase useCase;

  const forgetPasswordRequest = ForgetPasswordEmailRequestModel(
    email: 'test@test.com',
  );
  const verifyOtpRequest = VerifyResetCodeRequestModel(resetCode: '1234');
  const resetPasswordRequest = ResetPasswordRequestModel(
    password: 'old',
    newPassword: 'new',
  );

  const entity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
    status: 'success',
  );

  setUp(() {
    mockRepository = MockAuthRepositoryContract();
    useCase = ForgetPasswordUseCase(mockRepository);
  });

  test('forgetPassword delegates to the repository exactly once', () async {
    when(
      mockRepository.forgetPassword(
        forgetPasswordEmailRequestModel: forgetPasswordRequest,
      ),
    ).thenAnswer(
      (_) async => SuccessBaseResponse<ForgetPasswordEntity>(data: entity),
    );

    final result = await useCase.forgetPassword(
      forgetPasswordEmailRequestModel: forgetPasswordRequest,
    );

    verify(
      mockRepository.forgetPassword(
        forgetPasswordEmailRequestModel: forgetPasswordRequest,
      ),
    ).called(1);
    expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
  });

  test('verifyOtp delegates to the repository exactly once', () async {
    when(
      mockRepository.verifyOtp(verifyResetCodeRequestModel: verifyOtpRequest),
    ).thenAnswer(
      (_) async => SuccessBaseResponse<ForgetPasswordEntity>(data: entity),
    );

    final result = await useCase.verifyOtp(
      verifyResetCodeRequestModel: verifyOtpRequest,
    );

    verify(
      mockRepository.verifyOtp(verifyResetCodeRequestModel: verifyOtpRequest),
    ).called(1);
    expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
  });

  test('resetPassword delegates to the repository exactly once', () async {
    when(
      mockRepository.resetPassword(
        resetPasswordRequestModel: resetPasswordRequest,
      ),
    ).thenAnswer(
      (_) async => SuccessBaseResponse<ForgetPasswordEntity>(data: entity),
    );

    final result = await useCase.resetPassword(
      resetPasswordRequestModel: resetPasswordRequest,
    );

    verify(
      mockRepository.resetPassword(
        resetPasswordRequestModel: resetPasswordRequest,
      ),
    ).called(1);
    expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
  });

  test('propagates an ErrorBaseResponse coming from the repository', () async {
    when(
      mockRepository.forgetPassword(
        forgetPasswordEmailRequestModel: forgetPasswordRequest,
      ),
    ).thenAnswer(
      (_) async =>
          ErrorBaseResponse<ForgetPasswordEntity>(errorMessage: 'failed'),
    );

    final result = await useCase.forgetPassword(
      forgetPasswordEmailRequestModel: forgetPasswordRequest,
    );

    expect(
      (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
      'failed',
    );
  });
}
