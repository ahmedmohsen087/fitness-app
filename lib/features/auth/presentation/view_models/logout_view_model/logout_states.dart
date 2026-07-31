import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';

class LogoutState extends Equatable {
  final BaseState<RegisterResponseEntity> logoutState;

  const LogoutState({this.logoutState = const BaseState()});

  LogoutState copyWith({BaseState<RegisterResponseEntity>? logoutState}) {
    return LogoutState(logoutState: logoutState ?? this.logoutState);
  }

  @override
  List<Object?> get props => [logoutState];
}
