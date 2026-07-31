import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_cases/logout_use_case.dart';

@injectable
class LogoutViewModel extends Cubit<LogoutState> {
  LogoutViewModel(this._logoutUseCase, this._authManager)
    : super(const LogoutState());

  final LogoutUseCase _logoutUseCase;
  final AuthManager _authManager;

  void doEvent(LogoutEvents event) {
    switch (event) {
      case LogoutRequestEvent():
        _logoutUser();
        break;
    }
  }

  Future<void> _logoutUser() async {
    emit(state.copyWith(logoutState: BaseState.loading()));
    final response = await _logoutUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse<RegisterResponseEntity>():
        await _authManager.logout();
        emit(state.copyWith(logoutState: BaseState.success(response.data)));
        break;
      case ErrorBaseResponse<RegisterResponseEntity>():
        await _authManager.logout();
        emit(
          state.copyWith(logoutState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }
}
