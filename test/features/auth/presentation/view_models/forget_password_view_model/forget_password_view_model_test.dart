// test/features/auth/presentation/view_models/forget_password_view_model_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ForgetPasswordUseCase>()])
import 'forget_password_view_model_test.mocks.dart';

void main() {
  late MockForgetPasswordUseCase mockUseCase;

  const forgetPasswordRequest = ForgetPasswordEmailRequestModel(
    email: 'test@test.com',
  );
  const verifyOtpRequest = VerifyResetCodeRequestModel(resetCode: '1234');
  const resetPasswordRequest = ResetPasswordRequestModel(
    password: 'old',
    newPassword: 'new',
  );

  const forgetEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
    status: 'success',
  );
  const verifyEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verify,
    status: 'success',
  );
  const resetEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.reset,
    status: 'success',
  );

  setUp(() {
    mockUseCase = MockForgetPasswordUseCase();
  });

  group('SendForgetPasswordEmailEvent', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, success] when forgetPassword succeeds',
      build: () {
        when(
          mockUseCase.forgetPassword(
            forgetPasswordEmailRequestModel: forgetPasswordRequest,
          ),
        ).thenAnswer(
          (_) async =>
              SuccessBaseResponse<ForgetPasswordEntity>(data: forgetEntity),
        );
        return ForgetPasswordViewModel(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(
        SendForgetPasswordEmailEvent(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        ),
      ),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>()
            .having((s) => s.forgetPasswordState.isLoading, 'isLoading', false)
            .having((s) => s.forgetPasswordState.data, 'data', forgetEntity),
      ],
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, error] when forgetPassword fails',
      build: () {
        when(
          mockUseCase.forgetPassword(
            forgetPasswordEmailRequestModel: forgetPasswordRequest,
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: 'network error',
          ),
        );
        return ForgetPasswordViewModel(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(
        SendForgetPasswordEmailEvent(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        ),
      ),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.msg,
          'msg',
          'network error',
        ),
      ],
    );

    test('stores the entered email as userEmail', () async {
      when(
        mockUseCase.forgetPassword(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        ),
      ).thenAnswer(
        (_) async =>
            SuccessBaseResponse<ForgetPasswordEntity>(data: forgetEntity),
      );

      final cubit = ForgetPasswordViewModel(mockUseCase);
      cubit.doEvent(
        SendForgetPasswordEmailEvent(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.userEmail, 'test@test.com');
      await cubit.close();
    });
  });

  group('VerifyOtpEvent', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, success] with verify step when verifyOtp succeeds',
      build: () {
        when(
          mockUseCase.verifyOtp(verifyResetCodeRequestModel: verifyOtpRequest),
        ).thenAnswer(
          (_) async =>
              SuccessBaseResponse<ForgetPasswordEntity>(data: verifyEntity),
        );
        return ForgetPasswordViewModel(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(
        VerifyOtpEvent(verifyResetCodeRequestModel: verifyOtpRequest),
      ),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.data?.forgetPasswordRecoveryStep,
          'step',
          ForgetPasswordRecoveryStep.verify,
        ),
      ],
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, error] when verifyOtp fails',
      build: () {
        when(
          mockUseCase.verifyOtp(verifyResetCodeRequestModel: verifyOtpRequest),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: 'invalid otp',
          ),
        );
        return ForgetPasswordViewModel(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(
        VerifyOtpEvent(verifyResetCodeRequestModel: verifyOtpRequest),
      ),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.msg,
          'msg',
          'invalid otp',
        ),
      ],
    );
  });

  group('ResetPasswordEvent', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, success] with reset step when resetPassword succeeds',
      build: () {
        when(
          mockUseCase.resetPassword(
            resetPasswordRequestModel: resetPasswordRequest,
          ),
        ).thenAnswer(
          (_) async =>
              SuccessBaseResponse<ForgetPasswordEntity>(data: resetEntity),
        );
        return ForgetPasswordViewModel(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(
        ResetPasswordEvent(resetPasswordRequestModel: resetPasswordRequest),
      ),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.data?.forgetPasswordRecoveryStep,
          'step',
          ForgetPasswordRecoveryStep.reset,
        ),
      ],
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, error] when resetPassword fails',
      build: () {
        when(
          mockUseCase.resetPassword(
            resetPasswordRequestModel: resetPasswordRequest,
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: 'passwords do not match',
          ),
        );
        return ForgetPasswordViewModel(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(
        ResetPasswordEvent(resetPasswordRequestModel: resetPasswordRequest),
      ),
      expect: () => [
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.isLoading,
          'isLoading',
          true,
        ),
        isA<ForgetPasswordState>().having(
          (s) => s.forgetPasswordState.msg,
          'msg',
          'passwords do not match',
        ),
      ],
    );
  });
}
