import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/auth/domain/entities/register_params.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:fitness_app/features/auth/presentation/view_model/register_events.dart';
import 'package:fitness_app/features/auth/presentation/view_model/register_state.dart';
import 'package:fitness_app/features/auth/presentation/view_model/register_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_view_model_test.mocks.dart';

@GenerateMocks([RegisterUseCase])
void main() {
  late MockRegisterUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockRegisterUseCase();
    provideDummy<BaseResponse<RegisterResponseEntity>>(
      ErrorBaseResponse(errorMessage: ''),
    );
  });

  blocTest<RegisterViewModel, RegisterState>(
    'stores credentials and requests gender navigation every time',
    build: () => RegisterViewModel(mockUseCase),
    act: (viewModel) {
      const event = ContinueToGenderEvent(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@test.com',
        password: 'Test@123',
        rePassword: 'Test@123',
      );
      viewModel.doEvent(event);
      viewModel.doEvent(event);
    },
    verify: (viewModel) {
      expect(viewModel.state.firstName, 'John');
      expect(viewModel.state.navigationTarget, RegisterFlowStep.gender);
      expect(viewModel.state.navigationRequestId, 2);
    },
  );

  blocTest<RegisterViewModel, RegisterState>(
    'stores every profile selection in state',
    build: () => RegisterViewModel(mockUseCase),
    act: (viewModel) {
      viewModel.doEvent(
        const SelectGenderEvent(gender: RegisterConstants.genderMale),
      );
      viewModel.doEvent(const UpdateAgeEvent(age: 26));
      viewModel.doEvent(const UpdateWeightEvent(weight: 71));
      viewModel.doEvent(const UpdateHeightEvent(height: 171));
      viewModel.doEvent(
        const SelectGoalEvent(goal: RegisterConstants.goalGainWeight),
      );
      viewModel.doEvent(
        const SelectActivityLevelEvent(
          activityLevel: RegisterConstants.activityLevel1,
        ),
      );
    },
    verify: (viewModel) {
      expect(viewModel.state.gender, RegisterConstants.genderMale);
      expect(viewModel.state.age, 26);
      expect(viewModel.state.weight, 71);
      expect(viewModel.state.height, 171);
      expect(viewModel.state.goal, RegisterConstants.goalGainWeight);
      expect(viewModel.state.activityLevel, RegisterConstants.activityLevel1);
    },
  );

  blocTest<RegisterViewModel, RegisterState>(
    'submits complete state and emits loading then success',
    build: () {
      when(mockUseCase.execute(any)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const RegisterResponseEntity(token: 'token'),
        ),
      );
      return RegisterViewModel(mockUseCase);
    },
    seed: _completeState,
    act: (viewModel) => viewModel.doEvent(const SubmitRegisterEvent()),
    wait: const Duration(milliseconds: 10),
    expect: () => [
      isA<RegisterState>().having(
        (state) => state.submitState.isLoading,
        'loading',
        isTrue,
      ),
      isA<RegisterState>().having(
        (state) => state.submitState.data?.token,
        'token',
        'token',
      ),
    ],
    verify: (_) {
      final params =
          verify(mockUseCase.execute(captureAny)).captured.single
              as RegisterParams;
      expect(params.firstName, 'John');
      expect(params.gender, RegisterConstants.genderMale);
      expect(params.height, 171);
      expect(params.weight, 71);
      expect(params.age, 26);
      expect(params.goal, RegisterConstants.goalGainWeight);
      expect(params.activityLevel, RegisterConstants.activityLevel1);
    },
  );

  blocTest<RegisterViewModel, RegisterState>(
    'emits loading then error without changing collected values',
    build: () {
      when(mockUseCase.execute(any)).thenAnswer(
        (_) async => ErrorBaseResponse(errorMessage: 'request failed'),
      );
      return RegisterViewModel(mockUseCase);
    },
    seed: _completeState,
    act: (viewModel) => viewModel.doEvent(const SubmitRegisterEvent()),
    wait: const Duration(milliseconds: 10),
    expect: () => [
      isA<RegisterState>().having(
        (state) => state.submitState.isLoading,
        'loading',
        isTrue,
      ),
      isA<RegisterState>().having(
        (state) => state.submitState.msg,
        'error',
        'request failed',
      ),
    ],
    verify: (viewModel) {
      expect(viewModel.state.firstName, 'John');
      expect(viewModel.state.activityLevel, RegisterConstants.activityLevel1);
    },
  );

  blocTest<RegisterViewModel, RegisterState>(
    'does not call the API when required data is incomplete',
    build: () => RegisterViewModel(mockUseCase),
    act: (viewModel) => viewModel.doEvent(const SubmitRegisterEvent()),
    expect: () => [
      isA<RegisterState>().having(
        (state) => state.submitState.msg,
        'validation error',
        isNotNull,
      ),
    ],
    verify: (_) => verifyNever(mockUseCase.execute(any)),
  );

  blocTest<RegisterViewModel, RegisterState>(
    'does not call the API when a measurement is outside its allowed range',
    build: () => RegisterViewModel(mockUseCase),
    seed: () =>
        _completeState().copyWith(age: RegisterConstants.maximumAge + 1),
    act: (viewModel) => viewModel.doEvent(const SubmitRegisterEvent()),
    expect: () => [
      isA<RegisterState>().having(
        (state) => state.submitState.msg,
        'validation error',
        isNotNull,
      ),
    ],
    verify: (_) => verifyNever(mockUseCase.execute(any)),
  );
}

RegisterState _completeState() => const RegisterState(
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@test.com',
  password: 'Test@123',
  rePassword: 'Test@123',
  gender: RegisterConstants.genderMale,
  age: 26,
  weight: 71,
  height: 171,
  goal: RegisterConstants.goalGainWeight,
  activityLevel: RegisterConstants.activityLevel1,
  submitState: BaseState(),
);
