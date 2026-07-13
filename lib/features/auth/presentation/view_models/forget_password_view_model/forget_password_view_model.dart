import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'forget_password_events.dart';
import 'forget_password_states.dart';

@injectable
class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;

  String? _userEmail;

  String? get userEmail => _userEmail;

  ForgetPasswordViewModel(this._forgetPasswordUseCase)
    : super(const ForgetPasswordState());

  void doEvent(ForgetPasswordEvents event) {
    switch (event) {
      case SendForgetPasswordEmailEvent():
        _userEmail = event.requestModel.email;
        _forgetPassword(forgetPasswordRequestModel: event.requestModel);
        break;

      case VerifyOtpEvent():
        _verifyOtp(forgetPasswordRequestModel: event.requestModel);
        break;

      case ResetPasswordEvent():
        _resetPassword(forgetPasswordRequestModel: event.requestModel);
        break;
    }
  }

  Future<void> _forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    emit(state.copyWith(forgetPasswordState: BaseState.loading()));
    final response = await _forgetPasswordUseCase.forgetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    _handleResponse(response);
  }

  Future<void> _verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    emit(state.copyWith(forgetPasswordState: BaseState.loading()));

    final finalRequest = forgetPasswordRequestModel.email == null
        ? forgetPasswordRequestModel.copyWith(email: _userEmail)
        : forgetPasswordRequestModel;

    final response = await _forgetPasswordUseCase.verifyOtp(
      forgetPasswordRequestModel: finalRequest,
    );
    _handleResponse(response);
  }

  Future<void> _resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    emit(state.copyWith(forgetPasswordState: BaseState.loading()));

    final finalRequest = forgetPasswordRequestModel.copyWith(email: _userEmail);

    final response = await _forgetPasswordUseCase.resetPassword(
      forgetPasswordRequestModel: finalRequest,
    );
    _handleResponse(response);
  }

  void _handleResponse(BaseResponse<ForgetPasswordEntity> response) {
    switch (response) {
      case SuccessBaseResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(forgetPasswordState: BaseState.success(response.data)),
        );
        break;
      case ErrorBaseResponse<ForgetPasswordEntity>():
        emit(
          state.copyWith(
            forgetPasswordState: BaseState.error(response.errorMessage),
          ),
        );
        break;
    }
  }
}
