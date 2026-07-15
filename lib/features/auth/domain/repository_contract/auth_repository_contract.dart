import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  });

  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required VerifyResetCodeRequestModel verifyResetCodeRequestModel,
  });

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  });
}
