import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_use_case.dart';

@GenerateNiceMocks([MockSpec<ForgetPasswordUseCase>()])
import 'forget_password_view_model_test.mocks.dart';

void main() {
  late ForgetPasswordViewModel viewModel;
  late MockForgetPasswordUseCase mockUseCase;

  final tRequestModelWithEmail = ForgetPasswordRequestModel(
    email: 'test@example.com',
  );

  final tRequestModelWithoutEmail = ForgetPasswordRequestModel(email: null);

  const tForgetPasswordEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
    message: 'Success',
  );

  const tErrorMessage = 'Connection Timeout';

  setUp(() {
    mockUseCase = MockForgetPasswordUseCase();
    viewModel = ForgetPasswordViewModel(mockUseCase);

    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      SuccessBaseResponse<ForgetPasswordEntity>(data: tForgetPasswordEntity),
    );
  });

  tearDown(() {
    viewModel.close();
  });

  test(
    'initial state should be ForgetPasswordState with idle/empty base state',
    () {
      expect(viewModel.state, const ForgetPasswordState());
      expect(viewModel.userEmail, isNull);
    },
  );

  group('SendForgetPasswordEmailEvent Tests', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'should emit [loading, success] and save userEmail when send email succeeds',
      build: () {
        when(
          mockUseCase.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doEvent(
        SendForgetPasswordEmailEvent(requestModel: tRequestModelWithEmail),
      ),
      expect: () => [
        ForgetPasswordState(forgetPasswordState: BaseState.loading()),
        ForgetPasswordState(
          forgetPasswordState: BaseState.success(tForgetPasswordEntity),
        ),
      ],
      verify: (_) {
        expect(viewModel.userEmail, 'test@example.com');
        verify(
          mockUseCase.forgetPassword(
            forgetPasswordRequestModel: tRequestModelWithEmail,
          ),
        ).called(1);
      },
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'should emit [loading, error] when send email fails',
      build: () {
        when(
          mockUseCase.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: tErrorMessage,
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doEvent(
        SendForgetPasswordEmailEvent(requestModel: tRequestModelWithEmail),
      ),
      expect: () => [
        ForgetPasswordState(forgetPasswordState: BaseState.loading()),
        ForgetPasswordState(
          forgetPasswordState: BaseState.error(tErrorMessage),
        ),
      ],
    );
  });

  group('VerifyOtpEvent Tests', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'should fallback to saved _userEmail when requestModel email is null',
      build: () {
        when(
          mockUseCase.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );
        when(
          mockUseCase.verifyOtp(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );
        return viewModel;
      },
      seed: () {
        viewModel.doEvent(
          SendForgetPasswordEmailEvent(requestModel: tRequestModelWithEmail),
        );
        return const ForgetPasswordState();
      },
      act: (bloc) =>
          bloc.doEvent(VerifyOtpEvent(requestModel: tRequestModelWithoutEmail)),
      expect: () => [
        ForgetPasswordState(forgetPasswordState: BaseState.loading()),
        ForgetPasswordState(
          forgetPasswordState: BaseState.success(tForgetPasswordEntity),
        ),
      ],
      verify: (_) {
        verify(
          mockUseCase.verifyOtp(
            forgetPasswordRequestModel: argThat(
              predicate<ForgetPasswordRequestModel>(
                (model) => model.email == 'test@example.com',
              ),
              named: 'forgetPasswordRequestModel',
            ),
          ),
        ).called(1);
      },
    );
  });

  group('ResetPasswordEvent Tests', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'should append saved _userEmail to copyWith during reset password',
      build: () {
        when(
          mockUseCase.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );
        when(
          mockUseCase.resetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );
        return viewModel;
      },
      seed: () {
        viewModel.doEvent(
          SendForgetPasswordEmailEvent(requestModel: tRequestModelWithEmail),
        );
        return const ForgetPasswordState();
      },
      act: (bloc) => bloc.doEvent(
        ResetPasswordEvent(requestModel: tRequestModelWithoutEmail),
      ),
      expect: () => [
        ForgetPasswordState(forgetPasswordState: BaseState.loading()),
        ForgetPasswordState(
          forgetPasswordState: BaseState.success(tForgetPasswordEntity),
        ),
      ],
      verify: (_) {
        verify(
          mockUseCase.resetPassword(
            forgetPasswordRequestModel: argThat(
              predicate<ForgetPasswordRequestModel>(
                (model) => model.email == 'test@example.com',
              ),
              named: 'forgetPasswordRequestModel',
            ),
          ),
        ).called(1);
      },
    );
  });
}
