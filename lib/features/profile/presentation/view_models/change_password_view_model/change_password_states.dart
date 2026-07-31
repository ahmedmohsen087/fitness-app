import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';

class ChangePasswordState extends Equatable {
  final BaseState<ChangePasswordEntity> changePasswordState;
  final bool autoValidate;

  const ChangePasswordState({
    this.changePasswordState = const BaseState(),
    this.autoValidate = false,
  });

  ChangePasswordState copyWith({
    BaseState<ChangePasswordEntity>? changePasswordState,
    bool? autoValidate,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
      autoValidate: autoValidate ?? this.autoValidate,
    );
  }

  @override
  List<Object> get props => [changePasswordState, autoValidate];
}
