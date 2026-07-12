import '../../../../config/auth/auth_manager.dart';
import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_state/base_state.dart';
import '../../api/request_models/login_request_model.dart';
import '../../domain/entities/login_user_entity.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'login_events.dart';
import 'login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase, this._authManager)
      : super(const LoginState());
  final LoginUseCase _loginUseCase;
  final AuthManager _authManager;

  void doEvent(LoginEvents event) {
    switch (event) {
      case LoginRequestEvent():
        _loginUser(loginRequestModel: event.requestModel);
        break;
      case RememberMeEvent():
        _rememberMe(event.rememberMe);
        break;
    }
  }

  Future<void> _loginUser({
    required LoginRequestModel loginRequestModel,
  }) async {
    emit(state.copyWith(loginState: BaseState.loading()));
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

  void _rememberMe(bool rememberMe) {
    _authManager.setRememberMe(rememberMe);
  }
}
