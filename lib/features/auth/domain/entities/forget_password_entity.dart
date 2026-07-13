import 'package:equatable/equatable.dart';

enum ForgetPasswordRecoveryStep { forget, verify, reset }

class ForgetPasswordEntity extends Equatable {
  final ForgetPasswordRecoveryStep? forgetPasswordRecoveryStep;
  final String? message;
  final String? info;
  final String? status;

  const ForgetPasswordEntity({
    this.forgetPasswordRecoveryStep,
    this.message,
    this.info,
    this.status,
    ForgetPasswordRecoveryStep? forgetForgetPasswordStep,
  });

  @override
  List<Object?> get props => [
    forgetPasswordRecoveryStep,
    message,
    info,
    status,
  ];

  ForgetPasswordEntity copyWith({
    ForgetPasswordRecoveryStep? forgetPasswordRecoveryStep,
    String? message,
    String? info,
    String? status,
  }) {
    return ForgetPasswordEntity(
      forgetPasswordRecoveryStep:
          forgetPasswordRecoveryStep ?? this.forgetPasswordRecoveryStep,
      message: message ?? this.message,
      info: info ?? this.info,
      status: status ?? this.status,
    );
  }
}
