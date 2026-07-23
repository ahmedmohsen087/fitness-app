import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
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
        _userEmail = event.forgetPasswordEmailRequestModel.email;
        _forgetPassword(
          forgetPasswordEmailRequestModel:
              event.forgetPasswordEmailRequestModel,
        );
        break;

      case VerifyOtpEvent():
        _verifyOtp(
          verifyResetCodeRequestModel: event.verifyResetCodeRequestModel,
        );
        break;

      case ResetPasswordEvent():
        _resetPassword(
          resetPasswordRequestModel: event.resetPasswordRequestModel,
        );
        break;
    }
  }

  Future<void> _forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  }) async {
    emit(state.copyWith(forgetPasswordState: BaseState.loading()));
    final response = await _forgetPasswordUseCase.forgetPassword(
      forgetPasswordEmailRequestModel: forgetPasswordEmailRequestModel,
    );
    _handleResponse(response);
  }

  Future<void> _verifyOtp({
    required VerifyResetCodeRequestModel verifyResetCodeRequestModel,
  }) async {
    emit(state.copyWith(forgetPasswordState: BaseState.loading()));

    final verifyResetCode = await _forgetPasswordUseCase.verifyOtp(
      verifyResetCodeRequestModel: verifyResetCodeRequestModel,
    );
    _handleResponse(verifyResetCode);
  }

  Future<void> _resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  }) async {
    emit(state.copyWith(forgetPasswordState: BaseState.loading()));

    final resetPassword = await _forgetPasswordUseCase.resetPassword(
      resetPasswordRequestModel: resetPasswordRequestModel,
    );
    _handleResponse(resetPassword);
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
