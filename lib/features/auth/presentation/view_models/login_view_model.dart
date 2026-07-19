import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/auth/auth_manager.dart';
import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_state/base_state.dart';
import '../../api/request_models/login_request_model.dart';
import '../../domain/entities/login_user_entity.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'login_events.dart';
import 'login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase, this._authManager)
    : super(const LoginState());
  final LoginUseCase _loginUseCase;
  final AuthManager _authManager;

  Future<void> doEvent(LoginEvents event) async {
    switch (event) {
      case LoginRequestEvent():
        await _loginUser(
          loginRequestModel: event.requestModel,
          rememberMe: event.rememberMe,
        );
    }
  }

  Future<void> _loginUser({
    required LoginRequestModel loginRequestModel,
    required bool rememberMe,
  }) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    await _authManager.setRememberMe(rememberMe);
    final response = await _loginUseCase.execute(
      loginRequestModel: loginRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<LoginUserEntity>():
        emit(state.copyWith(loginState: BaseState.success(response.data)));
        break;
      case ErrorBaseResponse<LoginUserEntity>():
        emit(
          state.copyWith(loginState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }
}
