import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';

sealed class ForgetPasswordEvents {}

class SendForgetPasswordEmailEvent extends ForgetPasswordEvents {
  final ForgetPasswordRequestModel requestModel;

  SendForgetPasswordEmailEvent({required this.requestModel});
}

class VerifyOtpEvent extends ForgetPasswordEvents {
  final ForgetPasswordRequestModel requestModel;

  VerifyOtpEvent({required this.requestModel});
}

class ResetPasswordEvent extends ForgetPasswordEvents {
  final ForgetPasswordRequestModel requestModel;

  ResetPasswordEvent({required this.requestModel});
}
