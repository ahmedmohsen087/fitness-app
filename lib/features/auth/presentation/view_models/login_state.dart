import 'package:equatable/equatable.dart';

import '../../../../config/base_state/base_state.dart';
import '../../domain/entities/login_user_entity.dart';

class LoginState extends Equatable {
  final BaseState<LoginUserEntity> loginState;

  const LoginState({this.loginState = const BaseState()});

  LoginState copyWith({BaseState<LoginUserEntity>? loginState}) {
    return LoginState(loginState: loginState ?? this.loginState);
  }

  @override
  List<Object?> get props => [loginState];
}
