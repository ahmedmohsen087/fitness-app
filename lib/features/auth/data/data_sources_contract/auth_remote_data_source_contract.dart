import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  });

  Future<BaseResponse<ForgetPasswordResponseModel>> verifyOtp({
    required VerifyResetCodeRequestModel verifyResetCodeRequestModel,
  });

  Future<BaseResponse<ForgetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  });
}
