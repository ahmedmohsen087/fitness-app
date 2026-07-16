import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_state/base_state.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/entities/register_response_entity.dart';
import '../../domain/use_cases/register_use_case.dart';
import 'register_events.dart';
import 'register_state.dart';

@injectable
class RegisterViewModel extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase) : super(const RegisterState());

  void doEvent(RegisterEvents event) {
    switch (event) {
      case ContinueToGenderEvent():
        _continueToGender(event);
      case ContinueRegistrationEvent():
        _continueRegistration(event);
      case SelectGenderEvent():
        _selectGender(event);
      case UpdateAgeEvent():
        emit(state.copyWith(age: event.age));
      case UpdateWeightEvent():
        emit(state.copyWith(weight: event.weight));
      case UpdateHeightEvent():
        emit(state.copyWith(height: event.height));
      case SelectGoalEvent():
        emit(state.copyWith(goal: event.goal));
      case SelectActivityLevelEvent():
        emit(state.copyWith(activityLevel: event.activityLevel));
      case SubmitRegisterEvent():
        _submitRegister();
    }
  }

  void _selectGender(SelectGenderEvent event) {
    emit(state.copyWith(gender: event.gender));
  }

  void _continueToGender(ContinueToGenderEvent event) {
    emit(
      state.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        rePassword: event.rePassword,
        navigationTarget: RegisterFlowStep.gender,
        navigationRequestId: state.navigationRequestId + 1,
      ),
    );
  }

  void _continueRegistration(ContinueRegistrationEvent event) {
    emit(
      state.copyWith(
        navigationTarget: event.target,
        navigationRequestId: state.navigationRequestId + 1,
      ),
    );
  }

  Future<void> _submitRegister() async {
    final params = _createParams();
    if (params == null) {
      emit(
        state.copyWith(
          submitState: BaseState.error(AppStrings.incompleteRegistrationData),
        ),
      );
      return;
    }

    emit(state.copyWith(submitState: BaseState.loading()));
    final result = await _registerUseCase.execute(params);

    switch (result) {
      case SuccessBaseResponse<RegisterResponseEntity>():
        emit(state.copyWith(submitState: BaseState.success(result.data)));
      case ErrorBaseResponse<RegisterResponseEntity>():
        emit(state.copyWith(submitState: BaseState.error(result.errorMessage)));
    }
  }

  RegisterParams? _createParams() {
    final firstName = state.firstName;
    final lastName = state.lastName;
    final email = state.email;
    final password = state.password;
    final rePassword = state.rePassword;
    final gender = state.gender;
    final age = state.age;
    final weight = state.weight;
    final height = state.height;
    final goal = state.goal;
    final activityLevel = state.activityLevel;

    if (firstName == null ||
        firstName.trim().isEmpty ||
        lastName == null ||
        lastName.trim().isEmpty ||
        email == null ||
        email.trim().isEmpty ||
        password == null ||
        password.isEmpty ||
        rePassword == null ||
        rePassword.isEmpty ||
        gender == null ||
        !RegisterConstants.genders.contains(gender) ||
        age == null ||
        age < RegisterConstants.minimumAge ||
        age > RegisterConstants.maximumAge ||
        weight == null ||
        weight < RegisterConstants.minimumWeight ||
        weight > RegisterConstants.maximumWeight ||
        height == null ||
        height < RegisterConstants.minimumHeight ||
        height > RegisterConstants.maximumHeight ||
        goal == null ||
        !RegisterConstants.goals.contains(goal) ||
        activityLevel == null) {
      return null;
    }

    if (!RegisterConstants.activityLevels.contains(activityLevel)) return null;

    return RegisterParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      rePassword: rePassword,
      gender: gender,
      height: height,
      weight: weight,
      age: age,
      goal: goal,
      activityLevel: activityLevel,
    );
  }
}
