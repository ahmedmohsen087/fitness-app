import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/features/profile/api/request_models/change_password_request_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';

import 'change_password_view_model_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase])
void main() {
  late ChangePasswordViewModel changePasswordViewModel;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  setUp(() {
    mockChangePasswordUseCase = MockChangePasswordUseCase();

    provideDummy<BaseResponse<ChangePasswordEntity>>(
      SuccessBaseResponse(data: ChangePasswordEntity()),
    );

    changePasswordViewModel = ChangePasswordViewModel(
      mockChangePasswordUseCase,
    );
  });

  tearDown(() {
    changePasswordViewModel.close();
  });

  group('ChangePasswordViewModel Tests', () {
    final tEntity = ChangePasswordEntity();
    const tPassword = 'OldPassword123';
    const tNewPassword = 'NewPassword123';

    test('initial state should be ChangePasswordState with default values', () {
      expect(changePasswordViewModel.state, const ChangePasswordState());
    });

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits [autoValidate: true] when EnableAutoValidateEvent is added',
      build: () => changePasswordViewModel,
      act: (viewModel) => viewModel.doEvent(EnableAutoValidateEvent()),
      expect: () => [const ChangePasswordState(autoValidate: true)],
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits [loading, success] when ChangePasswordRequestEvent is successful',
      build: () {
        when(
          mockChangePasswordUseCase.execute(
            changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));
        return changePasswordViewModel;
      },
      act: (viewModel) => viewModel.doEvent(
        ChangePasswordRequestEvent(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ),
      expect: () => [
        ChangePasswordState(changePasswordState: BaseState.loading()),
        ChangePasswordState(changePasswordState: BaseState.success(tEntity)),
      ],
      verify: (_) {
        verify(
          mockChangePasswordUseCase.execute(
            changePasswordRequestModel: argThat(
              predicate<ChangePasswordRequestModel>(
                (model) =>
                    model.password == tPassword &&
                    model.newPassword == tNewPassword,
              ),
              named: 'changePasswordRequestModel',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits [loading, error] when ChangePasswordRequestEvent fails',
      build: () {
        when(
          mockChangePasswordUseCase.execute(
            changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: 'Invalid old password'),
        );
        return changePasswordViewModel;
      },
      act: (viewModel) => viewModel.doEvent(
        ChangePasswordRequestEvent(
          password: tPassword,
          newPassword: tNewPassword,
        ),
      ),
      expect: () => [
        ChangePasswordState(changePasswordState: BaseState.loading()),
        ChangePasswordState(
          changePasswordState: BaseState.error('Invalid old password'),
        ),
      ],
    );
  });
}
