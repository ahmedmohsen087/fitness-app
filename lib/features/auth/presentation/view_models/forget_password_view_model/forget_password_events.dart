import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';

sealed class ForgetPasswordEvents {}

class SendForgetPasswordEmailEvent extends ForgetPasswordEvents {
  final ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel;

  SendForgetPasswordEmailEvent({required this.forgetPasswordEmailRequestModel});
}

class VerifyOtpEvent extends ForgetPasswordEvents {
  final VerifyResetCodeRequestModel verifyResetCodeRequestModel;

  VerifyOtpEvent({required this.verifyResetCodeRequestModel});
}

class ResetPasswordEvent extends ForgetPasswordEvents {
  final ResetPasswordRequestModel resetPasswordRequestModel;

  ResetPasswordEvent({required this.resetPasswordRequestModel});
}
